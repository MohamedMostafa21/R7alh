part of 'tour_guides_cubit.dart';

@immutable
sealed class TourGuidesState {}

final class TourGuidesInitial extends TourGuidesState {}

final class TourGuidesLoading extends TourGuidesState {}

final class TourGuidesSuccess extends TourGuidesState {}

final class TourGuidesError extends TourGuidesState {
  final String e;

  TourGuidesError({required this.e});
}
