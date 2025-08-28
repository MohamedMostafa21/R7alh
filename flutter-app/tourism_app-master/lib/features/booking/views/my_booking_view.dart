import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/booking/views/manager/cubit/my_booking_cubit.dart';
import 'package:tourism_app/features/home/data/models/booking_model.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

class MyBookingView extends StatefulWidget {
  const MyBookingView({super.key});

  @override
  State<MyBookingView> createState() => _MyBookingViewState();
}

class _MyBookingViewState extends State<MyBookingView> {
  @override
  void initState() {
    super.initState();
    // Load bookings when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyBookingCubit.of(context).getMyBooking(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: shareAppBar(
        context,
        nameAppBar: 'My Bookings',
      ),
      body: BlocBuilder<MyBookingCubit, MyBookingState>(
        builder: (context, state) {
          if (state is MyBookingLoading) {
            return _buildLoadingState();
          } else if (state is MyBookingError) {
            return _buildErrorState(state.e);
          } else if (state is MyBookingSuccess || ConstantsModels.myBooking != null) {
            return _buildSuccessState();
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your bookings...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load bookings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                MyBookingCubit.of(context).getMyBooking(context: context);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.book_online_outlined,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Bookings Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t made any bookings yet.\nStart exploring and book your first tour guide!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to explore
              },
              icon: const Icon(Icons.explore),
              label: const Text('Start Exploring'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    final bookings = ConstantsModels.myBooking ?? [];

    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        MyBookingCubit.of(context).getMyBooking(context: context);
      },
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            booking: booking,
            onTap: () => _showBookingDetails(context, booking),
          );
        },
      ),
    );
  }

  void _showBookingDetails(BuildContext context, BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingDetailsSheet(booking: booking),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and booking ID
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(booking.status),
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${booking.id ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tour Guide Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.tourGuideName ?? 'Unknown Guide',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Tour Guide',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to tour guide details
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => TourguideDetailsView(
                      //       tourGuide: tourGuideModel,
                      //     ),
                      //   ),
                      // );
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Booking Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Booking Date',
                      _formatDate(booking.bookingDate),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.access_time,
                      'Duration',
                      '${booking.durationHours ?? 0} hours',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.attach_money,
                      'Total Amount',
                      '\$${booking.totalAmount ?? 0}',
                      valueColor: Colors.green[700],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (booking.status?.toLowerCase() == 'pending') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement cancel booking
                          _showCancelBookingDialog(context, booking);
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.grey[800],
              ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not specified';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _showCancelBookingDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your booking with ${booking.tourGuideName ?? 'this tour guide'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement cancel booking API call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancellation feature coming soon!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}

class BookingDetailsSheet extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsSheet({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Booking Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(booking.status).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(booking.status),
                          color: _getStatusColor(booking.status),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getStatusText(booking.status),
                              style: TextStyle(
                                color: _getStatusColor(booking.status),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Booking ID: ${booking.id ?? 'N/A'}',
                              style: TextStyle(
                                color: _getStatusColor(booking.status).withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tour Guide Section
                  _buildSection(
                    context,
                    'Tour Guide Information',
                    [
                      _buildDetailTile(
                        context,
                        Icons.person,
                        'Name',
                        booking.tourGuideName ?? 'Unknown',
                      ),
                      _buildDetailTile(
                        context,
                        Icons.badge,
                        'Guide ID',
                        booking.tourGuideId?.toString() ?? 'N/A',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Booking Information Section
                  _buildSection(
                    context,
                    'Booking Information',
                    [
                      _buildDetailTile(
                        context,
                        Icons.calendar_today,
                        'Booking Date',
                        _formatDetailDate(booking.bookingDate),
                      ),
                      _buildDetailTile(
                        context,
                        Icons.access_time,
                        'Duration',
                        '${booking.durationHours ?? 0} hours',
                      ),
                      _buildDetailTile(
                        context,
                        Icons.person_outline,
                        'Booked by',
                        booking.userName ?? 'Unknown',
                      ),
                      _buildDetailTile(
                        context,
                        Icons.today,
                        'Created on',
                        _formatDetailDate(booking.createdAt),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Payment Information Section
                  _buildSection(
                    context,
                    'Payment Information',
                    [
                      _buildDetailTile(
                        context,
                        Icons.attach_money,
                        'Total Amount',
                        '\$${booking.totalAmount ?? 0}',
                        valueColor: Colors.green[700],
                      ),
                      if (booking.stripePaymentIntentId != null)
                        _buildDetailTile(
                          context,
                          Icons.payment,
                          'Payment ID',
                          booking.stripePaymentIntentId!,
                        ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (booking.status?.toLowerCase() == 'confirmed') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Contact tour guide functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contact feature coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.message_outlined),
                        label: const Text('Contact Tour Guide'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<MyBookingCubit, MyBookingState>(
                      listener: (context, state) {
                        if (state is ConfirmBookingSuccess) {
                          Navigator.of(context).pop(); // Close the details sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('Booking confirmed successfully!'),
                                ],
                              ),
                              backgroundColor: Colors.green[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                          // Refresh the bookings list
                          MyBookingCubit.of(context).getMyBooking(context: context);
                        } else if (state is ConfirmBookingError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(child: Text('Failed to confirm booking: ${state.e}')),
                                ],
                              ),
                              backgroundColor: Colors.red[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is ConfirmBookingLoading;

                        return OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await MyBookingCubit.of(context).confirmBooking(context: context, bookingId: booking.id?.toInt() ?? -1);
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isLoading ? Colors.grey[400] : Theme.of(context).primaryColor,
                            side: BorderSide(color: isLoading ? Colors.grey[300]! : Theme.of(context).primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.grey[400]!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Confirming...',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Confirm order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTile(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.grey[800],
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return 'Booking Confirmed';
      case 'pending':
        return 'Awaiting Confirmation';
      case 'cancelled':
        return 'Booking Cancelled';
      case 'completed':
        return 'Trip Completed';
      default:
        return 'Status Unknown';
    }
  }

  String _formatDetailDate(String? dateString) {
    if (dateString == null) return 'Not specified';
    try {
      final date = DateTime.parse(dateString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]} ${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
