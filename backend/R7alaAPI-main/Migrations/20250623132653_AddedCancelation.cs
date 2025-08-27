using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace R7alaAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddedCancelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Status",
                table: "Bookings",
                newName: "BookingStatus");

            migrationBuilder.AlterColumn<string>(
                name: "StripePaymentIntentId",
                table: "Bookings",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "BookingStatus",
                table: "Bookings",
                newName: "Status");

            migrationBuilder.AlterColumn<string>(
                name: "StripePaymentIntentId",
                table: "Bookings",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(100)",
                oldMaxLength: 100,
                oldNullable: true);
        }
    }
}
