part of 'restaurant_cubit.dart';

sealed class RestaurantState {}

final class RestaurantInitial extends RestaurantState {}

final class RestaurantLoading extends RestaurantState {}

final class RestaurantSuccess extends RestaurantState {}

final class RestaurantError extends RestaurantState {
  final String e;

  RestaurantError({required this.e});
}
