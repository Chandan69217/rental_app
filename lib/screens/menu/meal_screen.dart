import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class MealScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MealScreenStates();
}

class _MealScreenStates extends State<MealScreen> {
  static final List<String> _foodsImages = [
    'assets/foods/fried_rice.webp',
    'assets/foods/chicken_biryani.webp',
    'assets/foods/itli.webp',
    'assets/foods/maggie.webp',
    'assets/foods/nan_manchuriyan.webp',
    'assets/foods/sambhar_bada.webp',
    'assets/foods/veg_biryani.webp'
  ];

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

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.ss, vertical: 24),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.ss),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.ss),
                    color: ColorTheme.Ghost_White,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 8.ss,
                          spreadRadius: 0)
                    ]),
                child: TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionHandleColor: ColorTheme.Blue),
                  child: TextField(
                    cursorColor: ColorTheme.Blue,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.ss),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.ss)),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.ss)),
                          borderSide: BorderSide.none),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 12.ss),
                        child: const Icon(
                          Icons.search,
                          color: ColorTheme.Gray,
                        ),
                      ),
                      hintText: 'Search your meal',
                      hintStyle:
                      TextStyle(fontSize: 11.fss, color: ColorTheme.Gray),
                    ),
                  ),
                ),
              ),
            ),
            _FoodShowCase(picture: _foodsImages,headline: 'Recommended',dishName: 'Veg Biryani',description: 'Veg Biryani is an aromatic rice dish made with basmati rice, mix veggies, herbs & biryani spices.',onTap: (){},),
            Padding(
              padding: EdgeInsets.only(bottom: 10.ss),
              child: RichText(
                  text: TextSpan(
                    text: "Today's Meals",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _FoodShowCase(picture: _foodsImages,headline: 'Breakfast',dishName: 'Veg Biryani',description: 'Veg Biryani is an aromatic rice dish made with basmati rice, mix veggies, herbs & biryani spices.',onTap: (){}),
                    _FoodShowCase(picture: _foodsImages,headline: 'Lunch',dishName: 'Veg Biryani',description: 'Veg Biryani is an aromatic rice dish made with basmati rice, mix veggies, herbs & biryani spices.',onTap: (){}),
                    _FoodShowCase(picture: _foodsImages,headline: 'Dinner',dishName: 'Veg Biryani',description: 'Veg Biryani is an aromatic rice dish made with basmati rice, mix veggies, herbs & biryani spices.',onTap: (){}),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



class _FoodShowCase extends StatelessWidget{
  final List<String> picture;
  final String headline;
  final String dishName;
  final String description;
  final VoidCallback? onTap;

  const _FoodShowCase({required this.picture,this.headline ='',this.dishName = '',this.description ='',this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.ss, top: 20.ss),
              child: RichText(
                  text: TextSpan(
                    text: headline,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
            SizedBox(
              height: 10.ss,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 220.ss),
              child: ListView.builder(
                scrollDirection:
                Axis.horizontal, // Makes the ListView horizontal
                itemCount: picture.length, // Number of items
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                      width: 180, // Width for each item
                      margin: EdgeInsets.all(8.ss),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10.ss),
                            child: Image.asset(
                              picture[index],
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 4.ss,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dishName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 11.fss),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                            fontSize: 11.fss,
                                            fontWeight:
                                            FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: onTap,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/icons/heart_icon.webp'),
                                          size: 20.ss,
                                        )))
                              ],
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
          ],
        ));
  }

}