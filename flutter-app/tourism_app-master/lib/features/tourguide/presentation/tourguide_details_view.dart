import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/review_dialog.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/features/home/data/models/review_model.dart';
import 'package:tourism_app/features/home/data/models/tourguid_model.dart';
import 'package:tourism_app/features/home/manager/reviews/cubit/reviews_cubit.dart';
import 'package:tourism_app/features/home/manager/bookGuide/cubit/book_guide_cubit.dart';

class TourGuideDetailsView extends StatefulWidget {
  final TourGuidModel tourGuide;

  const TourGuideDetailsView({
    super.key,
    required this.tourGuide,
  });

  @override
  State<TourGuideDetailsView> createState() => _TourGuideDetailsViewState();
}

class _TourGuideDetailsViewState extends State<TourGuideDetailsView> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.tourGuide.isFavorited ?? false;

    // Load reviews for this tour guide
    if (widget.tourGuide.id != null) {
      ReviewsCubit.of(context).getReviews(
        context: context,
        entityName: 'tourguide',
        entityId: widget.tourGuide.id!.toInt(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: '${widget.tourGuide.firstName ?? ''} ${widget.tourGuide.lastName ?? ''}'.trim(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Stack(
                children: [
                  // Profile Image
                  CacheImage(
                    imageUrl: widget.tourGuide.profilePictureUrl != null ? '${EndPoints.domain}${widget.tourGuide.profilePictureUrl}' : '',
                    errorColor: Colors.grey[300]!,
                    width: double.infinity,
                    height: 300,
                    boxFit: BoxFit.cover,
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // Profile Info Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.tourGuide.firstName ?? ''} ${widget.tourGuide.lastName ?? ''}'.trim(),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorited = !isFavorited;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorited ? Colors.red : Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              widget.tourGuide.city ?? 'Unknown City',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              widget.tourGuide.stars?.toStringAsFixed(1) ?? '0.0',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Availability Badge
                  if (widget.tourGuide.isAvailable == true)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.work_outline,
                          title: 'Experience',
                          value: '${widget.tourGuide.yearsOfExperience ?? 0} years',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.attach_money,
                          title: 'Hourly Rate',
                          value: '\$${widget.tourGuide.hourlyRate ?? 0}/hr',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Languages Section
                  if (widget.tourGuide.languages != null && widget.tourGuide.languages!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Languages',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.tourGuide.languages!.map((language) {
                            return Chip(
                              label: Text(
                                language,
                                style: TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              side: BorderSide(color: Theme.of(context).primaryColor),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                  // Bio Section
                  if (widget.tourGuide.bio != null && widget.tourGuide.bio!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.tourGuide.bio!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                  // Reviews Section
                  ReviewingSection(
                    entityName: 'tourguide',
                    entityId: widget.tourGuide.id?.toInt() ?? -1,
                  ),

                  SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),

      // Book Button with BookGuideCubit Integration
      bottomNavigationBar: BlocListener<BookGuideCubit, BookGuideState>(
        listener: (context, state) {
          if (state is BookGuideSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tour guide booked successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is BookGuideError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking failed: ${state.e}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BlocBuilder<BookGuideCubit, BookGuideState>(
            builder: (context, state) {
              return CustomTextButton(
                width: double.infinity,
                onPress: state is BookGuideLoading ? null : () => _showBookingDialog(context),
                child: state is BookGuideLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Booking...',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      )
                    : Text(
                        'Book Now - \$${widget.tourGuide.hourlyRate ?? 0}/hr',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

// Enhanced Booking Dialog Method
  void _showBookingDialog(BuildContext context) {
    final bookingDateController = TextEditingController();
    int selectedDuration = 1;
    DateTime? selectedDate;
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Book Tour Guide',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tour Guide Info Card
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: widget.tourGuide.profilePictureUrl != null
                                        ? NetworkImage('${EndPoints.domain}${widget.tourGuide.profilePictureUrl}')
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: widget.tourGuide.profilePictureUrl == null ? Icon(Icons.person, color: Colors.grey[600], size: 24) : null,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.tourGuide.firstName ?? ''} ${widget.tourGuide.lastName ?? ''}'.trim(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '\$${widget.tourGuide.hourlyRate ?? 0}/hour',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            // Date and Time Row
                            Row(
                              children: [
                                // Date Selection
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime? pickedDate = await showDatePicker(
                                            context: dialogContext,
                                            initialDate: DateTime.now().add(Duration(days: 1)),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(Duration(days: 365)),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Theme.of(context).primaryColor,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: Colors.black87,
                                                  ),
                                                  dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              selectedDate = pickedDate;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey[300]!),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Theme.of(context).primaryColor,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : 'date',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: selectedDate != null ? Colors.black87 : Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Time Selection
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          final TimeOfDay? pickedTime = await showTimePicker(
                                            context: dialogContext,
                                            initialTime: selectedTime,
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Theme.of(context).primaryColor,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: Colors.black87,
                                                  ),
                                                  dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              selectedTime = pickedTime;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey[300]!),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Theme.of(context).primaryColor,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  selectedTime.format(dialogContext),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            // Duration Selection
                            Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: selectedDuration,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: List.generate(12, (index) => index + 1)
                                      .map((hour) => DropdownMenuItem<int>(
                                            value: hour,
                                            child: Text('$hour hour${hour > 1 ? 's' : ''}'),
                                          ))
                                      .toList(),
                                  onChanged: (int? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedDuration = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Total Cost
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Cost:',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '\$${(widget.tourGuide.hourlyRate ?? 0) * selectedDuration}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey[400]!),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: selectedDate == null
                                  ? null
                                  : () {
                                      // Create the booking data in the required format
                                      final bookingDateTime = DateTime(
                                        selectedDate!.year,
                                        selectedDate!.month,
                                        selectedDate!.day,
                                        selectedTime.hour,
                                        selectedTime.minute,
                                      );

                                      final bookingData = {
                                        "tourGuideId": widget.tourGuide.id?.toInt() ?? 0,
                                        "bookingDate": bookingDateTime.toIso8601String(),
                                        "durationHours": selectedDuration,
                                      };

                                      // Set cubit values
                                      final bookGuideCubit = BookGuideCubit.of(context);
                                      bookGuideCubit.toureGuideId = bookingData["tourGuideId"] as int;
                                      bookGuideCubit.bookingDate.text = bookingData["bookingDate"] as String;
                                      bookGuideCubit.durationHOures = bookingData["durationHours"] as int;

                                      // Close dialog and book
                                      Navigator.of(dialogContext).pop();
                                      bookGuideCubit.bookGuide(context: context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Helper Widgets
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).primaryColor,
                    ),
              ),
              child: child!,
            );
          },
        );
        onDateSelected(pickedDate);
      },
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: Colors.grey[600], size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' : 'Tap to select date',
                style: TextStyle(
                  fontSize: 14,
                  color: selectedDate != null ? Colors.grey[800] : Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required Function(TimeOfDay?) onTimeSelected,
  }) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).primaryColor,
                    ),
              ),
              child: child!,
            );
          },
        );
        onTimeSelected(pickedTime);
      },
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: Colors.grey[600], size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedTime.format(context),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector({
    required int selectedDuration,
    required Function(int?) onDurationChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedDuration,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[600], size: 20),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          items: List.generate(12, (index) => index + 1)
              .map((hour) => DropdownMenuItem<int>(
                    value: hour,
                    child: Text('$hour hour${hour > 1 ? 's' : ''}'),
                  ))
              .toList(),
          onChanged: onDurationChanged,
        ),
      ),
    );
  }

  Widget _buildTotalCostCard({
    required BuildContext context,
    required double hourlyRate,
    required int duration,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Cost',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '$duration hour${duration > 1 ? 's' : ''} × \$${hourlyRate.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          Text(
            '\$${(hourlyRate * duration).toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewingSection extends StatefulWidget {
  const ReviewingSection({
    super.key,
    required this.entityName,
    required this.entityId,
  });
  final String entityName;
  final int entityId;

  @override
  State<ReviewingSection> createState() => _ReviewingSectionState();
}

class _ReviewingSectionState extends State<ReviewingSection> {
  @override
  void initState() {
    ReviewsCubit.of(context).getReviews(
      context: context,
      entityName: widget.entityName,
      entityId: widget.entityId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => ReviewDialog.show(
                context: context,
                entityName: widget.entityName,
                entityId: widget.entityId,
                entityTitle: '',
                onReviewSubmitted: () async {
                  await ReviewsCubit.of(context).getReviews(
                    context: context,
                    entityName: widget.entityName,
                    entityId: widget.entityId,
                  );
                },
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Reviews List
        BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is ReviewsGetError) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Error loading reviews',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ReviewsCubit.of(context).getReviews(
                          context: context,
                          entityName: 'tourguide',
                          entityId: widget.entityId,
                        );
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ReviewsGetSuccess) {
              final reviews = state.reviews;
              final reviewCount = reviews.data?.length ?? 0;
              final averageRating = ReviewsCubit.of(context).averageRating;

              if (reviewCount == 0) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'No reviews yet. Be the first to leave a review!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reviews Summary
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${averageRating.toStringAsFixed(1)} ($reviewCount review${reviewCount > 1 ? 's' : ''})',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // Reviews List
                  ...reviews.data!.map((review) => _ReviewCard(review: review)),
                ],
              );
            }

            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'No reviews yet. Be the first to leave a review!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewData review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Profile Picture
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: review.profilePictureUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CacheImage(
                          imageUrl: '${EndPoints.domain}${review.profilePictureUrl}',
                          width: 40,
                          height: 40,
                          boxFit: BoxFit.cover,
                          errorColor: Colors.grey[300]!,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 24,
                      ),
              ),
              SizedBox(width: 12),

              // User Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Anonymous',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: index < (review.rating ?? 0) ? Colors.amber : Colors.grey[300],
                          );
                        }),
                        SizedBox(width: 8),
                        Text(
                          '${review.rating ?? 0}/5',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Date
              Text(
                review.createdAt != null ? _formatDate(review.createdAt!) : '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              review.comment!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
