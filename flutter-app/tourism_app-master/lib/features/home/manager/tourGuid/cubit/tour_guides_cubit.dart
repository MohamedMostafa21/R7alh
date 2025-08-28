import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'tour_guides_state.dart';

class TourGuidesCubit extends Cubit<TourGuidesState> {
  TourGuidesCubit() : super(TourGuidesInitial());
  static TourGuidesCubit of(BuildContext context) => BlocProvider.of<TourGuidesCubit>(context);

  Future<void> getTourGuides({required BuildContext context}) async {
    if (isClosed) return;
    emit(TourGuidesLoading());
    await HomeDataSource.getTourGuids().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(TourGuidesError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.tourGuidModel = r;
          if (isClosed) return;
          emit(TourGuidesSuccess());
        },
      );
    });
  }
}
