using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace R7alaAPI.Models
{
    public enum BookingStatus
    {
        Pending,
        Paid,
        Cancelled, 
        Failed
    }

    public class Booking
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int UserId { get; set; }

        [ForeignKey("UserId")]
        public User User { get; set; }

        [Required]
        public int TourGuideId { get; set; }

        [ForeignKey("TourGuideId")]
        public TourGuide TourGuide { get; set; }

        [Required]
        public DateTime BookingDate { get; set; }

        [Required]
        public int DurationHours { get; set; }

        [Required]
        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalAmount { get; set; }

        [Required]
        public BookingStatus BookingStatus { get; set; } 

        public string? StripePaymentIntentId { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}