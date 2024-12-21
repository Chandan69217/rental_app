//
// class onLoginRequestSuccess {
//   final String mobile;
//   final String password;
//
//   onLoginRequestSuccess({required this.mobile, required this.password});
//
//   Map<String, dynamic> toJson() =>{
//     'mobile': mobile,
//     'password': password,
//   };
//
// }
//
// class LoginResponse {
//   final String status;
//   final String message;
//   final Data? data;
//
//   LoginResponse({required this.status, required this.message, this.data});
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
//     status: json['status'],
//     message: json['message'],
//     data: json['data'] != null ? Data.fromJson(json['data']) : null,
//   );
// }
//
// class Data {
//   final String userId;
//   final String name;
//   final String mobile;
//   final String token;
//
//   Data({
//     required this.userId,
//     required this.name,
//     required this.mobile,
//     required this.token,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     userId: json['user_id'],
//     name: json['name'],
//     mobile: json['mobile'],
//     token: json['token'],
//   );
// }
//
// class onLoginRequestFaild {
//   final String status;
//   final String message;
//
//   onLoginRequestFaild({required this.status, required this.message});
//
//   Map<String, dynamic> toJson() =>{
//     'mobile': status,
//     'password': status,
//   };
// }
