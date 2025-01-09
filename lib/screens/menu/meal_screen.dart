import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rental_app/utilities/alert_dialog.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:rental_app/widgets/cust_circular_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';

class MealScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MealScreenStates();
}

class _MealScreenStates extends State<MealScreen> {
  final bool _isEnabled = false;
  String _tenantName = 'unknown name';
  bool _breakfastBtnVisibility = false;
  bool _lunchBtnVisibility = false;
  bool _dinnerBtnVisibility = false;

  Future<List<Map<String, dynamic>>>? _getMealsData() async {
    var uri = Uri.parse('https://appadmin.atharvaservices.com/api/Meal/tenantMeal');
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString(Consts.TOKEN) ?? '';
    var connectivityResult = await Connectivity().checkConnectivity();
    if(!(connectivityResult.contains(ConnectivityResult.wifi)||connectivityResult.contains(ConnectivityResult.mobile)||connectivityResult.contains(ConnectivityResult.ethernet))){
     alertDialog(contextParent: context,);
      return Future.error(false);
    }
    if (token.isEmpty) {
      print('Token is empty');
      return [];
    }

   try{
     var response = await get(uri,headers: {
       Consts.AUTHORIZATION: 'Bearer $token', // Ensure 'Bearer ' is prefixed to the token
       Consts.CONTENT_TYPE: 'application/json',
     });

     // print('Status Code: ${response.statusCode}');
     // print('Response Body: ${response.body}');

     if(response.statusCode == 200){
       _tenantName = pref.getString(Consts.TENANT_NAME) ?? 'unknown name';
       Map<String, dynamic> decodedJson = json.decode(response.body);
       List<Map<String, dynamic>> mealsList =
       List<Map<String, dynamic>>.from(decodedJson['meal']);
       _checkVisitingTiming(mealsList);
       return mealsList;
     }else{
       print('Request failed with status: ${response.statusCode}');
       return [];
     }
   }catch(exception,trace){
     print('Exception : $exception , Trace : $trace');
     return [];
   }
  }

  void _checkVisitingTiming(List<Map<String,dynamic>> mealData) async{
    _checkMealTime(mealData);
    Timer.periodic(Duration(minutes: 1), (timer){
      _checkMealTime(mealData);
    });
  }
  void _checkMealTime(List<Map<String,dynamic>> mealData){
    setState(() {
      DateTime currentTime = DateTime.now();
      DateTime breakfastStatingTime = _parseFormatedTime(mealData[0]['mealStartTime'], currentTime);
      DateTime breakfastEndingTime = _parseFormatedTime(mealData[0]['mealEndtime'], currentTime);
      DateTime lunchStatingTime = _parseFormatedTime(mealData[1]['mealStartTime'], currentTime);
      DateTime lunchEndingTime = _parseFormatedTime(mealData[1]['mealEndtime'], currentTime);
      DateTime dinnerStatingTime = _parseFormatedTime(mealData[2]['mealStartTime'], currentTime);
      DateTime dinnerEndingTime = _parseFormatedTime(mealData[2]['mealEndtime'], currentTime);
      if(currentTime.isAfter(breakfastStatingTime) && currentTime.isBefore(breakfastEndingTime)){
        _breakfastBtnVisibility = true;
      }else{
        _breakfastBtnVisibility = false;
      }

      if(currentTime.isAfter(lunchStatingTime) && currentTime.isBefore(lunchEndingTime)){
        _lunchBtnVisibility = true;
      }else{
        _lunchBtnVisibility = false;
      }

      if(currentTime.isAfter(dinnerStatingTime) && currentTime.isBefore(dinnerEndingTime)){
        _dinnerBtnVisibility = true;
      }else{
        _dinnerBtnVisibility = false;
      }
    });
  }

  DateTime _parseFormatedTime(String formatTime,DateTime refDateTime ){
    DateFormat format = DateFormat('h:mm a');
    DateTime parsedTime = format.parse(formatTime);
    return DateTime(refDateTime.year,refDateTime.month,refDateTime.day,parsedTime.hour,parsedTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.Blue,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_left_outlined),
            color: ColorTheme.Snow_white,
          ),
          title: Text(
            'Meal',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: ColorTheme.Snow_white, fontSize: 18),
          ),
        ),
        body: FutureBuilder(
            future: _getMealsData(),
            builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.ss, vertical: 24),
                  child: Column(
                    children: [
                      _MealTile(
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => _VisitScreen(mealsDetails: snapshot.data![0],tenantName: _tenantName,)));
                        },
                        title: 'Breakfast',
                        subTitle: snapshot.hasData && snapshot.data!.isNotEmpty ? 'get your breakfast between ${snapshot.data![0]['mealStartTime']} to ${snapshot.data![0]['mealEndtime']}' : '',
                        loading: snapshot.hasData,
                        enabled: _breakfastBtnVisibility
                        //snapshot.hasData ? snapshot.data![0][Consts.STATUS] == Consts.ACTIVE ? true : false : false
                      ),
                      SizedBox(
                        height: 18.ss,
                      ),
                      _MealTile(
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => _VisitScreen(mealsDetails: snapshot.data![1],tenantName: _tenantName,)));
                        },
                        title: 'Lunch',
                        subTitle: snapshot.hasData && snapshot.data!.isNotEmpty? 'get your lunch between ${snapshot.data![1]['mealStartTime']} to ${snapshot.data![1]['mealEndtime']}' : '',
                        enabled:  _lunchBtnVisibility,
                        //snapshot.hasData ? snapshot.data![1][Consts.STATUS] == Consts.ACTIVE ? true : false : false,
                        loading: snapshot.hasData,
                      ),
                      SizedBox(
                        height: 18.ss,
                      ),
                      _MealTile(
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => _VisitScreen(mealsDetails: snapshot.data![2],tenantName: _tenantName,)));
                        },
                        title: 'Dinner',
                        subTitle: snapshot.hasData && snapshot.data!.isNotEmpty? 'get your dinner between ${snapshot.data![2]['mealStartTime']} to ${snapshot.data![2]['mealEndtime']}' : '',
                        enabled:  _dinnerBtnVisibility,
                        //snapshot.hasData ? snapshot.data![2][Consts.STATUS] == Consts.ACTIVE ? true : false : false,
                        loading: snapshot.hasData,
                      ),
                    ],
                  ),
                );

            }
            )
    );
  }

}

class _MealTile extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onClick;
  final String? title;
  final String? subTitle;
  final bool loading;

  _MealTile(
      {this.enabled = true,
      this.onClick,
      this.title = '',
      this.subTitle = '',
      this.loading = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.ss),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ColorTheme.Pole_Blue,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.ss)],
          borderRadius: BorderRadius.all(Radius.circular(8.ss))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Visibility(
                  visible: loading,
                  child: Text(
                    subTitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.ss,
          ),
          Expanded(
              flex: 1,
              child: loading
                  ?
                   ElevatedButton(
                      onPressed: enabled ? onClick : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.ss),
                        ),
                        foregroundColor:
                            enabled ? ColorTheme.Snow_white : ColorTheme.Gray,
                        backgroundColor:
                            enabled ? ColorTheme.Blue : Colors.black,
                      ),
                      child: const Text('Visit'),
                    ) : Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                  height: 24.ss,
                  width: 25.ss,
                  child: CustCircularProgress(
                    color: ColorTheme.Blue,
                  ))))
        ],
      ),
    );
  }
}

class _VisitScreen extends StatelessWidget {
  final Map<String,dynamic> mealsDetails;
  final String tenantName;
  _VisitScreen({required this.mealsDetails,required this.tenantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealsDetails['mealName']),
        backgroundColor: ColorTheme.Blue,
        foregroundColor: ColorTheme.Snow_white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.keyboard_arrow_left_outlined)),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: mealsDetails[Consts.STATUS] == Consts.ACTIVE ? 1: 0.5,
                    child: QrImageView(
                      data: mealsDetails.toString(),
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  Visibility(visible:mealsDetails[Consts.STATUS] == Consts.INACTIVE ,child: Transform.rotate(angle: -0.8,child: Image.asset('assets/icons/taken_txt.webp',width: 270,height: 270,color: Colors.red,)))
                ],
              ),
              // Expanded(child: Text('scan',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Blue,fontWeight: FontWeight.bold,fontSize: 12.fss),))
              Padding(
                padding: EdgeInsets.only(bottom: 10.ss),
                child: RichText(
                    text: TextSpan(
                        text: tenantName,
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                          children: [
                            /* TextSpan(text: 'Building: 12A | Room No: 56'),TextSpan(text: '\n'),TextSpan(text: '23-dec-2024 10:00 am') */
                          ],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: ColorTheme.Gray))
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
