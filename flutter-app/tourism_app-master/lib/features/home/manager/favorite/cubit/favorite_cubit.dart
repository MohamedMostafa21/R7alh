import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';
import 'package:tourism_app/features/home/data/models/favorite_model.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());
  static FavoriteCubit of(BuildContext context) => BlocProvider.of<FavoriteCubit>(context);

  // Get Favorites
  Future<void> getFavorites({required BuildContext context}) async {
    if (isClosed) return;
    emit(FavoriteGetLoading());
    await HomeDataSource.getFavorite().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(FavoriteGetError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.favoriteModel = r;
          if (isClosed) return;
          emit(FavoriteGetSuccess());
        },
      );
    });
  }

  // Legacy method for backward compatibility
  Future<void> getFavoritesLegacy({required BuildContext context}) async {
    if (isClosed) return;
    emit(FavoriteLoading());
    await HomeDataSource.getFavorite().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(FavoriteError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.favoriteModel = r;
          if (isClosed) return;
          emit(FavoriteSuccess());
        },
      );
    });
  }

  // Post Favorite (Add/Remove from favorites)
  Future<void> postFavorite({
    required BuildContext context,
    required String entityType,
    required int entityId,
    bool showToast = true,
  }) async {
    if (isClosed) return;
    emit(FavoritePostLoading());

    await HomeDataSource.postFavorite(
      entityType: entityType,
      entityId: entityId,
    ).then((value) async {
      value.fold(
        (l) {
          if (showToast) {
            Utils.showToast(title: l.errMessage, state: UtilState.error);
          }
          if (isClosed) return;
          emit(FavoritePostError(e: l.errMessage));
        },
        (r) async {
          if (showToast) {
            Utils.showToast(
              title: 'Favorite updated successfully',
              state: UtilState.success,
            );
          }
          if (isClosed) return;
          emit(FavoritePostSuccess(message: r));
        },
      );
    });
  }

  // Helper method to toggle favorite status
  Future<void> toggleFavorite({
    required BuildContext context,
    required String entityType,
    required int entityId,
    bool refreshFavorites = true,
  }) async {
    await postFavorite(
      context: context,
      entityType: entityType,
      entityId: entityId,
    );

    // Optionally refresh the favorites list after toggling
    if (refreshFavorites) {
      await getFavorites(context: context);
    }
  }

  // Helper method to check if an item is favorited
  bool isFavorited({required String entityType, required int entityId}) {
    if (ConstantsModels.favoriteModel == null) return false;

    return ConstantsModels.favoriteModel!.any((favorite) {
      switch (entityType.toLowerCase()) {
        case 'place':
          return favorite.placeId == entityId;
        case 'tourguide':
          return favorite.tourGuideId == entityId;
        case 'hotel':
          return favorite.hotelId == entityId;
        case 'restaurant':
          return favorite.restaurantId == entityId;
        case 'plan':
          return favorite.planId == entityId;
        default:
          return false;
      }
    });
  }

  // Helper method to get total favorites count
  int get totalFavoritesCount {
    return ConstantsModels.favoriteModel?.length ?? 0;
  }

  // Helper method to get favorites by entity type
  List<FavoriteModel> getFavoritesByType(String entityType) {
    if (ConstantsModels.favoriteModel == null) return [];

    return ConstantsModels.favoriteModel!.where((favorite) {
      switch (entityType.toLowerCase()) {
        case 'place':
          return favorite.placeId != null;
        case 'tourguide':
          return favorite.tourGuideId != null;
        case 'hotel':
          return favorite.hotelId != null;
        case 'restaurant':
          return favorite.restaurantId != null;
        case 'plan':
          return favorite.planId != null;
        default:
          return false;
      }
    }).toList();
  }

  // Helper methods for specific entity types
  List<FavoriteModel> get favoritePlaces => getFavoritesByType('place');
  List<FavoriteModel> get favoriteHotels => getFavoritesByType('hotel');
  List<FavoriteModel> get favoriteRestaurants => getFavoritesByType('restaurant');
  List<FavoriteModel> get favoriteTourGuides => getFavoritesByType('tourguide');
  List<FavoriteModel> get favoritePlans => getFavoritesByType('plan');

  // Helper method to get entity name by ID and type
  String? getEntityName({required String entityType, required int entityId}) {
    if (ConstantsModels.favoriteModel == null) return null;

    for (var favorite in ConstantsModels.favoriteModel!) {
      switch (entityType.toLowerCase()) {
        case 'place':
          if (favorite.placeId == entityId) return favorite.placeName;
          break;
        case 'tourguide':
          if (favorite.tourGuideId == entityId) return favorite.tourGuideName;
          break;
        case 'hotel':
          if (favorite.hotelId == entityId) return favorite.hotelName;
          break;
        case 'restaurant':
          if (favorite.restaurantId == entityId) return favorite.restaurantName;
          break;
        case 'plan':
          if (favorite.planId == entityId) return favorite.planName;
          break;
      }
    }
    return null;
  }
}
