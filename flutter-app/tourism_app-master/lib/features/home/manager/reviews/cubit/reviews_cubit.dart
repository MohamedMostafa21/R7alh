import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';
import 'package:tourism_app/features/home/data/models/review_model.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(ReviewsInitial());
  static ReviewsCubit of(BuildContext context) => BlocProvider.of<ReviewsCubit>(context);

  // Store current reviews data
  ReviewModel? currentReviews;

  /// Get reviews for a specific entity (place, tour guide, hotel, restaurant, plan)
  Future<void> getReviews({
    required BuildContext context,
    required String entityName,
    required int entityId,
  }) async {
    if (isClosed) return;
    emit(ReviewsLoading());

    await HomeDataSource.getReviews(
      entityName: entityName,
      entityId: entityId,
    ).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(ReviewsGetError(e: l.errMessage));
        },
        (r) async {
          currentReviews = r;
          if (isClosed) return;
          emit(ReviewsGetSuccess(reviews: r));
        },
      );
    });
  }

  /// Create a new review for a specific entity
  Future<void> createReview({
    required BuildContext context,
    required String entityName,
    required int entityId,
    required int rate,
    required String comment,
  }) async {
    if (isClosed) return;
    emit(ReviewsCreateLoading());

    await HomeDataSource.createReview(
      entityName: entityName,
      entityId: entityId,
      rate: rate,
      comment: comment,
    ).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(ReviewsCreateError(e: l.errMessage));
        },
        (r) async {
          Utils.showToast(title: r, state: UtilState.success);
          if (isClosed) return;
          emit(ReviewsCreateSuccess(message: r));

          // Optionally refresh reviews after creating a new one
          if (currentReviews != null) {
            getReviews(
              context: context,
              entityName: entityName,
              entityId: entityId,
            );
          }
        },
      );
    });
  }

  /// Clear current reviews data
  void clearReviews() {
    currentReviews = null;
    if (!isClosed) {
      emit(ReviewsInitial());
    }
  }

  /// Get total reviews count
  int get totalReviewsCount => currentReviews?.pagination?.totalItems ?? 0;

  /// Get average rating (you can calculate this from the reviews data)
  double get averageRating {
    if (currentReviews?.data == null || currentReviews!.data!.isEmpty) {
      return 0.0;
    }

    final totalRating = currentReviews!.data!.map((review) => review.rating ?? 0).reduce((a, b) => a + b);

    return totalRating / currentReviews!.data!.length;
  }

  /// Check if there are more pages to load
  bool get hasMorePages {
    final pagination = currentReviews?.pagination;
    if (pagination == null) return false;

    return (pagination.currentPage ?? 0) < (pagination.totalPages ?? 0);
  }
}
