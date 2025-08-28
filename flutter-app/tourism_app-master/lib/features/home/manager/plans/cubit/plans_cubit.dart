import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());
  static PlansCubit of(BuildContext context) => BlocProvider.of<PlansCubit>(context);

  Future<void> getPlans({required BuildContext context}) async {
    if (isClosed) return;
    emit(PlansLoading());
    await HomeDataSource.getPlane().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(PlansError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.planModel = r;
          if (isClosed) return;
          emit(PlansSuccess());
        },
      );
    });
  }
}
