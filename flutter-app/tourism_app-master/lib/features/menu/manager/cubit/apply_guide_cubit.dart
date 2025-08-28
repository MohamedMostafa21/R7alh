import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/network/dio_helper.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/guide_data_source.dart';
import 'package:tourism_app/features/menu/data/models/applied_as_toure_guide.dart';

part 'apply_guide_state.dart';

class ApplyGuideCubit extends Cubit<ApplyGuideState> {
  ApplyGuideCubit() : super(ApplyGuideInitial());
  static ApplyGuideCubit of(BuildContext context) => BlocProvider.of<ApplyGuideCubit>(context);

  // Application form data
  final TextEditingController bioController = TextEditingController();
  final TextEditingController yearsExperienceController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();

  List<String> selectedLanguages = [];
  String? cvFilePath;
  String? profilePicturePath;

  // Submit application with files
  Future<void> submitApplication({required BuildContext context}) async {
    if (isClosed) return;
    emit(ApplyGuideLoading());

    try {
      // Prepare form data with text fields and files
      final Map<String, dynamic> data = {
        'Bio': bioController.text.trim(),
        'YearsOfExperience': int.tryParse(yearsExperienceController.text) ?? 0,
        'HourlyRate': double.tryParse(hourlyRateController.text) ?? 0.0,
        'Languages': selectedLanguages.join(','), // Convert list to comma-separated string
      };

      // Add CV file if selected
      if (cvFilePath != null && cvFilePath!.isNotEmpty) {
        data['CV'] = await MultipartFile.fromFile(
          cvFilePath!,
          filename: 'cv_${DateTime.now().millisecondsSinceEpoch}.${cvFilePath!.split('.').last}',
        );
      }

      // Add profile picture file if selected
      if (profilePicturePath != null && profilePicturePath!.isNotEmpty) {
        data['ProfilePicture'] = await MultipartFile.fromFile(
          profilePicturePath!,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.${profilePicturePath!.split('.').last}',
        );
      }

      // Send application with files using form data
      final response = await DioHelper.postData(
        endPoint: EndPoints.applyTourGuides,
        data: data,
        formDataIsEnabled: true,
      );

      Utils.showToast(title: 'Application submitted successfully!', state: UtilState.success);
      if (isClosed) return;
      emit(ApplyGuideSuccess(message: 'Application submitted successfully!'));
    } catch (e) {
      Utils.showToast(title: 'Failed to submit application', state: UtilState.error);
      if (isClosed) return;
      emit(ApplyGuideError(e: 'Failed to submit application: ${e.toString()}'));
    }
  }

  // Get application status
  Future<void> getApplicationStatus({required BuildContext context}) async {
    if (isClosed) return;
    emit(ApplyGuideStatusLoading());

    await GuideDataSource.getTourguidApplication().then((value) {
      value.fold(
        (l) {
          Utils.showToast(title: l.errMessage, state: UtilState.error);
          if (isClosed) return;
          emit(ApplyGuideStatusError(e: l.errMessage));
        },
        (r) {
          if (isClosed) return;
          emit(ApplyGuideStatusSuccess(application: r));
        },
      );
    });
  }

  // Add language to selected languages
  void addLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      selectedLanguages.add(language);
      emit(ApplyGuideLanguagesUpdated(languages: List.from(selectedLanguages)));
    }
  }

  // Remove language from selected languages
  void removeLanguage(String language) {
    selectedLanguages.remove(language);
    emit(ApplyGuideLanguagesUpdated(languages: List.from(selectedLanguages)));
  }

  // Set CV file path
  void setCvFile(String filePath) {
    cvFilePath = filePath;
    emit(ApplyGuideCvUpdated(filePath: filePath));
  }

  // Set profile picture path
  void setProfilePicture(String filePath) {
    profilePicturePath = filePath;
    emit(ApplyGuideProfilePictureUpdated(filePath: filePath));
  }

  // Validate form
  String? validateForm() {
    if (bioController.text.trim().isEmpty) {
      return 'Bio is required';
    }
    if (yearsExperienceController.text.trim().isEmpty) {
      return 'Years of experience is required';
    }
    if (hourlyRateController.text.trim().isEmpty) {
      return 'Hourly rate is required';
    }
    if (selectedLanguages.isEmpty) {
      return 'At least one language is required';
    }
    return null;
  }

  @override
  Future<void> close() {
    bioController.dispose();
    yearsExperienceController.dispose();
    hourlyRateController.dispose();
    return super.close();
  }
}
