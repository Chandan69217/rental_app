import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/model/consts.dart';
import 'package:rental_app/screens/menu/new_leave_Screen.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';

class LeaveScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen>{
  late Future<List<Map<String, List<Map<String, dynamic>>>>> _allLeaveData;
  List<Map<String,List<Map<String,dynamic>>>> _casualLeaveData = [];
  List<Map<String,List<Map<String,dynamic>>>> _sickLeaveData = [];
  @override
  void initState() {
    _allLeaveData = _getLeaveData();
  }

  _refresh(){
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: const Icon(Icons.keyboard_arrow_left_rounded,color: ColorTheme.Snow_white,)),
        title: Text('Leaves',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color:  ColorTheme.Snow_white,fontWeight: FontWeight.bold),),
        actions: [
          InkWell(
              borderRadius: BorderRadius.circular(20.ss),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(8.ss),
                child: const Badge(
                  child: Icon(Icons.notifications_none_rounded),
                ),
              )),
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewLeaveScreen(refresh: _refresh,))), icon: const Icon(Icons.add))
        ],
        foregroundColor: ColorTheme.Snow_white,
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Column(
          children: [
            TabBar(labelStyle: Theme.of(context).textTheme.titleSmall,
              tabs: const <Tab>[
                Tab(text: 'ALL',),
                Tab(text: 'Casual'),
                Tab(text: 'Sick'),
              ],indicatorColor: ColorTheme.Blue,),
            Expanded(
              child: FutureBuilder(
                future: _allLeaveData,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return TabBarView(children: [
                      _ListOfLeaves(data: snapshot.data,),
                      _ListOfLeaves(data: _casualLeaveData,),
                      _ListOfLeaves(data: _sickLeaveData,),
                    ]);
                  }else{
                    return const Center(child: CircularProgressIndicator(color: ColorTheme.Blue,),);
                  }
                },
              ),
            )
          ],
        )
      )
    );
  }

  Future<bool> _categorizeList(List<Map<String, List<Map<String, dynamic>>>> allLeaves) async{
    for(var group in allLeaves){
      for(var value in group.values){
        for(var map in value){
          if(map['leaveType']=='Sick'){
            _sickLeaveData.add({group.keys.first : [map]});
          }else{
            _casualLeaveData.add({group.keys.first:[map]});
          }
        }
      }
    }
    return true;
  }

  Future<List<Map<String, List<Map<String, dynamic>>>>> _getLeaveData() async {
    final uri = Uri.parse('https://appadmin.atharvaservices.com/api/Leave/showLeave');
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString(Consts.TOKEN) ?? '';

    if (token.isEmpty) {
      print('User token is not available');
      return Future.error('User token is not available');
    }

    try {
      var response = await get(
        uri,
        headers: {
          Consts.AUTHORIZATION: 'Bearer $token',
          Consts.CONTENT_TYPE: 'application/json'
        },
      );

      // Check for valid response and handle errors
      if (response.statusCode == 200) {
        final rawData = json.decode(response.body) as Map<String,dynamic>;
        if (rawData[Consts.STATUS] == 'success' && rawData['data'] != null) {
          var applications = List<Map<String, dynamic>>.from(rawData['data']['applications']);
          var groupData = await groupRawData(applications);
          var listOfGroups = groupData.entries.map((entry) {
            return {entry.key: entry.value};
          }).toList();
          await _categorizeList(listOfGroups);
          return listOfGroups;
        } else {
          print('Error: ${rawData[Consts.STATUS]}');
          return Future.error('Error fetching leave data');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return Future.error('Failed to fetch data from API');
      }
    } catch (exception) {
      print('Exception: $exception');
      return Future.error('Exception occurred while fetching leave data');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> groupRawData(List<Map<String, dynamic>> applications) async {
    Map<String, List<Map<String, dynamic>>> parseData = {};
    print('Total number of accepted applications: ${applications.length}');

    final DateFormat dateFormat1 = DateFormat("dd-MMM-yyyy");
    final DateFormat dateFormat2 = DateFormat("MMMM yyyy");

    for (var temp in applications) {
      var dateString = temp['startDate'];

      if (dateString == null || dateString.isEmpty) {
        print('Missing startDate for application: $temp');
        continue;
      }

      try {
        DateTime applicationDate = dateFormat1.parse(dateString);
        var formatDateString = dateFormat2.format(applicationDate);
        if (parseData.containsKey(formatDateString)) {
          parseData[formatDateString]?.add(temp);
        } else {
          parseData[formatDateString] = [temp];
        }
      } catch (e) {
        print("Error parsing date: $dateString - Exception: $e");
      }
    }

    return parseData;
  }

}

class _ListOfLeaves extends StatelessWidget{
  List<Map<String,List<Map<String,dynamic>>>>? data = [];
  _ListOfLeaves({this.data});
  @override
  Widget build(BuildContext context) {
    var leaveData = data??[];
    print('length of data : ${data!.length}');
    return leaveData.isEmpty ? const Center(child: Text('No Data Available'),):
        ListView.builder( itemCount: leaveData.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
          print('${data!.length}');
          return _leaveListTile(tileData: leaveData[index],);
        },
        );
  }
}

class _leaveListTile extends StatelessWidget{
 Map<String,List<Map<String,dynamic>>> tileData;
 static final Map<String,List<Color>> _statusColor = {
   'REJECTED' : [ColorTheme.LIGHT_RED,ColorTheme.RED_DEEP1],
   'DECLINED' : [ColorTheme.LIGHT_RED,ColorTheme.RED_DEEP1],
   'APPROVED' : [ColorTheme.LIGHT_GREEN,ColorTheme.GREEN_DEEP1],
   'AWAITING' : [ColorTheme.Orange_LIGHT,ColorTheme.Orange_DEEP1],
 };
 static final Map<String,Color> _leaveTypeColor = {
   'CASUAL' : ColorTheme.Orange_DEEP1,
   'SICK' : ColorTheme.BLUE1,
 };
 _leaveListTile({required this.tileData});
  @override
  Widget build(BuildContext context) {
    var data = tileData.values.expand((x)=>x).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 26.ss,top: 8.ss),
          child: Text(tileData.keys.first,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Gray1),),
        ),
        ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
            return
              Padding(
              padding: EdgeInsets.symmetric(horizontal:  14.ss,vertical: 6.ss),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:  12.ss,vertical: 10.ss),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.ss)),
                    border: Border.all(width: 1.7.ss,color: ColorTheme.Gray1.withOpacity(0.3))
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_countNumberOfLeaveDays(data[index]['startDate'], data[index]['endDate']),style: TextStyle(color: ColorTheme.Gray1,fontSize: 13.fss),),
                            SizedBox(height: 3.ss,),
                            Text(_formatDate(data[index]['startDate']),style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.BLACK,fontSize: 24.ss,),),
                            SizedBox(height: 3.ss,),
                            Text('${data[index]['leaveType']}',style: TextStyle(color: _leaveTypeColor[data[index]['leaveType'].toString().toUpperCase()],fontSize: 12.fss),)
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: _statusColor[data[index]['status'].toString().toUpperCase()]!.first,
                                  borderRadius: BorderRadius.all(Radius.circular(8.ss))
                              ),
                              padding: EdgeInsets.symmetric(vertical:  8.ss,horizontal: 14.ss),
                              child: Text('${data[index]['status']}',style: TextStyle(color: _statusColor[data[index]['status'].toString().toUpperCase()]!.last,fontSize: 13.fss),overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(height: 10.ss,),
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.all(Radius.circular(8.ss)),
                              child: Container(
                                padding: EdgeInsets.all(8.ss),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.black12.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8.ss)
                                ),
                                child: Icon(Icons.keyboard_arrow_right_rounded,color: ColorTheme.Gray,),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(String dateString){
    DateFormat format1 = DateFormat('EEE, dd MMM');
    DateFormat format2 = DateFormat('dd-MMM-yyyy');
    DateTime givenDate = format2.parse(dateString);
    return format1.format(givenDate);
  }

 String _countNumberOfLeaveDays(String startingDate,String endingDate){
   DateFormat format = DateFormat('dd-MMM-yyyy');
   DateTime stating = format.parse(startingDate);
   DateTime ending = format.parse(endingDate);
   var day = ending.difference(stating).inDays;
   if(day == 1){
     return 'Full Day Application';
   }
   else if(day>1){
     return '$day Days Application';
   }else{
     return 'Half Day Application';
   }
 }

}