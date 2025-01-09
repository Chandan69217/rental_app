import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/custom_paints/rect_painter.dart';
import 'package:rental_app/model/consts.dart';
import 'package:rental_app/utilities/permission_handler.dart';
import 'package:rental_app/widgets/cust_circular_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../custom_paints/circular_curve.dart';
import '../../utilities/color_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final bool enableBack;
  final VoidCallback? onBackPressed;
  AttendanceScreen({this.enableBack = false, this.onBackPressed});
  @override
  State<StatefulWidget> createState() => _AttendanceScreenStates();
}

class _AttendanceScreenStates extends State<AttendanceScreen> {
  bool _punchBtnLoading = false;
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
        final lastAttendance = hasData? snapshot.data!['lastAttendance'] : [];
        if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString(),style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Gray1),),);
        }else{
          return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.ss),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _punchCard(hasData ? snapshot.data!['lastAttendanceStatus']:{}),
                    SizedBox(height: 10.ss,),
                    const Text('Last Attendance',textAlign: TextAlign.start,),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical:  12.ss),
                            child: hasData && snapshot.data!.isNotEmpty ? ListView.builder(
                                itemCount: lastAttendance.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var inTime = lastAttendance[index]['inTime']!=''?lastAttendance[index]['inTime']:'N/A';
                                  var outTime = lastAttendance[index]['outTime']!=''?lastAttendance[index]['outTime']:'N/A';
                                  var attendanceDate = lastAttendance[index]['attendanceDate']!=''?lastAttendance[index]['attendanceDate']:'N/A';
                                  return Padding(
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
                                                    Text('In : $inTime',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),),
                                                    Text('Out : $outTime',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 10.ss,vertical: 2.ss),alignment: Alignment.bottomRight,child: Text(attendanceDate,style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.fss),)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );}
                            ) : Center(child: Text('No attendance available',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Gray1),),)
                        )
                    )
                  ],
                ),
              ));
        }
      })
    );
  }

  Widget _punchCard(Map<String,dynamic> value) {
    final status = value.isNotEmpty ? value[Consts.STATUS] :'error';
    final lastStatus = status == 'Success' ? value['data']['lastStatus'] : 'N/A';
    final attendanceTimeIn = status == 'Success'? value['data']['inTime'] !='' ? value['data']['inTime'] : 'N/A':'N/A';
    final attendanceTimeOut = status == 'Success'? value['data']['outTime']!='' ? value['data']['outTime'] : 'N/A':'N/A';
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
            waveHeight: 32,
            waveLength: 550,
            phaseShift: 1),
        child: Padding(
          padding: EdgeInsets.all(12.ss),
          child: status == 'error' ? Center(child: CustCircularProgress(color: ColorTheme.Snow_white,)):Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'In : ${attendanceTimeIn}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: ColorTheme.Snow_white),
                    ),
                    Text('Out : ${attendanceTimeOut}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: ColorTheme.Snow_white)),
                  ],
                ),
              ),
              if (_punchBtnLoading) Expanded(child: Center(child: CustCircularProgress(color: ColorTheme.Snow_white,))) else FlutterSwitch(
                width: 120.ss,
                height: 40,
                value: lastStatus == 'IN' ? true:false,
                borderRadius: 30.0,
                showOnOff: true,
                padding: 8.ss,
                activeText: 'Out',
                inactiveText: 'In',
                inactiveColor: Colors.green,
                activeColor: Colors.red,
                activeTextFontWeight: FontWeight.normal,
                inactiveTextFontWeight: FontWeight.normal,
                valueFontSize: 18.fss,
                activeIcon: Icon(Icons.arrow_back_rounded),
                inactiveIcon: Icon(Icons.arrow_forward_rounded),
                onToggle: _markAttendance
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markAttendance(bool value) async{
    final connectionResult = await Connectivity().checkConnectivity();
    if(!(connectionResult.contains(ConnectivityResult.mobile)||connectionResult.contains(ConnectivityResult.wifi)||connectionResult.contains(ConnectivityResult.ethernet))){
      Fluttertoast.showToast(msg: 'No internet connection available');
      return;
    }
    setState(() {
      _punchBtnLoading = true;
    });
    if( permissionStatus == LocationPermissionStatus.granted){
      var location = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      if(!location.isMocked){
        final body = jsonEncode({
          "id": "1",
          "hostelId":"1",
          "tenantId": "1",
          "latitude": "${location.latitude}",
          "longitude": "${location.longitude}",
          "attendanceTime": "${DateFormat('h:mm a').format(DateTime.now())}",
          "status": value ? "IN" : "OUT"
        }) ;
        print(_token);
        Map<String,String> headers = {
          'Content-Type': 'application/json',  // Set Content-Type header
          'Authorization': 'Bearer $_token',
        };

        try{
          final url = Uri.parse(
              'https://appadmin.atharvaservices.com/api/Attendance/tenantAttendance');
          final response = await post(url,headers: headers,body: body,);
          if(response.statusCode == 200){
            AwesomeDialog(context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: '${value ? "Punch in" : "Punch out"} successfully',
              btnOkOnPress: (){}
            ).show();
            setState(() {
              _punchBtnLoading = false;
            });
          }else{
            AwesomeDialog(context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'unable to mark your attendance',
                btnOkOnPress: (){}
            ).show();
            setState(() {
              _punchBtnLoading = false;
            });
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
  }


  Future<Map<String,dynamic>> _getAttendance() async {
    var pref = await SharedPreferences.getInstance();
    final connectionResult = await Connectivity().checkConnectivity();
    if(!(connectionResult.contains(ConnectivityResult.mobile)||connectionResult.contains(ConnectivityResult.wifi)||connectionResult.contains(ConnectivityResult.ethernet))){
      if(widget.enableBack){
        Fluttertoast.showToast(msg: 'No internet connection available');
      }
      return  Future.error('no internet connection');
    }
    try{
      if(pref.containsKey(Consts.TOKEN)){
        final token = pref.getString(Consts.TOKEN)??'';
        Uri uri1 = Uri.parse('https://appadmin.atharvaservices.com/api/Attendance/GetAttendance');
        Uri uri2 = Uri.parse('https://appadmin.atharvaservices.com/api/Attendance/GetTenantAttendanceStatus');
        final getResponse1 =  get(uri1,headers: {
          Consts.AUTHORIZATION : 'Bearer $token',
          Consts.CONTENT_TYPE : 'application/json',
        });

        final getResponse2 =  get(uri2,headers: {
          Consts.AUTHORIZATION : 'Bearer $token',
          Consts.CONTENT_TYPE : 'application/json',
        });

        final response = await Future.wait([getResponse1,getResponse2]);

        if(response[0].statusCode == 200 && (response[1].statusCode == 200 || response[1].statusCode != 200)){
          final rawBody0 = jsonDecode(response[0].body);
          final rawBody1 = jsonDecode(response[1].body);
          if(rawBody0[Consts.STATUS] == 'Success' && (rawBody1[Consts.STATUS] == 'Success' || rawBody1[Consts.STATUS] == 'error')){
            var result = {
              'lastAttendance' : List.from(rawBody0['data']),
              'lastAttendanceStatus' : rawBody1
            };
            return result;
          }else{
            Future.error('rawBody_0 message : ${rawBody0['message']} rawBody_1 message ${rawBody1['message']}');
          }
        }else{
          Future.error('response_0 reason: ${response[0].reasonPhrase} response_1 reason: ${response[1].reasonPhrase}');
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



