import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'api_exceptions.dart';

class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  NetworkClient._internal();

  final Dio _dio = Dio();

  Future<Response> postRequest({
    required String endPoint,
    String? api,
    required dynamic payload,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      final headers = await _getHeaders(customHeaders);
      final response = await _dio.post(
        api??appApiBaseUrl + endPoint,
        data: payload,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status != null;
          },
        ),
      );
      log("Headers: $headers");
      log("Request: ${api??appApiBaseUrl + endPoint}");
      log("Response: ${response.data}");
      return response;
    } catch (e) {
      log("Request Error: $e");
      throw ApiException().handleError(e);
    }
  }

  Future<Response> putRequest({
    required String endPoint,
    required dynamic payload,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      final headers = await _getHeaders(customHeaders);
      final response = await _dio.put(
        appApiBaseUrl + endPoint,
        data: payload,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status != null; // Accept all status codes, including 400
          },
        ),
      );
      log("Headers: $headers");
      log("Request: ${appApiBaseUrl + endPoint}");
      log("Response: ${response.data}");
      return response;
    } catch (e) {
      log("Request Error: $e");
      throw ApiException().handleError(e);
    }
  }

  Future<Response> deleteRequest({
    required String endPoint,
     dynamic payload,
    Map<String, dynamic>? customHeaders,
  }) async {
    try {
      final headers = await _getHeaders(customHeaders);
      final response = await _dio.delete(
        appApiBaseUrl + endPoint,
        data: payload,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status != null; // Accept all status codes, including 400
          },
        ),
      );
      log("Headers: $headers");
      log("Request: ${appApiBaseUrl + endPoint}");
      log("Response: ${response.data}");
      return response;
    } catch (e) {
      log("Request Error: $e");
      throw ApiException().handleError(e);
    }
  }

  Future<Response> getRequest({required String endPoint, Map<String, dynamic>? params, Map<String, dynamic>? customHeaders,}) async {
    try {
      final headers = await _getHeaders(customHeaders);
      final response = await _dio.get(
        appApiBaseUrl+endPoint,
        queryParameters: params,
        options: Options(
          headers: headers,
          validateStatus: (status) {
            return status != null; // acceppts all status codes
          },
        ),
      );
      log("Headers: $headers");
      log("Request: ${appApiBaseUrl + endPoint}");
      log("Response: ${jsonEncode(response.data)}");
      return response;
    } catch (e) {
      log("Request Error: $e");
      throw ApiException().handleError(e);
    }
  }

  Future<Map<String, dynamic>> _getHeaders([Map<String, dynamic>? customHeaders]) async {
    String? token = authToken ?? await storageService.read(authTokenKey);
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Client-Type': 'app'
    };
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }
}
