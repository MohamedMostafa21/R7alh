import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/utils.dart';
import 'package:tourism_app/features/home/data/dataSource/home_data_source.dart';

part 'predict_image_with_ai_state.dart';

class PredictImageWithAiCubit extends Cubit<PredictImageWithAiState> {
  PredictImageWithAiCubit() : super(PredictImageWithAiInitial());
  static PredictImageWithAiCubit of(BuildContext context) => BlocProvider.of<PredictImageWithAiCubit>(context);
  File? image;

  void setImage(File newImage) {
    image = newImage;
    // Clear previous AI results when setting new image
    ConstantsModels.aiResonseModel = null;
    emit(PredictImageWithAiInitial());
  }

  Future<void> predictImageWithAi({required BuildContext context}) async {
    if (isClosed) return;

    if (image == null || !image!.existsSync()) {
      Utils.showToast(title: 'No image selected or file not found', state: UtilState.error);
      emit(PredictImageWithAIError(e: 'No image selected or file not found'));
      return;
    }

    // Clear previous AI results before starting new analysis
    ConstantsModels.aiResonseModel = null;

    emit(PredictImageWithAiLoading());

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image!.path,
          filename: image!.path.split('/').last,
        )
      });

      print('Sending image: ${image!.path}'); // Debug log

      await HomeDataSource.predictImageWithAi(data: formData).then((value) async {
        value.fold(
          (l) {
            print('AI Error: ${l.errMessage}'); // Debug log
            Utils.showToast(title: l.errMessage, state: UtilState.error);
            if (isClosed) return;
            emit(PredictImageWithAIError(e: l.errMessage));
          },
          (r) async {
            print('AI Success: ${r.name}, ${r.predictedCaption}'); // Debug log
            ConstantsModels.aiResonseModel = r;
            if (isClosed) return;
            emit(PredictImageWithAiSuccess());
          },
        );
      });
    } catch (e) {
      print('Cubit Error: $e'); // Debug log
      Utils.showToast(title: 'Failed to process image', state: UtilState.error);
      if (isClosed) return;
      emit(PredictImageWithAIError(e: 'Failed to process image: $e'));
    }
  }
}
