import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class BookingScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  BookingScreen({this.onBackPressed});

  @override
  State<StatefulWidget> createState() => _BookingScreenStates();
}

class _BookingScreenStates extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hotels',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 16.fss,
              color: Colors.black,
              fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: widget.onBackPressed,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: ColorTheme.Blue,
              size: 18.ss,
            )),
      ),
      body: ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _ListTile(
              image: 'assets/hotels_images/1.jpg',
              title: 'Jmj Boys Hostels',
              rating: 3.5,
              desc: 'Kakaguda Karkhana',
            );
          }),
    );
  }
}

class _ListTile extends StatelessWidget {
  final String image;
  final String title;
  final double rating;
  final String desc;
  final VoidCallback? onCall;
  final VoidCallback? onVisting;

  _ListTile(
      {required this.image,
      required this.title,
      required this.rating,
      required this.desc,
      this.onCall,
      this.onVisting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.ss),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.ss),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: 100.ss,
                    height: 110.ss,
                  ))),
          SizedBox(
            width: 15.ss,
          ),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  _Rating(rating: rating),
                  Text(
                    desc,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14.ss),
                  ),
                  SizedBox(
                    height: 15.ss,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 35.ss,
                        child: ElevatedButton.icon(
                          onPressed: onCall,
                          label: Text('Call'),
                          icon: Image.asset(
                            'assets/icons/phone_outline.webp',
                            width: 15.ss,
                            height: 15.ss,
                            color: ColorTheme.Snow_white,
                          ),
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.ss)))),
                              backgroundColor:
                                  WidgetStatePropertyAll(ColorTheme.Blue),
                              foregroundColor: WidgetStatePropertyAll(
                                  ColorTheme.Snow_white)),
                        ),
                      )),
                      SizedBox(
                        width: 8.ss,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 35.ss,
                        child: ElevatedButton(
                          onPressed: onVisting,
                          child: Text('Visting'),
                          style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(ColorTheme.Blue),
                            foregroundColor: const WidgetStatePropertyAll(
                                ColorTheme.Snow_white),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.ss))),
                          ),
                        ),
                      )),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}


class _Rating extends StatelessWidget {
  final double rating;

  _Rating({required this.rating});

  @override
  Widget build(BuildContext context) {
    // Calculate the number of full stars and remaining stars
    int fullStars = rating.floor(); // Full stars
    bool hasHalfStar = (rating - fullStars) >= 0.5; // Check for a half star
    int totalStars = 5;

    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1), // Display rating with 1 decimal place
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14.ss),
        ),
        SizedBox(width: 5.ss,),
        // Loop to generate stars
        Row(
          children: List.generate(totalStars, (index) {
            if (index < fullStars) {
              // Full star
              return Padding(
                padding: EdgeInsets.only(left: 2.ss,right: 2.ss),
                child: Image.asset(
                  'assets/icons/colored_star_icon.webp',
                  width: 10.ss,
                  height: 10.ss,
                ),
              );
            } else if (index == fullStars && hasHalfStar) {
              // Half star
              return Padding(
                padding: EdgeInsets.only(left: 2.ss,right: 2.ss),
                child: Image.asset(
                  'assets/icons/half_star_icon.webp', // Provide a half-star asset
                  width: 10.ss,
                  height: 10.ss,
                ),
              );
            } else {
              // Empty star
              return Padding(
                padding: EdgeInsets.only(left: 2.ss,right: 2.ss),
                child: Image.asset(
                  'assets/icons/uncolored_star_icon.webp',
                  width: 10.ss,
                  height: 10.ss,
                ),
              );
            }
          }),
        ),
        SizedBox(width: 3.ss),
        Text(
          'Rating',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 14.ss),
        ),
      ],
    );
  }
}
