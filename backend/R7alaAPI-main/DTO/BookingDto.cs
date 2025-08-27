using System;
using R7alaAPI.Models;

namespace R7alaAPI.DTO
{
    public class BookingRequestDto
    {
        public int TourGuideId { get; set; }
        public DateTime BookingDate { get; set; }
        public int DurationHours { get; set; }
    }

    public class BookingResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int TourGuideId { get; set; }
        public string TourGuideName { get; set; }
        public DateTime BookingDate { get; set; }
        public int DurationHours { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; }
        public string StripePaymentIntentId { get; set; }
        public string ClientSecret { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class ConfirmBookingDto
    {
        public string PaymentMethodId { get; set; }
    }
}