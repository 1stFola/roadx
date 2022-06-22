
class ErrorInfo {
  String message;
  String code;

  ErrorInfo({
    this.message,
    this.code,
  });

  factory ErrorInfo.fromJson(Map<String, dynamic> json) {
    return ErrorInfo(
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
      };
}
