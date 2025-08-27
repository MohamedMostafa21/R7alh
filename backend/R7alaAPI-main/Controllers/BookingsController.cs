using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using R7alaAPI.DTO;
using R7alaAPI.Models;
using R7alaAPI.Services;
using System.Threading.Tasks;

namespace R7alaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BookingsController : ControllerBase
    {
        private readonly BookingService _bookingService;
        private readonly UserManager<User> _userManager;

        public BookingsController(BookingService bookingService, UserManager<User> userManager)
        {
            _bookingService = bookingService ?? throw new ArgumentNullException(nameof(bookingService));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
        }

        [HttpPost]
        public async Task<ActionResult<BookingResponseDto>> CreateBooking([FromBody] BookingRequestDto request)
        {
            try
            {
                var userId = int.Parse(_userManager.GetUserId(User));
                var result = await _bookingService.CreateBookingAsync(userId, request);
                return CreatedAtAction(nameof(GetUserBookings), new { userId }, result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("{bookingId}/confirm")]
        public async Task<ActionResult<BookingResponseDto>> ConfirmBooking(int bookingId, [FromBody] ConfirmBookingDto request)
        {
            try
            {
                var userId = int.Parse(_userManager.GetUserId(User));
                var result = await _bookingService.ConfirmBookingAsync(bookingId, userId, request.PaymentMethodId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("{bookingId}/cancel")]
        public async Task<ActionResult<BookingResponseDto>> CancelBooking(int bookingId)
        {
            try
            {
                var userId = int.Parse(_userManager.GetUserId(User));
                var result = await _bookingService.CancelBookingAsync(bookingId, userId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpGet("my-bookings")]
        public async Task<ActionResult<List<BookingResponseDto>>> GetUserBookings()
        {
            try
            {
                var userId = int.Parse(_userManager.GetUserId(User));
                var bookings = await _bookingService.GetUserBookingsAsync(userId);
                return Ok(bookings);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpGet("tourguide-bookings")]
        [Authorize(Roles = "TourGuide")]
        public async Task<ActionResult<List<BookingResponseDto>>> GetTourGuideBookings()
        {
            try
            {
                var userId = int.Parse(_userManager.GetUserId(User));
                var bookings = await _bookingService.GetTourGuideBookingsAsync(userId);
                return Ok(bookings);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}