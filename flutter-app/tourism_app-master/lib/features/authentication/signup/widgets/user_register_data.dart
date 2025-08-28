import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/login/login_view.dart';
import 'package:tourism_app/features/authentication/login/widgets/auth_prompt.dart';

class UserRegisterData extends StatelessWidget {
  const UserRegisterData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2)],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            labelStringText: 'Name',
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Enter your name',
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            labelStringText: 'Email',
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Enter your Email',
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            labelStringText: 'Country',
            enable: false,
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Select your country',
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            labelStringText: 'password',
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Enter your password',
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            labelStringText: 'Confirm Password',
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Confirm Password',
          ),
          SizedBox(
            height: 20,
          ),
          AuthPrompt(
            text: 'Do you have an account? ',
            actionText: 'Login',
            onTap: () => context.navigateToPage(LoginView()),
          ),
        ],
      ),
    );
  }
}
