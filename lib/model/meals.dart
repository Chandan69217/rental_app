import 'consts.dart';

class Meals {
  int id;
  String name;
  String time;
  String verificationCode;
  String status;

  Meals(
      {required this.id,
      required this.name,
      required this.time,
      required this.verificationCode,
      required this.status});

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
        id: json[Consts.ID],
        name: json[Consts.NAME],
        time: json[Consts.TIME],
        verificationCode: json[Consts.VERIFICATION_CODE],
        status: json[Consts.STATUS]);
  }

  Map<String,dynamic> toJson(){
    return {
      Consts.ID : id,
      Consts.NAME : name,
      Consts.TIME : time,
      Consts.VERIFICATION_CODE : verificationCode,
      Consts.STATUS : status,
    };
  }

}
