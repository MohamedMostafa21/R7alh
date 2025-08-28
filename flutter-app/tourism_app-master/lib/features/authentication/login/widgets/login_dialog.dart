import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/forgot_password/presentation/forget_password_view.dart';
import 'package:tourism_app/features/authentication/login/manager/cubit/login_cubit.dart';
import 'package:tourism_app/features/bottomNavigationBar/presentation/botton_navigation_bar_view.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navigate to bottom navigation bar on successful login
            context.navigateToPage(BottomNavigationBarView());
          }
          // Error handling is already done in the cubit via Utils.showToast
        },
        builder: (context, state) {
          final cubit = LoginCubit.of(context);

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            height: MediaQuery.sizeOf(context).height * 0.5,
            width: MediaQuery.sizeOf(context).width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2)],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Center(child: Text('Login Account', style: Theme.of(context).textTheme.headlineMedium)),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  labelStringText: 'Email',
                  outPadding: EdgeInsets.zero,
                  controller: cubit.emailController,
                  hintText: 'Enter your Email',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  labelStringText: 'Password',
                  outPadding: EdgeInsets.zero,
                  controller: cubit.passwordController,
                  password: true,
                  hintText: 'Enter your password',
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      context.navigateToPage(ForgetPasswordView());
                    },
                    child: Text('Forget Password?', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primaryColor))),
                SizedBox(
                  height: 20,
                ),
                CustomTextButton(
                  borderRadius: 12,
                  onPress: state is LoginLoading
                      ? null
                      : () {
                          // Validate inputs before attempting login
                          if (cubit.emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter your email')),
                            );
                            return;
                          }
                          if (cubit.passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter your password')),
                            );
                            return;
                          }

                          // Attempt login
                          cubit.loginAccount(context: context);
                        },
                  child: state is LoginLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Login', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                ),
                Spacer()
              ],
            ),
          );
        },
      ),
    );
  }
}
