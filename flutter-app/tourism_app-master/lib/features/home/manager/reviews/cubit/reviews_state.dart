part of 'reviews_cubit.dart';

@immutable
sealed class ReviewsState {}

// Initial state
final class ReviewsInitial extends ReviewsState {}

// Loading state for fetching reviews
final class ReviewsLoading extends ReviewsState {}

// Success state for fetching reviews
final class ReviewsGetSuccess extends ReviewsState {
  final ReviewModel reviews;

  ReviewsGetSuccess({required this.reviews});
}

// Error state for fetching reviews
final class ReviewsGetError extends ReviewsState {
  final String e;

  ReviewsGetError({required this.e});
}

// Loading state for creating review
final class ReviewsCreateLoading extends ReviewsState {}

// Success state for creating review
final class ReviewsCreateSuccess extends ReviewsState {
  final String message;

  ReviewsCreateSuccess({required this.message});
}

// Error state for creating review
final class ReviewsCreateError extends ReviewsState {
  final String e;

  ReviewsCreateError({required this.e});
}
