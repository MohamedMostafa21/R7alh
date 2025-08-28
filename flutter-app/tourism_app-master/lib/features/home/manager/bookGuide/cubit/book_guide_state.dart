part of 'book_guide_cubit.dart';

@immutable
sealed class BookGuideState {}

final class BookGuideInitial extends BookGuideState {}

final class BookGuideLoading extends BookGuideState {}

final class BookGuideSuccess extends BookGuideState {}

final class BookGuideError extends BookGuideState {
  final String e;

  BookGuideError({required this.e});
}
