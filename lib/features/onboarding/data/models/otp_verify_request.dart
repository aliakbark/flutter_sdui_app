class OtpVerifyRequest {
  final String otp;
  final String phone;

  OtpVerifyRequest({required this.otp, required this.phone});

  OtpVerifyRequest copyWith({String? otp, String? phone}) =>
      OtpVerifyRequest(otp: otp ?? this.otp, phone: phone ?? this.phone);

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      OtpVerifyRequest(otp: json['otp'], phone: json['phone']);

  Map<String, dynamic> toJson() => {'otp': otp, 'phone': phone};
}
