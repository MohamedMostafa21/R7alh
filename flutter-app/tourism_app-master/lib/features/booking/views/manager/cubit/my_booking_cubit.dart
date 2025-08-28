import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'my_booking_state.dart';

class MyBookingCubit extends Cubit<MyBookingState> {
  MyBookingCubit() : super(MyBookingInitial());
  static MyBookingCubit of(BuildContext context) => BlocProvider.of<MyBookingCubit>(context);

  Future<void> getMyBooking({required BuildContext context}) async {
    if (isClosed) return;
    emit(MyBookingLoading());
    await HomeDataSource.getMyBooking().then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(MyBookingError(e: l.errMessage));
        },
        (r) async {
          Utils.showToast(title: 'success', state: UtilState.success);

          ConstantsModels.myBooking = r;
          if (isClosed) return;
          emit(MyBookingSuccess());
        },
      );
    });
  }

  Future<void> confirmBooking({required BuildContext context,required int bookingId}) async {
    if (isClosed) return;
    emit(ConfirmBookingLoading());
    await HomeDataSource.confirmBooking(bookingId: bookingId).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(ConfirmBookingError(e: l.errMessage));
        },
        (r) async {
          Utils.showToast(title: 'success', state: UtilState.success);

          if (isClosed) return;
          emit(ConfirmBookingSuccess());
        },
      );
    });
  }
}
