import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/guide_data_source.dart';

part 'book_guide_state.dart';

class BookGuideCubit extends Cubit<BookGuideState> {
  BookGuideCubit() : super(BookGuideInitial());
  static BookGuideCubit of(BuildContext context) => BlocProvider.of<BookGuideCubit>(context);
  int toureGuideId = -1;
  TextEditingController bookingDate = TextEditingController();
  int durationHOures = 0;
  Future<void> bookGuide({required BuildContext context}) async {
    if (isClosed) return;
    emit(BookGuideLoading());
    await GuideDataSource.bookGuide(data: {"tourGuideId": toureGuideId, "bookingDate": bookingDate.text, "durationHours": durationHOures})
        .then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(BookGuideError(e: l.errMessage));
        },
        (r) async {
          if (isClosed) return;
          emit(BookGuideSuccess());
        },
      );
    });
  }
}
