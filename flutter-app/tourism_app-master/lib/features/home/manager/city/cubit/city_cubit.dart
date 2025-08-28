import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());
  static CityCubit of(BuildContext context) => BlocProvider.of<CityCubit>(context);

  Future<void> getCities({required BuildContext context}) async {
    if (isClosed) return;
    emit(CityLoading());
    await HomeDataSource.getCities().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(CityError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.cityModel = r;
          if (isClosed) return;
          emit(CitySuccess());
        },
      );
    });
  }
}
