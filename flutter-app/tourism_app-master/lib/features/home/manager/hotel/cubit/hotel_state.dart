part of 'hotel_cubit.dart';

sealed class HotelState {}

final class HotelInitial extends HotelState {}

final class HotelLoading extends HotelState {}

final class HotelSuccess extends HotelState {}

final class HotelError extends HotelState {
  final String e;

  HotelError({required this.e});
}
