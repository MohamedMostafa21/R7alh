import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit() : super(PlaceInitial());
  static PlaceCubit of(BuildContext context) => BlocProvider.of<PlaceCubit>(context);

  Future<void> getPlaces({required BuildContext context}) async {
    if (isClosed) return;
    emit(PlaceLoading());
    await HomeDataSource.getPlace().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(PlaceError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.placeModel = r;
          if (isClosed) return;
          emit(PlaceSuccess());
        },
      );
    });
  }

  Future<void> getPlaceById({required int placeId}) async {
    if (isClosed) return;
    emit(PlaceLoading());
    await HomeDataSource.getPlaceById(placeId: placeId).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(PlaceError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.placeObject = r;
          if (isClosed) return;
          emit(PlaceSuccess());
        },
      );
    });
  }
}
