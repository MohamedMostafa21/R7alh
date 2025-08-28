part of 'city_cubit.dart';

@immutable
sealed class CityState {}

final class CityInitial extends CityState {}

final class CityLoading extends CityState {}

final class CitySuccess extends CityState {}

final class CityError extends CityState {
  final String e;

  CityError({required this.e});
}
