import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Forget Password',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Please enter your email account to reset your password',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              CustomTextFormField(
                labelStringText: 'Email',
                outPadding: EdgeInsets.zero,
                controller: TextEditingController(),
                hintText: 'Enter your Email',
              ),
              SizedBox(
                height: 40,
              ),
              CustomTextButton(
                width: MediaQuery.sizeOf(context).width,
                borderRadius: 12,
                child: Text('Rest Password', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                onPress: () {},
              ),
              Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
