part of 'place_cubit.dart';

@immutable
sealed class PlaceState {}

final class PlaceInitial extends PlaceState {}

final class PlaceLoading extends PlaceState {}

final class PlaceSuccess extends PlaceState {}

final class PlaceError extends PlaceState {
  final String e;

  PlaceError({required this.e});
}
