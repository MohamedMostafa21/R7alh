using Microsoft.EntityFrameworkCore;
using R7alaAPI.Data;
using R7alaAPI.DTO;
using R7alaAPI.Models;
using Stripe;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace R7alaAPI.Services
{
    public class BookingService
    {
        private readonly ApplicationDBContext _context;
        private readonly IConfiguration _configuration;

        public BookingService(ApplicationDBContext context, IConfiguration configuration)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
        }

        public async Task<BookingResponseDto> CreateBookingAsync(int userId, BookingRequestDto request)
        {
            if (request.DurationHours <= 0)
                throw new ArgumentException("Duration must be greater than 0");

            if (request.BookingDate < DateTime.UtcNow)
                throw new ArgumentException("Booking date cannot be in the past");

            var tourGuide = await _context.TourGuides
                .Include(tg => tg.User)
                .FirstOrDefaultAsync(tg => tg.Id == request.TourGuideId);
            if (tourGuide == null)
                throw new Exception("Tour guide not found");
            if (!tourGuide.IsAvailable)
                throw new Exception("Tour guide is not available");

            var user = await _context.Users.FindAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            var totalAmount = tourGuide.HourlyRate * request.DurationHours;
            var amountInCents = (long)(totalAmount * 100);

            var paymentIntentService = new PaymentIntentService();
            var paymentIntent = await paymentIntentService.CreateAsync(new PaymentIntentCreateOptions
            {
                Amount = amountInCents,
                Currency = "usd",
                PaymentMethodTypes = new List<string> { "card" },
                Description = $"Booking for {tourGuide.User.FirstName} {tourGuide.User.LastName} on {request.BookingDate:yyyy-MM-dd}",
                Metadata = new Dictionary<string, string>
                {
                    { "userId", userId.ToString() },
                    { "tourGuideId", request.TourGuideId.ToString() }
                }
            });

            var booking = new Booking
            {
                UserId = userId,
                TourGuideId = request.TourGuideId,
                BookingDate = request.BookingDate,
                DurationHours = request.DurationHours,
                TotalAmount = totalAmount,
                BookingStatus = BookingStatus.Pending,
                StripePaymentIntentId = paymentIntent.Id
            };

            _context.Bookings.Add(booking);
            await _context.SaveChangesAsync();

            return new BookingResponseDto
            {
                Id = booking.Id,
                UserId = userId,
                UserName = $"{user.FirstName} {user.LastName}",
                TourGuideId = tourGuide.Id,
                TourGuideName = $"{tourGuide.User.FirstName} {tourGuide.User.LastName}",
                BookingDate = booking.BookingDate,
                DurationHours = booking.DurationHours,
                TotalAmount = booking.TotalAmount,
                Status = booking.BookingStatus.ToString(),
                StripePaymentIntentId = paymentIntent.Id,
                ClientSecret = paymentIntent.ClientSecret,
                CreatedAt = booking.CreatedAt
            };
        }

        public async Task<BookingResponseDto> ConfirmBookingAsync(int bookingId, int userId, string paymentMethodId)
        {
            var booking = await _context.Bookings
                .Include(b => b.User)
                .Include(b => b.TourGuide)
                .ThenInclude(tg => tg.User)
                .FirstOrDefaultAsync(b => b.Id == bookingId && b.UserId == userId);
            if (booking == null)
                throw new Exception("Booking not found or not authorized");
            if (booking.BookingStatus != BookingStatus.Pending)
                throw new Exception("Booking is not in a pending state");

            var paymentIntentService = new PaymentIntentService();
            var paymentIntent = await paymentIntentService.ConfirmAsync(
                booking.StripePaymentIntentId,
                new PaymentIntentConfirmOptions
                {
                    PaymentMethod = paymentMethodId
                });

            booking.BookingStatus = paymentIntent.Status == "succeeded" ? BookingStatus.Paid : BookingStatus.Failed;
            await _context.SaveChangesAsync();

            return new BookingResponseDto
            {
                Id = booking.Id,
                UserId = booking.UserId,
                UserName = $"{booking.User.FirstName} {booking.User.LastName}",
                TourGuideId = booking.TourGuideId,
                TourGuideName = $"{booking.TourGuide.User.FirstName} {booking.TourGuide.User.LastName}",
                BookingDate = booking.BookingDate,
                DurationHours = booking.DurationHours,
                TotalAmount = booking.TotalAmount,
                Status = booking.BookingStatus.ToString(),
                StripePaymentIntentId = paymentIntent.Id,
                ClientSecret = paymentIntent.ClientSecret,
                CreatedAt = booking.CreatedAt
            };
        }

        public async Task<BookingResponseDto> CancelBookingAsync(int bookingId, int userId)
        {
            var booking = await _context.Bookings 
                .Include(b => b.User)
                .Include(b => b.TourGuide)
                .ThenInclude(tg => tg.User)
                .FirstOrDefaultAsync(b => b.Id == bookingId && b.UserId == userId);
            if (booking == null)
                throw new Exception("Booking not found or not authorized");

            // Check if cancellation is within 48 hours of creation
            var cancellationWindow = booking.CreatedAt.AddHours(48);
            if (DateTime.UtcNow > cancellationWindow)
                throw new Exception("Cancellation is only allowed within 48 hours of booking creation");

            // Prevent canceling already cancelled or failed bookings
            if (booking.BookingStatus == BookingStatus.Cancelled || booking.BookingStatus == BookingStatus.Failed)
                throw new Exception($"Booking is already {booking.BookingStatus.ToString().ToLower()}");

            // Handle Stripe PaymentIntent cancellation or refund
            if (!string.IsNullOrEmpty(booking.StripePaymentIntentId))
            {
                var paymentIntentService = new PaymentIntentService();
                var paymentIntent = await paymentIntentService.GetAsync(booking.StripePaymentIntentId);

                if (paymentIntent.Status == "succeeded")
                {
                    var refundService = new RefundService();
                    try
                    {
                        await refundService.CreateAsync(new RefundCreateOptions
                        {
                            PaymentIntent = booking.StripePaymentIntentId,
                            Reason = "requested_by_customer"
                        });
                    }
                    catch (StripeException ex)
                    {
                        throw new Exception($"Failed to refund payment: {ex.Message}");
                    }
                }
                else if (new[] { "requires_payment_method", "requires_capture", "requires_confirmation", "requires_action", "processing" }.Contains(paymentIntent.Status))
                {
                    try
                    {
                        await paymentIntentService.CancelAsync(booking.StripePaymentIntentId);
                    }
                    catch (StripeException ex)
                    {
                        throw new Exception($"Failed to cancel payment: {ex.Message}");
                    }
                }
                // No action needed if PaymentIntent is already canceled
            }

            // Update booking status
            booking.BookingStatus = BookingStatus.Cancelled;
            await _context.SaveChangesAsync();

            return new BookingResponseDto
            {
                Id = booking.Id,
                UserId = booking.UserId,
                UserName = $"{booking.User.FirstName} {booking.User.LastName}",
                TourGuideId = booking.TourGuideId,
                TourGuideName = $"{booking.TourGuide.User.FirstName} {booking.TourGuide.User.LastName}",
                BookingDate = booking.BookingDate,
                DurationHours = booking.DurationHours,
                TotalAmount = booking.TotalAmount,
                Status = booking.BookingStatus.ToString(),
                StripePaymentIntentId = booking.StripePaymentIntentId,
                ClientSecret = null,
                CreatedAt = booking.CreatedAt
            };
        }

        public async Task<List<BookingResponseDto>> GetUserBookingsAsync(int userId)
        {
            return await _context.Bookings
                .Include(b => b.User)
                .Include(b => b.TourGuide)
                .ThenInclude(tg => tg.User)
                .Where(b => b.UserId == userId)
                .OrderByDescending(b => b.CreatedAt)
                .Select(b => new BookingResponseDto
                {
                    Id = b.Id,
                    UserId = b.UserId,
                    UserName = $"{b.User.FirstName} {b.User.LastName}",
                    TourGuideId = b.TourGuideId,
                    TourGuideName = $"{b.TourGuide.User.FirstName} {b.TourGuide.User.LastName}",
                    BookingDate = b.BookingDate,
                    DurationHours = b.DurationHours,
                    TotalAmount = b.TotalAmount,
                    Status = b.BookingStatus.ToString(),
                    StripePaymentIntentId = b.StripePaymentIntentId,
                    ClientSecret = null,
                    CreatedAt = b.CreatedAt
                })
                .ToListAsync();
        }

        public async Task<List<BookingResponseDto>> GetTourGuideBookingsAsync(int tourGuideUserId)
        {
            var tourGuide = await _context.TourGuides
                .FirstOrDefaultAsync(tg => tg.UserId == tourGuideUserId);
            if (tourGuide == null)
                throw new Exception("Tour guide not found");

            return await _context.Bookings
                .Include(b => b.User)
                .Include(b => b.TourGuide)
                .ThenInclude(tg => tg.User)
                .Where(b => b.TourGuideId == tourGuide.Id)
                .OrderByDescending(b => b.CreatedAt)
                .Select(b => new BookingResponseDto
                {
                    Id = b.Id,
                    UserId = b.UserId,
                    UserName = $"{b.User.FirstName} {b.User.LastName}",
                    TourGuideId = b.TourGuideId,
                    TourGuideName = $"{b.TourGuide.User.FirstName} {b.TourGuide.User.LastName}",
                    BookingDate = b.BookingDate,
                    DurationHours = b.DurationHours,
                    TotalAmount = b.TotalAmount,
                    Status = b.BookingStatus.ToString(),
                    StripePaymentIntentId = b.StripePaymentIntentId,
                    ClientSecret = null,
                    CreatedAt = b.CreatedAt
                })
                .ToListAsync();
        }
    }
}