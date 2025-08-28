import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/utils/utils.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    printDM('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    printDM('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printDM('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    printDM('onClose -- ${bloc.runtimeType}');
  }
}
