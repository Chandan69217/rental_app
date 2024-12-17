import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../utilities/color_theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenStates();
}

class _ProfileScreenStates extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.Blue,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                'Profile',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: ColorTheme.Snow_white, fontSize: 28.fss),
              ))),
          Expanded(
            flex: 7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorTheme.Snow_white,
                  boxShadow: [
                    BoxShadow(
                        color: ColorTheme.Gray,
                        blurRadius: 40.ss,
                        spreadRadius: 15.ss,
                        offset: Offset(0, 8.ss))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.ss),
                      topRight: Radius.circular(40.ss))),
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50.ss, bottom: 2.ss),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/hotels_images/profile_pic.webp'),
                          radius: 60.ss,
                        ),
                      ),
                      Text(
                        'Chandan Sharma',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.ss,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.ss),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _profileButtons(iconPath: 'assets/icons/user_profile.webp', label: 'Edit Profile',onTap: (){},),
                            _profileButtons(iconPath: 'assets/icons/payments.webp', label: 'Payments',onTap: (){},),
                            Padding(padding: EdgeInsets.symmetric(vertical: 8.ss),
                            child: Text('Settings',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorTheme.Blue,fontWeight: FontWeight.w600),)),
                            _profileButtons(iconPath: 'assets/icons/notification-bell.webp', label: 'Notifications',onTap: (){},),
                            _profileButtons(iconPath: 'assets/icons/terms-and-conditions.webp', label: 'Terms & Conditions',onTap: (){},),
                            _profileButtons(iconPath: 'assets/icons/privacy-policy.webp', label: 'Privacy Police',onTap: (){},),
                            ListTile(
                              onTap: (){},
                              title: Text('Log Out',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorTheme.Blue,fontSize: 14.fss,fontWeight: FontWeight.w500),),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.ss),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}


class _profileButtons extends StatelessWidget{
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  _profileButtons({super.key,required this.iconPath,required this.label,this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(iconPath,width: 35.ss,height: 35.ss,fit: BoxFit.cover,),
      title: Text(label,style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black,fontSize: 14.fss,fontWeight: FontWeight.w500),),
      trailing: Icon(Icons.arrow_forward_ios_rounded,color: ColorTheme.Gray,size: 20.ss,),
      contentPadding:
      EdgeInsets.zero,
    );
  }

}
