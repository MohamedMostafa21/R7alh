// ignore_for_file: type_annotate_public_apis
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/core/utils/utils.dart';

// ignore: avoid_classes_with_only_static_members
class DioHelper {
  static Dio? dio;

  // ignore: always_declare_return_types
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // get data ====>>>
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    BuildContext? context,
  }) async {
    final String token = Constants.token;
    debugPrint('token: $token');
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Apipassword': Constants.passwordApi,
      'lang': Constants.currentLanguage,
    };
    log('=======================================================');
    log('${dio?.options.baseUrl}$url');
    log('َQuery ====> $query');
    log('Headers in get method ${dio!.options.headers}');
    log('=======================================================');

    return dio!
        .get(
      url,
      queryParameters: query,
    )
        .then(
      (value) {
        if (value.data is Map && '${value.data['status']}' == 'false') {
          throw value.data['message'];
        }
        log('${value.realUri}');
        debugPrint(value.data.toString());
        return value;
      },
    );
  }

  // post data ====>>>
  static Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    bool formDataIsEnabled = false,
    BuildContext? context,
  }) async {
    final String token = Constants.token;

    debugPrint('token: $token');
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Apipassword': Constants.passwordApi,
      'lang': Constants.currentLanguage,
    };

    log('=======================================================');
    log('Headers in post method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in post method ${dio!.options.headers}');
    log('Data in post method $data');
    log('=======================================================');
    return dio!
        .post(
      '${EndPoints.baseUrl}$endPoint',
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    )
        .then((value) {
      printDM('Response post Method ==== \n $value');
      printDM('statusMessage ==> ${value.statusMessage}');
      if (context != null) {}
      if (value.data['status'] == false) {
        throw value.data['message'];
      }
      return value;
    });
  }

  // putData ====>>>
  static Future<Response> putData({
    required String endPoint,
    Map<String, dynamic>? query,
    bool formDataIsEnabled = false,
    required Map<String, dynamic> data,
  }) async {
    //final String token = HiveReuse.mainBox.get(AppConst.tokenBox) ?? '';
    dio!.options.headers = {
      'Authorization': 'Bearer ${Constants.token}',
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Apipassword': Constants.passwordApi,
      'lang': Constants.currentLanguage,
    };
    log('=======================================================');
    log('Headers in put method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in put method ${dio!.options.headers}');
    log('Data in put method $data');
    log('=======================================================');
    log('Headers ====> ${dio!.options.headers}');

    return dio!.put(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    );
  }

  // deleteData ====>>>
  static Future<Response> deleteData({
    required String endPoint,
    Map<String, dynamic>? query,
    bool formDataIsEnabled = false,
    required Map<String, dynamic> data,
  }) async {
    final String token = Constants.token;

    // final String token = HiveReuse.mainBox.get(AppConst.tokenBox) ?? '';
    dio!.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Apipassword': Constants.passwordApi,
      'lang': Constants.currentLanguage,
    };
    log('=======================================================');
    log('Headers in delete method ${dio!.options.baseUrl}/$endPoint');
    log('Headers in delete method ${dio!.options.headers}');
    log('Data in delete method $data');
    log('=======================================================');
    return dio!.delete(
      endPoint,
      queryParameters: query,
      data: formDataIsEnabled ? FormData.fromMap(data) : data,
    );
  }

  static Future<String> loadMockData({required String fileName, required BuildContext context}) async {
    final String filePath = 'assets/endpoints/$fileName.json';
    final String jsonString = await DefaultAssetBundle.of(context).loadString(filePath);
    return jsonString;
  }

  static Future<Map<String, dynamic>> makeNetworkRequest({required String endpoint, required BuildContext context}) async {
    final String mockData = await loadMockData(fileName: endpoint, context: context);
    // Parse the mock data into a JSON object
    final Map<String, dynamic> jsonData = json.decode(mockData);
    // Convert the JSON data into a model object or use it directly
    log(jsonData.toString());
    return jsonData;
  }
}
