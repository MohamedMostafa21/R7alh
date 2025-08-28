part of 'my_booking_cubit.dart';

@immutable
sealed class MyBookingState {}

final class MyBookingInitial extends MyBookingState {}

final class MyBookingLoading extends MyBookingState {}

final class MyBookingSuccess extends MyBookingState {}

final class MyBookingError extends MyBookingState {
  final String e;

  MyBookingError({required this.e});
}

final class ConfirmBookingLoading extends MyBookingState {}

final class ConfirmBookingSuccess extends MyBookingState {}

final class ConfirmBookingError extends MyBookingState {
  final String e;

  ConfirmBookingError({required this.e});
}
