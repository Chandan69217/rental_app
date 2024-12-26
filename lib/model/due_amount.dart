import 'package:rental_app/model/consts.dart';

class DueAmount {
  int id;
  String tenantName;
  String roomNumber;
  int dueAmount;
  String dueDate;
  String status;

  DueAmount(
      {required this.id,
      required this.tenantName,
      required this.roomNumber,
      required this.dueAmount,
      required this.dueDate,
      required this.status});

  factory DueAmount.fromJson(Map<String,dynamic> json){
    return DueAmount(
      id: json[Consts.ID],
      tenantName: json[Consts.TENANT_NAME],
      roomNumber: json[Consts.ROOM_NO],
      dueAmount: json[Consts.DUE_AMOUNT],
      dueDate: json[Consts.DUE_DATE],
      status: json[Consts.STATUS],
    );
  }

  Map<String,dynamic> toJson() => {
    Consts.ID : id,
    Consts.TENANT_NAME : tenantName,
    Consts.ROOM_NO : roomNumber,
    Consts.DUE_AMOUNT : dueAmount,
    Consts.DUE_DATE : dueDate,
    Consts.STATUS : status,
  };
}
