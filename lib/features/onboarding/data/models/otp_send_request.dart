class OtpSendRequest {
  final String phone;

  OtpSendRequest({required this.phone});

  OtpSendRequest copyWith({String? phone}) =>
      OtpSendRequest(phone: phone ?? this.phone);

  factory OtpSendRequest.fromJson(Map<String, dynamic> json) =>
      OtpSendRequest(phone: json['phone']);

  Map<String, dynamic> toJson() => {'phone': phone};
}
