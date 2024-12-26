import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rental_app/model/meals.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class MealScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MealScreenStates();
}

class _MealScreenStates extends State<MealScreen> {
  final bool isEnabled = false;

  Future<List<Map<String, dynamic>>> _getMealsData() async {
    // Simulate a delay (e.g., fetching data from a remote server)
    await Future.delayed(Duration(seconds: 3));

    // JSON string
    String mealsJsonString = '''
  {
    "meals": [
      {
        "id": 1,
        "name": "Breakfast",
        "time": "08:00 AM",
        "verificationCode": "ABC123",
        "status": "active"
      },
      {
        "id": 2,
        "name": "Lunch",
        "time": "01:00 PM",
        "verificationCode": "DEF456",
        "status": "active"
      },
      {
        "id": 3,
        "name": "Dinner",
        "time": "07:00 PM",
        "verificationCode": "GHI789",
        "status": "inactive"
      }
    ]
  }
  ''';

    // Decoding the JSON
    Map<String, dynamic> decodedJson = json.decode(mealsJsonString);

    // Accessing the 'meals' array
    List<Map<String, dynamic>> mealsList =
        List<Map<String, dynamic>>.from(decodedJson['meals']);

    // Returning the meals data
    return mealsList;
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
                            builder: (context) => _VisitScreen()));
                      },
                      title: 'Breakfast',
                      subTitle:
                          'get your breakfast between 8:00 AM to 11:00 AM',
                      loading: snapshot.hasData,
                    ),
                    SizedBox(
                      height: 18.ss,
                    ),
                    _MealTile(
                      onClick: () {},
                      title: 'Lunch',
                      subTitle: 'get your lunch between 1:00 PM to 2:30 PM',
                      enabled: false,
                      loading: snapshot.hasData,
                    ),
                    SizedBox(
                      height: 18.ss,
                    ),
                    _MealTile(
                      onClick: () {},
                      title: 'Dinner',
                      subTitle: 'get your dinner between 8:00 PM to 10:00 PM',
                      enabled: false,
                      loading: snapshot.hasData,
                    ),
                  ],
                ),
              );
            }));
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakfast'),
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
                      data: 'Hello World!',
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
                        text: 'Chandan Sharma',
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
