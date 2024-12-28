import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';

class MealScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MealScreenStates();
}

class _MealScreenStates extends State<MealScreen> {
  final bool isEnabled = false;
  String tenantName = 'unknown name';

  Future<List<Map<String, dynamic>>>? _getMealsData() async {
    var uri = Uri.parse('https://appadmin.atharvaservices.com/api/Meal/tenantMeal');
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString(Consts.TOKEN) ?? '';

    if (token.isEmpty) {
      print('Token is empty');
      return [];
    }

   try{
     var response = await get(uri,headers: {
       Consts.AUTHORIZATION: 'Bearer $token', // Ensure 'Bearer ' is prefixed to the token
       Consts.CONTENT_TYPE: 'application/json',
     });

     print('Status Code: ${response.statusCode}');
     print('Response Body: ${response.body}');

     if(response.statusCode == 200){
       tenantName = pref.getString(Consts.TENANT_NAME) ?? 'unknown name';
       Map<String, dynamic> decodedJson = json.decode(response.body);
       List<Map<String, dynamic>> mealsList =
       List<Map<String, dynamic>>.from(decodedJson['meal']);
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
                              builder: (context) => _VisitScreen(mealsDetails: snapshot.data![0],tenantName: tenantName,)));
                        },
                        title: 'Breakfast',
                        subTitle: snapshot.hasData ? 'get your breakfast between ${snapshot.data![0]['mealStartTime']} to ${snapshot.data![0]['mealEndtime']}' : '',
                        loading: snapshot.hasData,
                      ),
                      SizedBox(
                        height: 18.ss,
                      ),
                      _MealTile(
                        onClick: () {},
                        title: 'Lunch',
                        subTitle: snapshot.hasData ? 'get your lunch between ${snapshot.data![1]['mealStartTime']} to ${snapshot.data![1]['mealEndtime']}' : '',
                        enabled: false,
                        loading: snapshot.hasData,
                      ),
                      SizedBox(
                        height: 18.ss,
                      ),
                      _MealTile(
                        onClick: () {},
                        title: 'Dinner',
                        subTitle: snapshot.hasData ? 'get your dinner between ${snapshot.data![2]['mealStartTime']} to ${snapshot.data![2]['mealEndtime']}' : '',
                        enabled: false,
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
                // RichText(
                //   text: TextSpan(
                //     text: title,
                //     style: Theme.of(context).textTheme.bodyMedium,
                //     children: [
                //       TextSpan(text: '\n'),
                //       TextSpan(
                //         text: subTitle,
                //         style: Theme.of(context).textTheme.bodySmall,
                //       ),
                //     ],
                //   ),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 3,
                // ),
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
                  child: const CircularProgressIndicator(
                    color: ColorTheme.Blue,
                    strokeWidth: 2,
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
                    opacity: 0.5,
                    child: QrImageView(
                      data: mealsDetails.toString(),
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  Transform.rotate(angle: -0.8,child: Image.asset('assets/icons/taken_txt.webp',width: 270,height: 270,color: Colors.red,))
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








// class _FoodShowCase extends StatelessWidget{
//   final List<String> picture;
//   final String headline;
//   final String dishName;
//   final String description;
//   final VoidCallback? onTap;
//
//   const _FoodShowCase({required this.picture,this.headline ='',this.dishName = '',this.description ='',this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 10.ss, top: 20.ss),
//               child: RichText(
//                   text: TextSpan(
//                     text: headline,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   )),
//             ),
//             SizedBox(
//               height: 10.ss,
//             ),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: 220.ss),
//               child: ListView.builder(
//                 scrollDirection:
//                 Axis.horizontal, // Makes the ListView horizontal
//                 itemCount: picture.length, // Number of items
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return Container(
//                       width: 180, // Width for each item
//                       margin: EdgeInsets.all(8.ss),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius:
//                             BorderRadius.circular(10.ss),
//                             child: Image.asset(
//                               picture[index],
//                               height: 150,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4.ss,
//                           ),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         dishName,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium!
//                                             .copyWith(fontSize: 11.fss),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                       ),
//                                       Text(
//                                         description,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodySmall!
//                                             .copyWith(
//                                             fontSize: 11.fss,
//                                             fontWeight:
//                                             FontWeight.w500),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 2,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 InkWell(
//                                     onTap: onTap,
//                                     borderRadius:
//                                     BorderRadius.circular(10),
//                                     child: Padding(
//                                         padding: EdgeInsets.all(10),
//                                         child: ImageIcon(
//                                           AssetImage(
//                                               'assets/icons/heart_icon.webp'),
//                                           size: 20.ss,
//                                         )))
//                               ],
//                             ),
//                           ),
//                         ],
//                       ));
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
//
// }
