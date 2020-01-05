import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest(this.email, this.password);

  String toJson() {
    return jsonEncode({
      "api_user": {
        "email": this.email,
        "password": this.password
      }
    });
  }
}