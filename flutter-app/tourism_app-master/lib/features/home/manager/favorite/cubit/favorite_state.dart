part of 'favorite_cubit.dart';

sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

// Get Favorites States
final class FavoriteGetLoading extends FavoriteState {}

final class FavoriteGetSuccess extends FavoriteState {}

final class FavoriteGetError extends FavoriteState {
  final String e;

  FavoriteGetError({required this.e});
}

// Post Favorite States
final class FavoritePostLoading extends FavoriteState {}

final class FavoritePostSuccess extends FavoriteState {
  final String message;

  FavoritePostSuccess({required this.message});
}

final class FavoritePostError extends FavoriteState {
  final String e;

  FavoritePostError({required this.e});
}

// Legacy states for backward compatibility
final class FavoriteLoading extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {}

final class FavoriteError extends FavoriteState {
  final String e;

  FavoriteError({required this.e});
}
