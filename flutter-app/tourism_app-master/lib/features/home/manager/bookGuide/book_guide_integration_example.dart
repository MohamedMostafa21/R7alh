import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/features/home/data/models/tourguid_model.dart';
import 'package:tourism_app/features/home/manager/bookGuide/cubit/book_guide_cubit.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

/// Example: BookGuideCubit Integration Usage
/// 
/// This file demonstrates how to use the BookGuideCubit integration
/// with the TourGuideDetailsView for a complete booking experience.

class BookGuideIntegrationExample extends StatelessWidget {
  const BookGuideIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookGuide Integration Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BookGuideCubit Integration Features:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            _FeatureCard(
              icon: Icons.event_available,
              title: 'Professional Booking Dialog',
              description: 'Interactive date picker and duration selection',
            ),
            _FeatureCard(
              icon: Icons.attach_money,
              title: 'Real-time Cost Calculation',
              description: 'Dynamic pricing based on hourly rate × hours',
            ),
            _FeatureCard(
              icon: Icons.check_circle,
              title: 'State Management Integration',
              description: 'Loading states, success/error handling',
            ),
            _FeatureCard(
              icon: Icons.feedback,
              title: 'User Feedback System',
              description: 'Snackbars for booking confirmations and errors',
            ),
            SizedBox(height: 24),
            
            // Example Navigation Button
            _ExampleNavigationSection(),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleNavigationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Try the Integration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Navigate to any tour guide details to see the BookGuideCubit integration in action.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          
          // Sample Navigation Button
          ElevatedButton.icon(
            onPressed: () {
              // Create a sample tour guide for demonstration
              final sampleTourGuide = TourGuidModel(
                id: 1,
                firstName: 'John',
                lastName: 'Doe',
                hourlyRate: 50,
                bio: 'Experienced tour guide with 5+ years of expertise',
                languages: ['English', 'Spanish'],
                profilePictureUrl: null,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TourGuideDetailsView(
                    tourGuide: sampleTourGuide,
                  ),
                ),
              );
            },
            icon: Icon(Icons.person_pin),
            label: Text('View Sample Tour Guide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Usage in Different Contexts
/// 
/// 1. **Direct Navigation Example**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => TourGuideDetailsView(
///       tourGuide: yourTourGuideModel,
///     ),
///   ),
/// );
/// ```
/// 
/// 2. **From Tour Guide List Example**
/// ```dart
/// ListView.builder(
///   itemCount: tourGuides.length,
///   itemBuilder: (context, index) {
///     return ListTile(
///       title: Text(tourGuides[index].name),
///       onTap: () => Navigator.push(
///         context,
///         MaterialPageRoute(
///           builder: (context) => TourGuideDetailsView(
///             tourGuide: tourGuides[index],
///           ),
///         ),
///       ),
///     );
///   },
/// )
/// ```
/// 
/// 3. **BookGuideCubit State Monitoring Example**
/// ```dart
/// BlocListener<BookGuideCubit, BookGuideState>(
///   listener: (context, state) {
///     if (state is BookGuideSuccess) {
///       // Handle successful booking
///       showDialog(
///         context: context,
///         builder: (context) => AlertDialog(
///           title: Text('Booking Confirmed'),
///           content: Text('Your tour guide has been booked successfully!'),
///         ),
///       );
///     } else if (state is BookGuideError) {
///       // Handle booking error
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(
///           content: Text('Booking failed: ${state.e}'),
///           backgroundColor: Colors.red,
///         ),
///       );
///     }
///   },
///   child: YourWidget(),
/// )
/// ```
/// 
/// 4. **Manual BookGuideCubit Usage Example**
/// ```dart
/// final bookGuideCubit = BookGuideCubit.of(context);
/// 
/// // Set booking parameters
/// bookGuideCubit.toureGuideId = 123;
/// bookGuideCubit.bookingDate.text = '2024-01-15';
/// bookGuideCubit.durationHOures = 3;
/// 
/// // Execute booking
/// await bookGuideCubit.bookGuide(context: context);
/// ```

/// Integration Flow Summary:
/// 
/// 1. **User Experience Flow**
///    - User views tour guide details
///    - Taps "Book Now" button
///    - Booking dialog appears with guide info
///    - User selects date and duration
///    - Real-time cost calculation updates
///    - User confirms booking
///    - Loading state shows during API call
///    - Success/error feedback via snackbar
/// 
/// 2. **Technical Flow**
///    - TourGuideDetailsView uses BlocBuilder/BlocListener
///    - _showBookingDialog() method handles UI
///    - User input validation before booking
///    - BookGuideCubit.bookGuide() API call
///    - State emissions for UI updates
///    - Automatic cleanup and reset
/// 
/// 3. **Error Handling**
///    - Network errors: Red snackbar with message
///    - Validation errors: Disabled booking button
///    - Loading states: Spinner with "Booking..." text
///    - Success feedback: Green snackbar confirmation
/// 
/// The integration provides a seamless, professional booking experience
/// with proper state management and user feedback throughout the process. 