using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using R7alaAPI.Data;
using R7alaAPI.DTO;
using R7alaAPI.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace R7alaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class AdminController : ControllerBase
    {
        private readonly ApplicationDBContext _context;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<ApplicationRole> _roleManager;

        public AdminController(
            ApplicationDBContext context,
            UserManager<User> userManager,
            RoleManager<ApplicationRole> roleManager)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _roleManager = roleManager ?? throw new ArgumentNullException(nameof(roleManager));
        }

        [HttpGet("tourguide-applications")]
        public async Task<IActionResult> GetTourGuideApplications()
        {
            var applications = await _context.TourGuideApplications
                .Include(tga => tga.User)
                .Select(tga => new TourGuideApplicationResponseDto
                {
                    Id = tga.Id,
                    UserId = tga.UserId,
                    UserName = $"{tga.User.FirstName} {tga.User.LastName}",
                    Email = tga.User.Email,
                    Bio = tga.Bio,
                    YearsOfExperience = tga.YearsOfExperience,
                    Languages = tga.Languages,
                    HourlyRate = tga.HourlyRate,
                    CVUrl = tga.CVUrl,
                    ProfilePictureUrl = tga.ProfilePictureUrl,
                    Status = tga.Status,
                    AdminComment = tga.AdminComment,
                    SubmittedAt = tga.SubmittedAt,
                    ReviewedAt = tga.ReviewedAt
                })
                .ToListAsync();

            return Ok(applications);
        }

        [HttpPost("tourguide-applications/{id}/approve")]
        public async Task<IActionResult> ApproveTourGuideApplication(int id, [FromBody] AdminCommentDto commentDto)
        {
            var application = await _context.TourGuideApplications
                .Include(tga => tga.User)
                .FirstOrDefaultAsync(tga => tga.Id == id);

            if (application == null)
                return NotFound(new { message = "Application not found" });

            if (application.Status != ApplicationStatus.Pending)
                return BadRequest(new { message = "Application is not in a pending state" });

            // Check if user is already a tour guide
            if (await _context.TourGuides.AnyAsync(tg => tg.UserId == application.UserId))
                return BadRequest(new { message = "User is already a tour guide" });

            // Create TourGuide record
            var tourGuide = new TourGuide
            {
                UserId = application.UserId,
                Bio = application.Bio,
                YearsOfExperience = application.YearsOfExperience,
                Languages = application.Languages,
                HourlyRate = application.HourlyRate,
                IsAvailable = true,
                ProfilePictureUrl = application.ProfilePictureUrl
            };

            // Assign TourGuide role
            var user = application.User;
            var roleExists = await _roleManager.RoleExistsAsync("TourGuide");
            if (!roleExists)
                return StatusCode(500, new { message = "TourGuide role does not exist" });

            var roleResult = await _userManager.AddToRoleAsync(user, "TourGuide");
            if (!roleResult.Succeeded)
                return StatusCode(500, new { message = $"Failed to assign TourGuide role: {string.Join(", ", roleResult.Errors.Select(e => e.Description))}" });

            // Update application
            application.Status = ApplicationStatus.Accepted;
            application.AdminComment = commentDto.Comment;
            application.ReviewedAt = DateTime.UtcNow;

            try
            {
                _context.TourGuides.Add(tourGuide);
                await _context.SaveChangesAsync();
                return Ok(new { message = "Application approved successfully" });
            }
            catch (Exception error)
            {
                // Roll back role assignment if save fails
                await _userManager.RemoveFromRoleAsync(user, "TourGuide");
                return StatusCode(500, new { message = $"Failed to approve application: {error.Message}" });
            }
        }

        [HttpPost("tourguide-applications/{id}/reject")]
        public async Task<IActionResult> RejectTourGuideApplication(int id, [FromBody] AdminCommentDto commentDto)
        {
            var application = await _context.TourGuideApplications
                .FirstOrDefaultAsync(tga => tga.Id == id);

            if (application == null)
                return NotFound(new { message = "Application not found" });

            if (application.Status != ApplicationStatus.Pending)
                return BadRequest(new { message = "Application is not in a pending state" });

            // Update application
            application.Status = ApplicationStatus.Rejected;
            application.AdminComment = commentDto.Comment;
            application.ReviewedAt = DateTime.UtcNow;

            try
            {
                await _context.SaveChangesAsync();
                return Ok(new { message = "Application rejected successfully" });
            }
            catch (Exception error)
            {
                return StatusCode(500, new { message = $"Failed to reject application: {error.Message}" });
            }
        }

        [HttpPost("tourguides/{id}/revoke")]
        public async Task<IActionResult> RevokeTourGuide(int id, [FromBody] AdminCommentDto commentDto)
        {
            var tourGuide = await _context.TourGuides
                .Include(tg => tg.User)
                .FirstOrDefaultAsync(tg => tg.Id == id);

            if (tourGuide == null)
                return NotFound(new { message = "Tour guide not found" });

            var user = tourGuide.User;
            if (user == null)
                return NotFound(new { message = "Associated user not found" });

            // Check if user has TourGuide role
            var isTourGuide = await _userManager.IsInRoleAsync(user, "TourGuide");
            if (!isTourGuide)
                return BadRequest(new { message = "User is not a tour guide" });

            // Start transaction
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // Remove TourGuide role
                var roleResult = await _userManager.RemoveFromRoleAsync(user, "TourGuide");
                if (!roleResult.Succeeded)
                    return StatusCode(500, new { message = $"Failed to remove TourGuide role: {string.Join(", ", roleResult.Errors.Select(e => e.Description))}" });

                // Remove TourGuide record
                _context.TourGuides.Remove(tourGuide);

                // Update latest application to Revoked (if exists)
                var application = await _context.TourGuideApplications
                    .Where(tga => tga.UserId == tourGuide.UserId)
                    .OrderByDescending(tga => tga.SubmittedAt)
                    .FirstOrDefaultAsync();

                if (application != null)
                {
                    application.Status = ApplicationStatus.Revoked;
                    application.AdminComment = commentDto.Comment;
                    application.ReviewedAt = DateTime.UtcNow;
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return Ok(new { message = "Tour guide status revoked successfully" });
            }
            catch (Exception error)
            {
                await transaction.RollbackAsync();
                return StatusCode(500, new { message = $"Failed to revoke tour guide status: {error.Message}" });
            }
        }

        [HttpPost("assign-admin")]
        public async Task<IActionResult> AssignAdminRole([FromBody] AssignAdminRoleDto request)
        {
            // Validate input
            if (request == null || request.UserId <= 0)
                return BadRequest(new { message = "Invalid user ID" });

            // Check if user exists
            var user = await _userManager.FindByIdAsync(request.UserId.ToString());
            if (user == null)
                return NotFound(new { message = "User not found" });

            // Check if user already has Admin role
            if (await _userManager.IsInRoleAsync(user, "Admin"))
                return BadRequest(new { message = "User already has Admin role" });

            // Check if Admin role exists
            var roleExists = await _roleManager.RoleExistsAsync("Admin");
            if (!roleExists)
                return StatusCode(500, new { message = "Admin role does not exist" });

            // Assign Admin role
            var roleResult = await _userManager.AddToRoleAsync(user, "Admin");
            if (!roleResult.Succeeded)
                return StatusCode(500, new { message = $"Failed to assign Admin role: {string.Join(", ", roleResult.Errors.Select(e => e.Description))}" });

            return Ok(new { message = $"Admin role assigned to user {user.Email} successfully" });
        }
    }
}