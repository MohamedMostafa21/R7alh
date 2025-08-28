import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';
import 'package:tourism_app/features/menu/data/models/hotel_model.dart';

part 'hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  HotelCubit() : super(HotelInitial());
  static HotelCubit of(BuildContext context) => BlocProvider.of<HotelCubit>(context);

  Future<void> getHotels({required BuildContext context}) async {
    if (isClosed) return;
    emit(HotelLoading());
    await HomeDataSource.getHotels().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(HotelError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.hotelModel = r;
          if (isClosed) return;
          emit(HotelSuccess());
        },
      );
    });
  }

  Future<void> getHotelById({required int hotelId}) async {
    if (isClosed) return;
    emit(HotelLoading());
    await HomeDataSource.getHotelsById(hotelId: hotelId).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(HotelError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.hotelObject = r;
          if (isClosed) return;
          emit(HotelSuccess());
        },
      );
    });
  }
}
