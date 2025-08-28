import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
import 'package:tourism_app/features/home/manager/reviews/cubit/reviews_cubit.dart';

class ReviewDialog {
  static void show({
    required BuildContext context,
    required String entityName,
    required int entityId,
    String? entityTitle,
    Function()? onReviewSubmitted,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ReviewDialogContent(
        entityName: entityName,
        entityId: entityId,
        entityTitle: entityTitle,
        onReviewSubmitted: onReviewSubmitted,
      ),
    );
  }
}

class _ReviewDialogContent extends StatefulWidget {
  final String entityName;
  final int entityId;
  final String? entityTitle;
  final Function()? onReviewSubmitted;

  const _ReviewDialogContent({
    required this.entityName,
    required this.entityId,
    this.entityTitle,
    this.onReviewSubmitted,
  });

  @override
  State<_ReviewDialogContent> createState() => _ReviewDialogContentState();
}

class _ReviewDialogContentState extends State<_ReviewDialogContent> with TickerProviderStateMixin {
  double _rating = 3.0;
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String get _entityDisplayName {
    switch (widget.entityName.toLowerCase()) {
      case 'tourguide':
        return 'tour guide';
      case 'place':
        return 'place';
      case 'hotel':
        return 'hotel';
      case 'restaurant':
        return 'restaurant';
      case 'plan':
        return 'plan';
      default:
        return widget.entityName;
    }
  }

  String get _ratingDescription {
    switch (_rating.toInt()) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Rate this $_entityDisplayName';
    }
  }

  Color get _ratingColor {
    switch (_rating.toInt()) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _submitReview() {
    if (!_formKey.currentState!.validate()) return;

    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      _showSnackBar('Please write a comment', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    ReviewsCubit.of(context).createReview(
      context: context,
      entityName: widget.entityName,
      entityId: widget.entityId,
      rate: _rating.toInt(),
      comment: comment,
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.rate_review,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write a Review',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                     
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating Section
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'How would you rate this ?',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),

                              // Rating Stars
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 40,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() => _rating = rating);
                                },
                                glow: true,
                                glowColor: Colors.amber.withOpacity(0.3),
                              ),

                              SizedBox(height: 12),

                              // Rating Description
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _ratingColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _ratingColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  _ratingDescription,
                                  style: TextStyle(
                                    color: _ratingColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Comment Section
                        Text(
                          'Share your experience',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tell others about your experience with this $_entityDisplayName',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        SizedBox(height: 12),

                        CustomTextFormField(
                          controller: _commentController,
                          maxLines: 5,
                          outPadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'Write your review here...',
                          // va: (value) {
                          //   if (value == null || value.trim().isEmpty) {
                          //     return 'Please write a comment';
                          //   }
                          //   if (value.trim().length < 10) {
                          //     return 'Comment must be at least 10 characters';
                          //   }
                          //   return null;
                          // },
                          // decoration: InputDecoration(
                          //   hintText: 'Write your review here...',
                          //   border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(12),
                          //     borderSide: BorderSide(color: Colors.grey[300]!),
                          //   ),
                          //   focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(12),
                          //     borderSide: BorderSide(
                          //       color: Theme.of(context).primaryColor,
                          //       width: 2,
                          //     ),
                          //   ),
                          //   filled: true,
                          //   fillColor: Colors.grey[50],
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: BlocConsumer<ReviewsCubit, ReviewsState>(
                        listener: (context, state) {
                          setState(() => _isSubmitting = false);

                          if (state is ReviewsCreateSuccess) {
                            _showSnackBar('Review submitted successfully!');
                            Navigator.of(context).pop();

                            // Refresh reviews list
                            ReviewsCubit.of(context).getReviews(
                              context: context,
                              entityName: widget.entityName,
                              entityId: widget.entityId,
                            );

                            // Call callback if provided
                            widget.onReviewSubmitted?.call();
                          } else if (state is ReviewsCreateError) {
                            widget.onReviewSubmitted?.call();
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Submit Review',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
