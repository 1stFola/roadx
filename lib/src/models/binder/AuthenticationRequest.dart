class AuthenticationRequest {
  final String social_token;
  final String fcmToken;
  final String first_name;
  final String last_name;
  final String id;
  final String email;
  final String image;
  final String password;

  const AuthenticationRequest(
      {this.first_name,
      this.last_name,
      this.id,
      this.email,
      this.social_token,
      this.fcmToken,
      this.image,
      this.password});

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) {
    return AuthenticationRequest(
        first_name: json['first_name'],
        last_name: json['last_name'],
        id: json['id'],
        social_token: json['social_token'],
        fcmToken: json['fcmToken'],
        email: json['email'],
        image: json['image'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'id': id,
        'social_token': social_token,
        'fcmToken': fcmToken,
        'image': image,
        'password': password
      };
}
