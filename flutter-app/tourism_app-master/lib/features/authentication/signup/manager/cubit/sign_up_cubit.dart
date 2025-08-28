import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/authentication/signup/data/dataSource/auth_data_source.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit of(BuildContext context) => BlocProvider.of<SignUpCubit>(context);

  // Text Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Form state
  int selectedGender = 0;
  File? profileImage;
  bool isPasswordVisible = false;

  // Getters for gender string
  String get genderString {
    switch (selectedGender) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      case 2:
        return 'Other';
      default:
        return 'Male';
    }
  }

  // Update methods
  void updateGender(int gender) {
    selectedGender = gender;
    emit(SignUpFormUpdated());
  }

  void updateProfileImage(File? image) {
    profileImage = image;
    emit(SignUpFormUpdated());
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(SignUpFormUpdated());
  }

  void updateDateOfBirth(DateTime date) {
    final formattedDate =
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00.000Z";
    dateOfBirthController.text = formattedDate;
    emit(SignUpFormUpdated());
  }

  // Validation methods
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    return null;
  }

  // Main signup method
  Future<void> createAccount({required BuildContext context}) async {
    if (isClosed) return;
    emit(SignUpLoading());

    await AuthDataSource.createAccount(
      data: {
        "FirstName": firstNameController.text.trim(),
        "LastName": lastNameController.text.trim(),
        "Email": emailController.text.trim(),
        "Password": passwordController.text,
        "DateOfBirth": dateOfBirthController.text,
        "Gender": genderString,
        "Country": countryController.text.trim(),
        "City": "test",
        "PhoneNumber": phoneNumberController.text.trim(),
        if (profileImage != null)
          "ProfilePicture": await MultipartFile.fromFile(
            profileImage?.path ?? '',
            filename: profileImage?.path.split('/').last,
          )
      },
    ).then((value) async {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(SignUpError(e: l.errMessage));
        },
        (r) async {
          Utils.showToast(title: r, state: UtilState.success);
          if (isClosed) return;
          emit(SignUpSuccess());
        },
      );
    });
  }

  // Clear form
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    dateOfBirthController.clear();
    countryController.clear();
    phoneNumberController.clear();
    selectedGender = 0;
    profileImage = null;
    isPasswordVisible = false;
    emit(SignUpInitial());
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    countryController.dispose();
    phoneNumberController.dispose();
    return super.close();
  }
}
