import 'package:flutter_sdui_app/core/enums/api_response_status.dart';

class OtpVerifyResponse {
  final APIResponseStatus status;

  OtpVerifyResponse({required this.status});

  OtpVerifyResponse copyWith({APIResponseStatus? status}) =>
      OtpVerifyResponse(status: status ?? this.status);

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      OtpVerifyResponse(
        status: APIResponseStatusExtension.fromString(json['status']),
      );

  Map<String, dynamic> toJson() => {'status': status.value};
}
