import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'get_activities_state.dart';

class GetActivitiesCubit extends Cubit<GetActivitiesState> {
  GetActivitiesCubit() : super(GetActivitiesInitial());
  static GetActivitiesCubit of(BuildContext context) => BlocProvider.of<GetActivitiesCubit>(context);

  Future<void> getActivityByPlaceId({required int placeId}) async {
    if (isClosed) return;
    emit(GetActivitiesLoading());
    await HomeDataSource.getActivityByPlaceId(placeId: placeId).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(GetActivitiesError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.activityList = r;
          if (isClosed) return;
          emit(GetActivitiesSuccess());
        },
      );
    });
  }
}
