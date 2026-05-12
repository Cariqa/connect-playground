class ApiCallLog {
  final String request;
  final Map<String, dynamic>? reqParams;
  final String response;
  final Map<String, dynamic>? responseBody;
  final String? responseError;
  final int status;

  ApiCallLog({
    required this.request,
    required this.reqParams,
    required this.response,
    required this.responseBody,
    required this.responseError,
    required this.status,
  });

  ApiCallLog copyWith({
    String? request,
    String? response,
    Map<String, dynamic>? reqParams,
    Map<String, dynamic>? responseBody,
    String? responseError,
    int? status,
  }) {
    return ApiCallLog(
      request: request ?? this.request,
      reqParams: reqParams ?? this.reqParams,
      response: response ?? this.response,
      responseBody: responseBody ?? this.responseBody,
      responseError: responseError ?? this.responseError,
      status: status ?? this.status,
    );
  }
}
