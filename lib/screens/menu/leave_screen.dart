import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class LeaveScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen>{

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
          IconButton(onPressed: (){}, icon: const Icon(Icons.add))
        ],
        foregroundColor: ColorTheme.Snow_white,
      ),
      body: DefaultTabController(
        length: 3,
        animationDuration: Duration(milliseconds: 100,),
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
              child: TabBarView(children: [
                _ListOfLeaves(),
                _ListOfLeaves(),
                _ListOfLeaves(),
              ]),
            )
          ],
        )
      )
    );
  }
}


class _ListOfLeaves extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListOfLeavesState();
}

class _ListOfLeavesState extends State<_ListOfLeaves>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context,index){
        return Container(
          padding: EdgeInsets.all(14.ss),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.ss,bottom:2,top: 8.ss),
                child: Text('December 2025',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Gray1),),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal:  12.ss,vertical: 10.ss),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.ss)),
                  border: Border.all(width: 1.7.ss,color: ColorTheme.Gray1)
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Half Day Application',style: TextStyle(color: ColorTheme.Gray1),),
                        SizedBox(height: 3.ss,),
                        Text('Wed, 16 Dec',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.BLACK,fontSize: 22.ss,),),
                        SizedBox(height: 3.ss,),
                        Text('Casual',style: TextStyle(color: ColorTheme.Orange_DEEP1),)
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
                            color: ColorTheme.Orange_LIGHT,
                            borderRadius: BorderRadius.all(Radius.circular(8.ss))
                          ),
                          padding: EdgeInsets.symmetric(vertical:  8.ss,horizontal: 14.ss),
                          child: Text('Awaiting',style: TextStyle(color: ColorTheme.Orange_DEEP),),
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
              )
            ],
          ),
        );
      },
    );
  }

}