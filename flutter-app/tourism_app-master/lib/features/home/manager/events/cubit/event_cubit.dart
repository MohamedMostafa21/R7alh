import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
  static EventCubit of(BuildContext context) => BlocProvider.of<EventCubit>(context);

  Future<void> getEvents({required BuildContext context}) async {
    if (isClosed) return;
    emit(EventLoading());
    await HomeDataSource.getEvent().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(EventError(e: l.errMessage));
        },
        (r) async {
         // Utils.showToast(title: 'success event', state: UtilState.success);

          ConstantsModels.eventModel = r;
          if (isClosed) return;
          emit(EventSuccess());
        },
      );
    });
  }
}
