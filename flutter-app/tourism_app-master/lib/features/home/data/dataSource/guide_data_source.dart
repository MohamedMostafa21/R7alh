import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tourism_app/core/network/dio_helper.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/network/errors/failures.dart';
import 'package:tourism_app/features/menu/data/models/applied_as_toure_guide.dart';

class GuideDataSource {
  static Future<Either<Failure, String>> getToureGuid() async {
    try {
      await DioHelper.getData(url: EndPoints.tourGuides);
      return Right('Request created successfully');
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, AppliedAsTourguideModel>> getTourguidApplication() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.toureGuideApplications);
      return Right(AppliedAsTourguideModel.fromJson(response.data));
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, String>> bookGuide({required dynamic data}) async {
    try {
      await DioHelper.postData(endPoint: EndPoints.bookGuide, data: data);
      return Right('Request created successfully');
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }

  static Future<Either<Failure, String>> applyAsTourGuide({required Map<String, dynamic> data}) async {
    try {
      await DioHelper.postData(endPoint: EndPoints.tourGuides, data: data);
      return Right('Application submitted successfully');
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      }
      return Left(ServerFailure(error.toString()));
    }
  }
}
