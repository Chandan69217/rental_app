import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rental_app/custom_paints/rect_painter.dart';
import 'package:rental_app/model/consts.dart';
import 'package:rental_app/utilities/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../custom_paints/circular_curve.dart';
import '../../utilities/color_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final bool enableBack;
  final VoidCallback? onBackPressed;
  AttendanceScreen({this.enableBack = false, this.onBackPressed});
  @override
  State<StatefulWidget> createState() => _FeeScreenStates();
}

class _FeeScreenStates extends State<AttendanceScreen> {
  bool _punchBtnLoading = false;
  bool switchValue = false;
  String _token = 'N/A';
  LocationPermissionStatus permissionStatus = LocationPermissionStatus.denied;

  @override
  void initState() {
    init();
  }

  void init() async{
    permissionStatus = await getLocationPermission();
    if(permissionStatus == LocationPermissionStatus.serviceDisabled){
      _showDialog(title: 'Location service', desc: 'Your devices location service is off', onClick: (){
        widget.onBackPressed!();
      });
    }
    var pref = await SharedPreferences.getInstance();
    _token = pref.getString(Consts.TOKEN) ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        title: Text(
          'Attendance',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: ColorTheme.Snow_white),
        ),
        leading: IconButton(
            onPressed: () => widget.enableBack
                ? Navigator.pop(context)
                : widget.onBackPressed!(),
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: ColorTheme.Snow_white,
            )),
      ),

      body: FutureBuilder(future: _getAttendance(), builder: (context,snapshot){
        bool hasData = snapshot.hasData ? true : snapshot.hasError ? false : false;
        return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.ss),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _punchCard(),
                  SizedBox(height: 10.ss,),
                  const Text('Last Attendance',textAlign: TextAlign.start,),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:  12.ss),
                        child: hasData && snapshot.data!.isNotEmpty ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.ss,horizontal: 5.ss),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.ss),
                                    color: ColorTheme.Ghost_White,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.ss,
                                          blurStyle: BlurStyle.outer
                                      )
                                    ]
                                ),
                                child: CustomPaint(
                                  painter: RectPainter(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(15.ss),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('In : ${snapshot.data![index]['attendanceTime']}',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),),
                                              Text('Out : N/A',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 10.ss,vertical: 2.ss),alignment: Alignment.bottomRight,child: Text('N/A',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),)))
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ) : Center(child: Text('No attendance available',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Gray),),)
                      )
                  )
                ],
              ),
            ));
      })
    );
  }

  Widget _punchCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: ColorTheme.Gray,
              blurRadius: 10.ss,
              spreadRadius: 3.ss,
            ),
          ],
          borderRadius: BorderRadius.circular(14.ss),
          color: ColorTheme.Blue.withOpacity(0.95)),
      child: CustomPaint(
        painter: CircularWave(
            waveColor: ColorTheme.Snow_white,
            waveHeight: 60,
            waveLength: 550,
            phaseShift: 1),
        child: Padding(
          padding: EdgeInsets.all(12.ss),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50.ss),
                        child: Image.asset(
                          'assets/hotels_images/profile_pic.webp',
                          fit: BoxFit.cover,
                          width: 50.ss,
                          height: 50.ss,
                        )),
                    SizedBox(
                      width: 10.ss,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chandan Sharma',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: ColorTheme.Snow_white),
                        ),
                        Text(
                          'Building: 12A | Room No: 56',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: ColorTheme.Ghost_White),
                        ),
                        SizedBox(
                          height: 5.ss,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.ss,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8.ss),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In : 23-Dec-2024 11:17 AM',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: ColorTheme.Snow_white),
                              ),
                              Text('Out : N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: ColorTheme.Snow_white)),
                            ],
                          ),
                        ),
                        _punchBtnLoading ? Expanded(child: Center(child: SizedBox(width:25.ss,height:25.ss,child: CircularProgressIndicator(color: ColorTheme.Snow_white,strokeWidth: 3,)))) :
                        Expanded(
                          child:  FlutterSwitch(
                            width: 125.0,
                            height: 55.0,
                            valueFontSize: 25.0,
                            toggleSize: 45.0,
                            value: switchValue,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: true,
                            onToggle: _markAttendance
                          ),
                        ),
                          // child: ElevatedButton(
                          //   onPressed: _markAttendance,
                          //   style: const ButtonStyle(
                          //       backgroundColor:
                          //       WidgetStatePropertyAll(Colors.red),
                          //       foregroundColor: WidgetStatePropertyAll(
                          //           ColorTheme.Snow_white)),
                          //   child: Text('Punch Out'),
                          // ),
                      ],
                    ))
              ]),
        ),
      ),
    );
  }

  Future<bool> _markAttendance(bool switchValue) async{
    setState(() {
      _punchBtnLoading = true;
    });
    if( permissionStatus == LocationPermissionStatus.granted){
      var location = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      if(!location.isMocked){
        Map<String,dynamic> body = {
          "id": "1",
          "hostelId":"1",
          "tenantId": "1",
          "latitude": "25.2612368768767867",
          "longitude": "85.823628768687678",
          "attendanceTime": "1:23 PM",
          "status": "OUT"
        };
        print(_token);
        Map<String,String> headers = {
          Consts.AUTHORIZATION : 'Bearer $_token',
        };

        try{
          Uri url = Uri.parse('https://appadmin.atharvaservices.com/api/Attendance/tenantAttendance');
          var response = await post(url,headers: headers,body: body,);
          if(response.statusCode == 200){
            Fluttertoast.showToast(msg: 'Punch In');
            return true;

          }else{
            print('Response Code : ${response.statusCode}');
          }
        }catch(exception){
          print('exception : $exception');
        }
      }else{
        _showDialog(title: 'Mocked Location', desc: 'You are using mocked location please turn it off..', onClick: (){});
      }
    }else if(permissionStatus == LocationPermissionStatus.serviceDisabled){
      Fluttertoast.showToast(msg: 'turn on location');
    }else{
      Fluttertoast.showToast(msg: 'location permission denied');
    }
    setState(() {
      _punchBtnLoading = false;
    });
    return false;
  }






  Future<List<Map<String,dynamic>>> _getAttendance() async {
    var pref = await SharedPreferences.getInstance();
    try{
      if(pref.containsKey(Consts.TOKEN)){
        var token = pref.getString(Consts.TOKEN)??'';
        Uri uri = Uri.parse('https://appadmin.atharvaservices.com/api/Attendance/GetAttendance');
        var response =  await get(uri,headers: {
          Consts.AUTHORIZATION : 'Bearer $token',
          Consts.CONTENT_TYPE : 'application/json',
        });
        if(response.statusCode == 200){
          var rawBody = jsonDecode(response.body);
          if(rawBody[Consts.STATUS] == 'Success'){
            return List.from(rawBody['data']);
          }else{
            Future.error('${rawBody['message']}');
          }
        }else{
          Future.error('${response.reasonPhrase}');
        }
      }else{
        print('User Token Not Available');
        return Future.error('User Token Not Available');
      }
    }catch(exception){
      print('Exception : $exception');
      return Future.error(exception.toString());
    }
    return Future.error('unable to fetch data');
  }

  _showDialog({required String title,required String desc,required VoidCallback? onClick}){
    AwesomeDialog(
        context: context,
        title: title,
        btnOkOnPress: onClick,
        dismissOnTouchOutside: false,
        desc: desc,
        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        descTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        headerAnimationLoop: false
    ).show();
  }
}



