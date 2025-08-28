part of 'predict_image_with_ai_cubit.dart';

@immutable
sealed class PredictImageWithAiState {}

final class PredictImageWithAiInitial extends PredictImageWithAiState {}

final class PredictImageWithAiLoading extends PredictImageWithAiState {}

final class PredictImageWithAiSuccess extends PredictImageWithAiState {}

final class PredictImageWithAIError extends PredictImageWithAiState {
  final String e;

  PredictImageWithAIError({required this.e});
}
