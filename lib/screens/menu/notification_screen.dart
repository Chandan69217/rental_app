import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../utilities/color_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreenStates();
}

class _NotificationScreenStates extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.Blue,
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        actions: [
          PopupMenuButton<int>(
              padding: EdgeInsets.all(10.ss),
              style: const ButtonStyle(
                shadowColor: WidgetStatePropertyAll(Colors.black12),
              ),
              color: ColorTheme.Ghost_White,
              iconColor: ColorTheme.Snow_white,
              itemBuilder: (context) => const[
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.mark_chat_read_outlined),
                      title: Text('Mark as read'),
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    )),
                  ])
        ],
        title: Text(
          'Notices',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: ColorTheme.Snow_white, fontSize: 28.fss),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: ColorTheme.Snow_white,
            )),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 14,
            child: Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                padding: EdgeInsets.only(left: 24.ss, right: 24.ss, top: 35.ss),
                decoration: BoxDecoration(
                    color: ColorTheme.Ghost_White,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -14.ss),
                        blurRadius: 12.ss,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.ss),
                        topRight: Radius.circular(35.ss))),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.ss),
                        color: ColorTheme.Ghost_White,
                        boxShadow: [BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 8.ss,
                          spreadRadius: 0
                        )]
                      ),
                      child: TextSelectionTheme(
                        data: const TextSelectionThemeData(
                            selectionHandleColor: ColorTheme.Blue),
                        child: TextField(
                          cursorColor: ColorTheme.Blue,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal:18.ss),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.ss)),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.ss)),
                                borderSide: BorderSide.none),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 12.ss),
                              child: const Icon(
                                Icons.search,
                                color: ColorTheme.Gray,
                              ),
                            ),
                            hintText: 'Search here',
                            hintStyle: TextStyle(
                                fontSize: 11.fss, color: ColorTheme.Gray),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.ss,),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: (){},
                              leading: CircleAvatar(backgroundImage: AssetImage('assets/icons/stickers/bulb.webp'),backgroundColor: ColorTheme.Pole_Blue,),
                              title: Text('Notice for electricity',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16.fss,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1,),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('from 2 Pm to 8 Pm electricity is not available because of heavy load.',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600,color: ColorTheme.Gray),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                  SizedBox(height: 5.ss,),
                                  Text('August 06,2024 - 12:04 PM',style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 8.fss,fontWeight: FontWeight.w600,color: ColorTheme.Gray),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                ],
                              ),
                              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
                            );
                          }),
                    )
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
