part of 'apply_guide_cubit.dart';

@immutable
sealed class ApplyGuideState {}

// Initial state
final class ApplyGuideInitial extends ApplyGuideState {}

// Application submission states
final class ApplyGuideLoading extends ApplyGuideState {}

final class ApplyGuideSuccess extends ApplyGuideState {
  final String message;
  ApplyGuideSuccess({required this.message});
}

final class ApplyGuideError extends ApplyGuideState {
  final String e;
  ApplyGuideError({required this.e});
}

// Application status states
final class ApplyGuideStatusLoading extends ApplyGuideState {}

final class ApplyGuideStatusSuccess extends ApplyGuideState {
  final AppliedAsTourguideModel application;
  ApplyGuideStatusSuccess({required this.application});
}

final class ApplyGuideStatusError extends ApplyGuideState {
  final String e;
  ApplyGuideStatusError({required this.e});
}

// Form update states
final class ApplyGuideLanguagesUpdated extends ApplyGuideState {
  final List<String> languages;
  ApplyGuideLanguagesUpdated({required this.languages});
}

final class ApplyGuideCvUpdated extends ApplyGuideState {
  final String filePath;
  ApplyGuideCvUpdated({required this.filePath});
}

final class ApplyGuideProfilePictureUpdated extends ApplyGuideState {
  final String filePath;
  ApplyGuideProfilePictureUpdated({required this.filePath});
}
