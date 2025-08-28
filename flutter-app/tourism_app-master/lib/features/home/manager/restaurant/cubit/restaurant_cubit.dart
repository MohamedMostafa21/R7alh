import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';
import 'package:tourism_app/features/menu/data/models/resturant_model.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());
  static RestaurantCubit of(BuildContext context) => BlocProvider.of<RestaurantCubit>(context);

  Future<void> getRestaurants({required BuildContext context}) async {
    if (isClosed) return;
    emit(RestaurantLoading());
    await HomeDataSource.getRestaurant().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(RestaurantError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.restaurantModel = r;
          if (isClosed) return;
          emit(RestaurantSuccess());
        },
      );
    });
  }

  Future<void> getRestaurantById({required int restaurantId}) async {
    if (isClosed) return;
    emit(RestaurantLoading());
    await HomeDataSource.getRestaurantById(restaurantId: restaurantId).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(RestaurantError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.restaurantObject = r;
          if (isClosed) return;
          emit(RestaurantSuccess());
        },
      );
    });
  }
}
