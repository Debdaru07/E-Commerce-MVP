class WaitlistRequestModel {
  final String email;

  WaitlistRequestModel({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
