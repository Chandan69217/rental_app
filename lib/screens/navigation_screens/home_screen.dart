import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rental_app/custom_paints/circular_curve.dart';
import 'package:rental_app/screens/menu/leave_screen.dart';
import 'package:rental_app/screens/menu/meal_screen.dart';
import 'package:rental_app/screens/menu/notification_screen.dart';
import 'package:rental_app/screens/navigation_screens/attendance_screen.dart';
import 'package:rental_app/screens/navigation_screens/fee_screen.dart';
import 'package:rental_app/screens/navigation_screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';
import '../../utilities/color_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenStates();
}

class _HomeScreenStates extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: init(), builder: (context,snapshot){
      return Scaffold(
            appBar: AppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 16.fss,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/location_icon.webp',
                        width: 20.ss,
                        height: 20.ss,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 5.ss,
                      ),
                      Text(
                        'Patna, Bihar',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 16.fss,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16.ss),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(20.ss),
                      overlayColor:
                      WidgetStatePropertyAll(ColorTheme.Blue.withOpacity(0.1)),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(8.ss),
                        child: Badge(
                          child: Icon(Icons.notifications_none_rounded),
                          label: Text('2'),
                        ),
                      )),
                )
              ],
            ),
            body:  SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.ss),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CardDetails(snapshot: snapshot.hasData ? snapshot.data!:{}),
                      SizedBox(
                        height: 15.ss,
                      ),
                      _PaymentCard(),
                      _Menus()
                    ],
                  ),
                ),
              ),
      );

    });
  }

  Future<Map<String, dynamic>> init() async {

    var pref = await SharedPreferences.getInstance();

    var cachedData = pref.getString('tenant_data');
    fetchDataFromNetwork(cachedData);
    if (cachedData != null && cachedData.isNotEmpty) {
      print('Using cached data');
      return json.decode(cachedData); // Return the cached data
    }
    return Future.error('No Data Available !');
  }

  void fetchDataFromNetwork(String? cachedData) async{
    var uri = Uri.parse('https://appadmin.atharvaservices.com/api/Tenant/tenantProfile');
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString(Consts.TOKEN) ?? '';

    if (token.isEmpty) {
      print('Token is empty');
      return Future.error('User token is empty');
    }
    try {
      // Fetch data from the network if not cached
      var response = await get(uri, headers: {
        Consts.AUTHORIZATION: 'Bearer $token',
        Consts.CONTENT_TYPE: 'application/json'
      });

      if (response.statusCode == 200) {
        var profileData = Map.from(json.decode(response.body)['profile']);
        print("Received data from network: $profileData");

        if (profileData.containsKey('tenant')) {
          var tenantData = List.from(profileData['tenant']);
          if (tenantData.isNotEmpty) {
            // Cache the data for future use
            if(cachedData!=null && cachedData.isNotEmpty){
              if(json.encode(cachedData) != json.encode(tenantData[0])){
                pref.setString('tenant_data', json.encode(tenantData[0]));
                setState(() {
                });
              }
            }else{
              setState(() {
                pref.setString('tenant_data', json.encode(tenantData[0]));
              });
            }
          //  return tenantData[0]; // Return the fresh data
          } else {
            return Future.error('Tenant data is not present');
          }
        } else {
          return Future.error("Tenant data is missing in the response.");
        }
      } else {
        return Future.error('Failed to fetch data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during network request: $e');
      return Future.error('Error occurred during network request: $e');
    }
  }

}

class _MenuButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onTap;
  const _MenuButton(
      {super.key, required this.label, required this.iconPath, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.all(Radius.circular(50.ss)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: ColorTheme.Blue,
              radius: 25,
              child: Image.asset(
                iconPath,
                color: ColorTheme.Snow_white,
                width: 30.ss,
                height: 30.ss,
              ),
            ),
          ),
        ),
        // const SizedBox(height: 3,),
        Expanded(
            child: Text(
          label,
          style:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.fss),
        )),
      ],
    );
  }
}

class _CardDetails extends StatelessWidget {
  final Map<String, dynamic> snapshot;
  const _CardDetails({required this.snapshot});

  @override
  Widget build(BuildContext context) {
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
        color: ColorTheme.Blue.withOpacity(0.95),
      ),
      child: CustomPaint(
        painter: CircularWave(
          waveColor: ColorTheme.Snow_white,
          waveHeight: 60,
          waveLength: 550,
          phaseShift: 1,
        ),
        child: Padding(
          padding: EdgeInsets.all(24.ss),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.isNotEmpty
                          ? 'Hi, ${snapshot[Consts.TENANT_NAME]}'
                          : 'N/A',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: ColorTheme.Snow_white),
                    ),
                    Text(
                      snapshot.isNotEmpty
                          ? 'Building: ${snapshot['tenantBuildingNumber']} | Room No: ${snapshot[Consts.ROOM_NO]}'
                          : 'N/A',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: ColorTheme.Ghost_White),
                    ),
                    SizedBox(
                      height: 5.ss,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/phone_outline.webp',
                          width: 17.ss,
                          height: 17.ss,
                          color: ColorTheme.Snow_white,
                        ),
                        SizedBox(
                          width: 5.ss,
                        ),
                        Text(
                          snapshot.isNotEmpty
                              ? snapshot['tenantContactNumber']
                              : 'N/A',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: ColorTheme.Ghost_White),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.ss,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/id-card-icon.webp',
                          width: 20.ss,
                          height: 20.ss,
                          color: ColorTheme.Snow_white,
                        ),
                        SizedBox(
                          width: 5.ss,
                        ),
                        Text(
                          snapshot.isNotEmpty
                              ? '${snapshot['tenantIDProofNumber']}'
                              : 'N/A',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: ColorTheme.Ghost_White),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50.ss),
                child: Image.asset(
                  'assets/hotels_images/profile_pic.webp',
                  fit: BoxFit.cover,
                  width: 60.ss,
                  height: 60.ss,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: 24.ss, vertical: 10.ss),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Due Amount: ',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(
                  color: ColorTheme.Snow_white,
                  fontSize: 10.fss)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/rupee-icon.webp',
                  width: 12.ss,
                  height: 10.ss,
                  fit: BoxFit.cover,
                  color: ColorTheme.Snow_white,
                ),
                Text(
                  '2300.00',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                      color: ColorTheme.Snow_white,
                      fontSize: 10.fss),
                )
              ],
            ),
          ),
          SizedBox(
            height: 35.ss,
            child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Pay now',
                  style:
                  TextStyle(color: Colors.deepPurple),
                )),
          )
        ],
      ),
    );
  }
}

class _Menus extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 18.ss),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14.ss),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.ss),
            child: const Text(
              'Menu',
            ),
          ),
          SizedBox(
            height: 8.ss,
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 14.ss,
            crossAxisSpacing: 12.ss,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 4.ss),
            children: [
              _MenuButton(
                iconPath: 'assets/icons/profile.webp',
                label: 'Profile',
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      enableBack: true,
                    ))),
              ),
              _MenuButton(
                iconPath: 'assets/icons/food.webp',
                label: 'Meal',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            MealScreen())),
              ),
              _MenuButton(
                iconPath:
                'assets/icons/attendant-list.webp',
                label: 'Attendance',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AttendanceScreen(
                              enableBack: true,
                            ))),
              ),
              _MenuButton(
                iconPath: 'assets/icons/notice.webp',
                label: 'Notice',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen())),
              ),
              _MenuButton(
                iconPath: 'assets/icons/fee.webp',
                label: 'Fee',
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => FeeScreen(
                      enableBack: true,
                    ))),
              ),
              _MenuButton(
                iconPath: 'assets/icons/reminder.webp',
                label: 'Reminder',
                onTap: () {},
              ),
              _MenuButton(
                iconPath: 'assets/icons/support.webp',
                label: 'Helpdesk',
                onTap: () {},
              ),
              _MenuButton(
                iconPath: 'assets/icons/leave.webp',
                label: 'Leave',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LeaveScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _HomeScreenStates();
// }
//
// class _HomeScreenStates extends State<HomeScreen> {
//   static final List<String> _hotelsImages = [
//     'assets/hotels_images/1.jpg',
//     'assets/hotels_images/2.jpg',
//     'assets/hotels_images/3.jpg',
//     'assets/hotels_images/4.jpg',
//     'assets/hotels_images/5.jpg',
//     'assets/hotels_images/6.jpg',
//     'assets/hotels_images/7.jpg'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Home',
//               style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                   fontSize: 16.fss,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400),
//             ),
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/icons/location_icon.webp',
//                   width: 20.ss,
//                   height: 20.ss,
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(
//                   width: 5.ss,
//                 ),
//                 Text(
//                   'Patna, Bihar',
//                   style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                       fontSize: 16.fss,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ],
//             )
//           ],
//         ),
//         actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.ss),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 elevation: 4.ss,
//                 child: TextSelectionTheme(
//                   data: const TextSelectionThemeData(
//                       selectionHandleColor: ColorTheme.Blue),
//                   child: TextField(
//                     cursorColor: ColorTheme.Blue,
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(8.ss),
//                       border: InputBorder.none,
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8.ss)),
//                           borderSide: BorderSide.none),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8.ss)),
//                           borderSide: BorderSide.none),
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: ColorTheme.Gray,
//                       ),
//                       hintText: 'Search PG or Hotels',
//                       hintStyle:
//                           TextStyle(fontSize: 11.fss, color: ColorTheme.Gray),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                   padding:
//                       EdgeInsets.only(top: 12.ss, bottom: 12.ss, left: 12.ss),
//                   child: Text('Nearby Your Location',
//                       style: Theme.of(context).textTheme.bodyMedium)),
//               ConstrainedBox(
//                   constraints: BoxConstraints(maxHeight: 250.ss),
//                   child: ListView.builder(
//                     scrollDirection:
//                         Axis.horizontal, // Makes the ListView horizontal
//                     itemCount: 7, // Number of items
//                     itemBuilder: (context, index) {
//                       return Container(
//                           width: 220, // Width for each item
//                           margin: EdgeInsets.all(8),
//                           child: Column(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10.ss),
//                                 child: Image.asset(
//                                   _hotelsImages[index],
//                                   height: 180,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 4.ss,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Sri Adi Chuchanagiri',
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium!
//                                               .copyWith(fontSize: 11.fss),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                         Text(
//                                           'mahalakshmipuram Layout,Patna',
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall!
//                                               .copyWith(
//                                                   fontSize: 11.fss,
//                                                   fontWeight: FontWeight.w500),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                         RichText(
//                                             text: TextSpan(
//                                                 text: 'RS.',
//                                                 children: [
//                                                   TextSpan(text: '8000'),
//                                                   TextSpan(text: '/ Per Month')
//                                                 ],
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium!
//                                                     .copyWith(fontSize: 11.fss,)),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                       onTap: () {},
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Padding(
//                                           padding: EdgeInsets.all(10),
//                                           child: ImageIcon(
//                                             AssetImage(
//                                                 'assets/icons/heart_icon.webp'),
//                                             size: 20.ss,
//                                           )))
//                                 ],
//                               ),
//                             ],
//                           ));
//                     },
//                   )),
//             Padding(
//               padding: EdgeInsets.only(top: 2.ss, bottom: 12.ss, left: 12.ss),
//               child: Text('Top Rated Hostels',
//                   style: Theme.of(context).textTheme.bodyMedium),
//             ),
//
//               ConstrainedBox(
//                   constraints: BoxConstraints(maxHeight: 250.ss),
//                   child: ListView.builder(
//                     scrollDirection:
//                     Axis.horizontal, // Makes the ListView horizontal
//                     itemCount: 7, // Number of items
//                     itemBuilder: (context, index) {
//                       return Container(
//                           width: 160, // Width for each item
//                           margin: EdgeInsets.all(8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10.ss),
//                                 child: Image.asset(
//                                   _hotelsImages[index],
//                                   height: 200,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 4.ss,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Jagajothi Boys Hostel Banglore',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(fontSize: 11.fss),
//                                 ),
//                               ),
//                             ],
//                           ));
//                     },
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
