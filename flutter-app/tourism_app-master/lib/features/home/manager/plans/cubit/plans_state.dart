part of 'plans_cubit.dart';

@immutable
sealed class PlansState {}

final class PlansInitial extends PlansState {}

final class PlansLoading extends PlansState {}

final class PlansSuccess extends PlansState {}

final class PlansError extends PlansState {
  final String e;

  PlansError({required this.e});
}
