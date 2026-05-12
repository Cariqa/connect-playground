import 'dart:async';
import 'dart:convert';

import 'package:connect_reference_client/_playground/api_call_log.dart';
import 'package:connect_reference_client/_playground/util.dart';
import 'package:connect_reference_client/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final ValueNotifier<bool> loadingController = ValueNotifier(false);

class ApiClient {
  final Utf8Decoder utf8decoder = const Utf8Decoder();
  final ValueNotifier<List<ApiCallLog>> logController;
  final http.Client globalHttpClient;
  ApiCallLog apiCallLog = ApiCallLog(
    request: '',
    response: '',
    reqParams: {},
    responseBody: {},
    responseError: null,
    status: 0,
  );
  ApiClient(this.logController, this.globalHttpClient);

  Future<dynamic> get({required String url, Map<String, String>? addHeaders, Map<String, dynamic>? params}) async {
    return await _send(url: url, type: 'GET', addHeaders: addHeaders, params: params);
  }

  Future<dynamic> post({
    required String url,
    required String? body,
    Map<String, String>? addHeaders,
    Map<String, dynamic>? params,
  }) async {
    return await _send(url: url, type: 'POST', body: body, addHeaders: addHeaders, params: params);
  }

  Future<dynamic> put({
    required String url,
    required String? body,
    Map<String, String>? addHeaders,
    Map<String, dynamic>? params,
  }) async {
    return await _send(url: url, type: 'PUT', body: body, addHeaders: addHeaders, params: params);
  }

  Future<dynamic> patch({
    required String url,
    required String? body,
    Map<String, String>? addHeaders,
    Map<String, dynamic>? params,
  }) async {
    return await _send(url: url, type: 'PATCH', body: body, addHeaders: addHeaders, params: params);
  }

  Future<dynamic> delete({
    required String url,
    Map<String, String>? addHeaders,
    Map<String, dynamic>? params,
  }) async {
    return await _send(url: url, type: 'DELETE', addHeaders: addHeaders, params: params);
  }

  Future<dynamic> _send({
    required String url,
    required String type,
    String? body,
    Map<String, String>? addHeaders,
    Map<String, dynamic>? params,
  }) async {
    loadingController.value = true;
    dynamic responseJson;
    http.Response? response;
    Uri? uri;

    try {
      uri = _buildUri(url, params: params);

      _logRequest(type, uri: uri, params: params, body: body);

      final req = http.Request(type, uri);
      req.headers.addAll(_setupHeaders(addHeaders));
      if (body != null) req.body = body;

      final streamed = await globalHttpClient.send(req).timeout(const Duration(seconds: 60));
      response = await http.Response.fromStream(streamed);

      responseJson = _response(response);

      _logResponse(type, uri: uri, statusCode: response.statusCode, body: response.body, responseJson: responseJson);
    } catch (error) {
      _logResponse(type, uri: uri, statusCode: response?.statusCode, body: response?.body);
      rethrow;
    } finally {
      loadingController.value = false;
    }

    return responseJson;
  }

  Uri _buildUri(String url, {Map<String, dynamic>? params}) {
    return Uri.parse('https://$connectApiDomain$url').resolveUri(Uri(queryParameters: params));
  }

  Map<String, String> _setupHeaders(Map<String, String>? newHeaders) => {
        'Content-Type': 'application/json',
        ...?newHeaders,
      };

  dynamic _response(http.Response response) {
    final parsedResponse = parseResponse(response);
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return parsedResponse;
      case Exception400.errorCode:
        throw Exception400(
          body: response.body,
          status: parsedResponse['status'],
          errorMessage: _getErrorMessage(parsedResponse: parsedResponse, response: response),
        );

      case FetchDataException.errorCode:
      default:
        throw FetchDataException(
          body: 'FetchDataException with StatusCode : ${response.statusCode} - ${response.body}',
        );
    }
  }

  void _logRequest(String type, {required Uri uri, Map<String, dynamic>? params, dynamic body}) {
    final uriData = 'Request $type\n${getUriLog(uri)}';
    final bodyLog = body != null ? ', body: ${_prettyJson(jsonDecode(body))},' : '';

    logPrint('$uriData, params: $params$bodyLog');
    apiCallLog = apiCallLog.copyWith(request: getUriLog(uri), reqParams: params);
    logController.value = [apiCallLog];
  }

  dynamic parseResponse(dynamic response, {bool withUtf8Decoder = true}) {
    try {
      dynamic responseBody;
      if (withUtf8Decoder) {
        responseBody = utf8decoder.convert(response.body.toString().codeUnits);
      } else {
        responseBody = response.body;
      }

      if (responseBody.isNotEmpty) {
        try {
          return json.decode(responseBody);
        } on FormatException {
          throw Exception("Can't parse response");
        }
      } else if (responseBody.isEmpty) {
        return <String, dynamic>{};
      }
      return responseBody;
    } on FormatException catch (_) {
      if (withUtf8Decoder) {
        return parseResponse(response, withUtf8Decoder: false);
      } else {
        throw Exception("Can't parse response");
      }
    }
  }

  Future<void> _logResponse(
    String methodName, {
    required Uri? uri,
    required String? body,
    dynamic responseJson,
    int? statusCode,
  }) async {
    final uriData = 'Response $methodName\n$uri, statusCode: $statusCode';

    final bodyLog = _prettyJson(responseJson) ?? body;

    logPrint('[$uriData$bodyLog]');

    final responseBody = decodeResponseBody(body);
    apiCallLog = apiCallLog.copyWith(
      response: uri.toString(),
      status: statusCode,
      responseBody: responseBody,
      responseError: responseBody == null ? bodyLog : null,
    );

    final index = List<ApiCallLog>.from(logController.value).indexWhere((e) => e.request == apiCallLog.request);
    final lastLog = List<ApiCallLog>.from(logController.value);
    lastLog.replaceRange(index, index + 1, [apiCallLog]);
    logController.value = lastLog;
    apiCallLog = ApiCallLog(response: '', request: '', status: 0, reqParams: {}, responseBody: {}, responseError: null);
  }

  Map<String, dynamic>? decodeResponseBody(String? body) {
    try {
      return jsonDecode(body ?? '{}');
    } catch (_) {
      return null;
    }
  }

  String getUriLog(Uri uri) => '${uri.scheme}://${uri.host}${uri.path}';

  String? _getErrorMessage({required dynamic parsedResponse, required http.Response response}) {
    return parsedResponse['detail'];
  }
}

class Exception400 implements Exception {
  final String? status;
  final String? errorMessageTitle;
  final String? errorMessage;
  final String? body;
  const Exception400({
    this.status,
    this.errorMessageTitle,
    this.errorMessage,
    this.body,
  });

  static const int errorCode = 400;
}

class FetchDataException implements Exception {
  final String? body;
  const FetchDataException({this.body});

  static const int errorCode = 500;
}

String? _prettyJson(Object? json) {
  if (json == null) {
    return null;
  }
  return const JsonEncoder.withIndent('  ').convert(json);
}
