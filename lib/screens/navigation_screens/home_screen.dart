import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../utilities/color_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenStates();
}

class _HomeScreenStates extends State<HomeScreen> {
  static final List<String> _hotelsImages = [
    'assets/hotels_images/1.jpg',
    'assets/hotels_images/2.jpg',
    'assets/hotels_images/3.jpg',
    'assets/hotels_images/4.jpg',
    'assets/hotels_images/5.jpg',
    'assets/hotels_images/6.jpg',
    'assets/hotels_images/7.jpg'
  ];

  @override
  Widget build(BuildContext context) {
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.ss),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4.ss,
                child: TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: ColorTheme.Blue),
                  child: TextField(
                    cursorColor: ColorTheme.Blue,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.ss),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.ss)),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.ss)),
                          borderSide: BorderSide.none),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: ColorTheme.Gray,
                      ),
                      hintText: 'Search PG or Hotels',
                      hintStyle:
                          TextStyle(fontSize: 11.fss, color: ColorTheme.Gray),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(top: 12.ss, bottom: 12.ss, left: 12.ss),
                  child: Text('Nearby Your Location',
                      style: Theme.of(context).textTheme.bodyMedium)),
              ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 250.ss),
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal, // Makes the ListView horizontal
                    itemCount: 7, // Number of items
                    itemBuilder: (context, index) {
                      return Container(
                          width: 220, // Width for each item
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.ss),
                                child: Image.asset(
                                  _hotelsImages[index],
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 4.ss,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sri Adi Chuchanagiri',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(fontSize: 11.fss),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          'mahalakshmipuram Layout,Patna',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 11.fss,
                                                  fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                text: 'RS.',
                                                children: [
                                                  TextSpan(text: '8000'),
                                                  TextSpan(text: '/ Per Month')
                                                ],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(fontSize: 11.fss,)),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ImageIcon(
                                            AssetImage(
                                                'assets/icons/heart_icon.webp'),
                                            size: 20.ss,
                                          )))
                                ],
                              ),
                            ],
                          ));
                    },
                  )),
            Padding(
              padding: EdgeInsets.only(top: 2.ss, bottom: 12.ss, left: 12.ss),
              child: Text('Top Rated Hostels',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),

              ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 250.ss),
                  child: ListView.builder(
                    scrollDirection:
                    Axis.horizontal, // Makes the ListView horizontal
                    itemCount: 7, // Number of items
                    itemBuilder: (context, index) {
                      return Container(
                          width: 160, // Width for each item
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.ss),
                                child: Image.asset(
                                  _hotelsImages[index],
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 4.ss,
                              ),
                              Expanded(
                                child: Text(
                                  'Jagajothi Boys Hostel Banglore',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 11.fss),
                                ),
                              ),
                            ],
                          ));
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
