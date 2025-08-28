import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_cubit_state.dart';

class MainCubitCubit extends Cubit<MainCubitState> {
  MainCubitCubit() : super(MainCubitInitial());

  // List<TaskData> taskList = [];
  bool isTaped = false;
  onTaped() {
    isTaped = !isTaped;
    emit(MainTaped());
  }
}
