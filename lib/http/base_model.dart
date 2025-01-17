class BaseModel<T> {
  int? errorCode;
  String? errorMsg;
  T? data;

  BaseModel.fromJson(dynamic json) {
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    data = json['data'];
  }
}