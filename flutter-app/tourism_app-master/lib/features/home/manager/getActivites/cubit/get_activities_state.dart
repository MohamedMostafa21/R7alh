part of 'get_activities_cubit.dart';

@immutable
sealed class GetActivitiesState {}

final class GetActivitiesInitial extends GetActivitiesState {}

final class GetActivitiesLoading extends GetActivitiesState {}

final class GetActivitiesSuccess extends GetActivitiesState {}

final class GetActivitiesError extends GetActivitiesState {
  final String e;

  GetActivitiesError({required this.e});
}
