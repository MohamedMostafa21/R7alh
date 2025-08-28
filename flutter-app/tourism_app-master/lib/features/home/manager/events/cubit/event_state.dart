part of 'event_cubit.dart';

@immutable
sealed class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventSuccess extends EventState {}

final class EventError extends EventState {
  final String e;

  EventError({required this.e});
}
