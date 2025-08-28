import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/network/local/cache.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/authentication/signup/data/dataSource/auth_data_source.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit of(BuildContext context) => BlocProvider.of<LoginCubit>(context);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginAccount({required BuildContext context}) async {
    if (isClosed) return;
    emit(LoginLoading());

    await AuthDataSource.loginAccount(
      data: {"email": emailController.text.trim(), "password": passwordController.text, "keepMeSignedIn": true},
    ).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(LoginError(e: l.errMessage));
        },
        (r) async {
          ConstantsModels.loginModel = r;
          Constants.token = r.token ?? '';
          await userCache?.put(userCacheKey, jsonEncode(r.toJson()));
          userCacheValue = r;
          if (isClosed) return;
          emit(LoginSuccess());
        },
      );
    });
  }

  // Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
