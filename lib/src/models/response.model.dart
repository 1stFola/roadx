class ResponseModel {
  bool status;
  String message = "";
  dynamic data;

  ResponseModel({ this.status, this.message, this.data });
}
