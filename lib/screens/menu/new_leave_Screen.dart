import 'dart:convert';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';
import '../../utilities/color_theme.dart';

class NewLeaveScreen extends StatefulWidget {
  VoidCallback? refresh;
  NewLeaveScreen({this.refresh});
  @override
  State<StatefulWidget> createState() => _NewLeaveScreenState();
}

class _NewLeaveScreenState extends State<NewLeaveScreen> {
  final ExpansionTileController _controller = ExpansionTileController();
  Map<String, String> _leaveData = {};
  final _startDate = DateTime.now();
  late DateTime _startDateEnding ;
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');
  final _lastDate = DateTime.now().add(Duration(days: DateTime.now().year));
  final TextEditingController _remarkController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.Blue,
          title: Text(
            'New Leave',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: ColorTheme.Snow_white),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.keyboard_arrow_left_outlined,
                color: ColorTheme.Snow_white,
              )),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.ss),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Leave Type'),
                        SizedBox(height: 5.ss,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4.ss),
                              ),
                              padding: EdgeInsets.symmetric(horizontal:8.ss),
                              child: DropdownMenu<String>(
                                hintText: 'select leave type',
                                 inputDecorationTheme:  InputDecorationTheme(
                                   border: InputBorder.none,

                                 ),
                                 width: MediaQuery.of(context).size.width,
                                  menuStyle:  MenuStyle(
                                   padding: WidgetStatePropertyAll(EdgeInsets.all(8.ss)), // Padding for items in the menu
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.ss),
                                      ),
                                    ),
                                    elevation: WidgetStatePropertyAll(4.ss), // Optional: set elevation (shadow)
                                  ),
                                  onSelected: (selectedType){
                                    if(selectedType !=null){
                                      if(_leaveData.containsKey('leaveType')){
                                        _leaveData.update('leaveType', (_)=>selectedType);
                                      }else{
                                        _leaveData.putIfAbsent('leaveType', ()=>selectedType);
                                      }
                                    }
                                  },
                                  dropdownMenuEntries: [
                                DropdownMenuEntry(value: 'Sick', label: 'Sick'),
                                DropdownMenuEntry(value: 'Casual', label: 'Casual'),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.ss,
                  ),
                  SizedBox(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Leave Date'),
                        SizedBox(height: 5.ss,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    selectableDayPredicate: (selectedDate){
                                      return true;
                                    },
                                    firstDate: _startDate,
                                    lastDate: _lastDate,
                                  ).then((pickedDate){
                                    if(pickedDate !=null){
                                      setState(() {
                                        _startDateEnding = pickedDate.add(Duration(days: 1));
                                        if(_leaveData.containsKey('startDate')){
                                          _leaveData.update('startDate', (_)=>_dateFormat.format(pickedDate));
                                          _leaveData.remove('endDate');
                                        }else{
                                          _leaveData.putIfAbsent('startDate', ()=>_dateFormat.format(pickedDate));

                                        }
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.ss),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8.ss),
                                    // boxShadow: [BoxShadow(color: ColorTheme.Gray,blurRadius: 4.ss)]
                                  ),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            _leaveData.containsKey('startDate') ? _leaveData['startDate']! :'start date',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              width: 20.ss,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _leaveData.containsKey('startDate')?() {
                                  showDatePicker(
                                    context: context,
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    currentDate: DateTime.now(),
                                    firstDate: _startDateEnding,
                                    lastDate: _lastDate,
                                  ).then((pickedDate){
                                    if(pickedDate !=null){
                                      setState(() {
                                        _leaveData.putIfAbsent('endDate', ()=>_dateFormat.format(pickedDate));
                                      });
                                    }
                                  });
                                }:()=> Fluttertoast.showToast(msg: 'first select starting date then ending'),
                                child: Container(
                                  padding: EdgeInsets.all(8.ss),
                                  decoration: BoxDecoration(
                                    // color: ColorTheme.LIGHT_RED,
                                    // boxShadow: [BoxShadow(color: ColorTheme.Gray,blurRadius: 4.ss)],
                                    borderRadius:
                                    BorderRadius.circular(8.ss),
                                    border: Border.all(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            _leaveData.containsKey('endDate')?_leaveData['endDate']!:'end date',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        // color: ColorTheme.RED_DEEP1,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),),
                  SizedBox(
                    height: 20.ss,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remarks (in 150 characters)'),
                      SizedBox(
                        height: 5.ss,
                      ),
                      TextField(
                        maxLines: 3,
                        maxLength: 150,
                        keyboardType: TextInputType.text,
                        controller: _remarkController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: "Type cause....",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.ss)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.ss)),
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 14.fss,color: ColorTheme.Gray1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.ss,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50.ss,
                      child: _loading ? const Center(child: CircularProgressIndicator(color: ColorTheme.Blue,)): ElevatedButton(
                        onPressed: applyLeave,
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(ColorTheme.Blue),
                          foregroundColor: const WidgetStatePropertyAll(ColorTheme.Snow_white),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.ss)))
                        ),
                        child: Text('Submit',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Snow_white),),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void applyLeave() async{
    if(_leaveData.isNotEmpty){
      final listOfConnections = await Connectivity().checkConnectivity();
      if(!(listOfConnections.contains(ConnectivityResult.mobile)|| listOfConnections.contains(ConnectivityResult.wifi)||listOfConnections.contains(ConnectivityResult.ethernet))){
        Fluttertoast.showToast(msg: 'please connect to internet');
      }
      if(!_leaveData.containsKey('leaveType')){
        Fluttertoast.showToast(msg: 'please select leave type');
        return;
      }

      if(!_leaveData.containsKey('startDate')){
        Fluttertoast.showToast(msg: 'please select starting date');
        return;
      }
      if(!_leaveData.containsKey('endDate')){
        Fluttertoast.showToast(msg: 'please select ending date');
        return;
      }
      if(_remarkController.text.isEmpty){
        Fluttertoast.showToast(msg: 'Enter  cause of leave..');
        return;
      }

      final pref = await SharedPreferences.getInstance();
      final token = pref.get(Consts.TOKEN);
      if(token == null){
        Fluttertoast.showToast(msg: 'something.. went wrong');
        return;
      }

      setState(() {
        _loading = true;
      });
      try{
        final Uri uri = Uri.parse('https://appadmin.atharvaservices.com/api/Leave/tenantLeave');
        final response = await post(uri,headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
          body: json.encode({
            "leaveType": _leaveData['leaveType'],
            "startDate": _leaveData['startDate'],
            "endDate": _leaveData['endDate'],
            "remark": _remarkController.text,
          })
        );
        if(response.statusCode == 200){
          final rawData = json.decode(response.body);
          if(rawData['status']){
            widget.refresh;
            AwesomeDialog(context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              btnOkOnPress: ()=> Navigator.of(context).pop(),
              title: 'Successfully applied !!',
              desc: 'your responses are recorded and send for approval..',
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
            ).show();
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>_SubmitScreen()));
          }else{
            Fluttertoast.showToast(msg: 'your leave is not submitted ${response.statusCode}');
          }
          setState(() {
            _loading = false;
          });
        }else{
          Fluttertoast.showToast(msg: 'unable to submit, status code ${response.statusCode}');
          setState(() {
            _loading = false;
          });
        }
      }catch(exception,trace){
        print('Exception: ${exception}');
        setState(() {
          _loading = false;
        });
      }
    }else{
      Fluttertoast.showToast(msg: 'please fill the data');
    }
  }
}




// class NewLeaveScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _NewLeaveScreenState();
// }
//
// class _NewLeaveScreenState extends State<NewLeaveScreen> {
//   final ExpansionTileController _controller = ExpansionTileController();
//   Map<String, String> _type = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(14.ss),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                           onTap: () => Navigator.of(context).pop(),
//                           borderRadius: BorderRadius.circular(10.ss),
//                           child: Container(
//                               padding: EdgeInsets.all(8.ss),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.ss),
//                                   color: Colors.black12),
//                               child: const Icon(
//                                 Icons.keyboard_arrow_left_rounded,
//                               ))),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 14.ss),
//                         child: Text(
//                           'New Leave',
//                           style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                               fontSize: 28.fss, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.symmetric(vertical: 12.ss),
//                     decoration: BoxDecoration(
//                         border: Border.all(width: 1.5, color: ColorTheme.Gray1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.ss))),
//                     child: Column(
//                       children: [
//                         ExpansionTile(
//                           title: const Text('Type'),
//                           subtitle: Text(_type.containsKey('type')
//                               ? _type.values.first
//                               : 'select application type'),
//                           leading: Icon(Icons.type_specimen),
//                           shape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10.ss))),
//                           collapsedShape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10.ss))),
//                           showTrailingIcon: false,
//                           controller: _controller,
//                           children: [
//                             InkWell(
//                               onTap: ()=>_toggle('type', 'Sick'),
//                               child: Row(
//                                 children: [
//                                   Checkbox(
//                                     value: _type.containsKey('type')
//                                         ? _type.containsValue('Sick')
//                                         : false,
//                                     activeColor: ColorTheme.Blue,
//                                     onChanged: (value) {_toggle('type', 'Sick');},
//                                   ),
//                                   const Text('Sick'),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: ()=>_toggle('type', 'Casual'),
//                               child: Row(
//                                 children: [
//                                   Checkbox(
//                                       value: _type.containsKey('type')
//                                           ? _type.containsValue('Casual')
//                                           : false,
//                                       activeColor: ColorTheme.Blue,
//                                       onChanged: (value) {_toggle('type', 'Casual');}),
//                                   const Text('Casual'),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         ExpansionTile(
//                           title: const Text('Cause'),
//
//                           subtitle: Text(_type.containsKey('Cause')
//                               ? _type.values.first
//                               : 'Type here...'),
//                           leading: Icon(Icons.edit),
//                           shape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10.ss))),
//                           collapsedShape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10.ss))),
//                           showTrailingIcon: false,
//                           children: [
//                             TextField(
//                               maxLines: 5,  // Allow 5 lines
//                               decoration: InputDecoration(
//                                 hintText: "Type something...",
//                                 labelText: "Your Text",
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
//
//   _toggle(String key, String value) {
//     setState(() {
//       if (_type.containsKey(key)) {
//         // Toggle between Sick and Casual leave
//         if (_type[key] == value) {
//           _type.remove(key); // Remove if same value is selected again
//         } else {
//           _type.update(key, (_) => value); // Update to new leave type
//         }
//       } else {
//         _type.putIfAbsent(key, () => value); // Add the first value
//       }
//       _controller.collapse(); // Collapse the expansion tile after selection
//     });
//   }
//
// }
