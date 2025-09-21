import 'package:flutter_sdui_app/core/enums/api_response_status.dart';

class OtpSendResponse {
  final APIResponseStatus status;
  final int expiresIn;

  OtpSendResponse({required this.status, required this.expiresIn});

  OtpSendResponse copyWith({APIResponseStatus? status, int? expiresIn}) =>
      OtpSendResponse(
        status: status ?? this.status,
        expiresIn: expiresIn ?? this.expiresIn,
      );

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) =>
      OtpSendResponse(
        status: APIResponseStatusExtension.fromString(json['status']),
        expiresIn: json['expires_in'],
      );

  Map<String, dynamic> toJson() => {
    'status': status.value,
    'expires_in': expiresIn,
  };
}
