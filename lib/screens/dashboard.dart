import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/screens/navigation_screens/attendance_screen.dart';
import 'package:rental_app/screens/navigation_screens/fee_screen.dart';
import 'package:rental_app/screens/navigation_screens/home_screen.dart';
import 'package:rental_app/screens/navigation_screens/profile_screen.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:sizing/sizing.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardStates();
}

class _DashboardStates extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([HomeScreen(),AttendanceScreen(onBackPressed: _onBackPressed ,),FeeScreen(onBackPressed: _onBackPressed,),ProfileScreen(onBackPressed: _onBackPressed,)]);
  }
  
  _onBackPressed(){
    setState(() {
      _currentIndex--;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorTheme.Blue,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.fss,
        unselectedFontSize: 12.fss,
        selectedItemColor: ColorTheme.Ghost_White,
        unselectedItemColor: ColorTheme.Gray,
        onTap: (selectedIndex){
          setState(() {
            _currentIndex = selectedIndex;
          });
        },
        currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Image.asset(
          'assets/icons/home_outline.webp',
          width: 20.ss,
          height: 20.ss,
          fit: BoxFit.cover,
              color: ColorTheme.Gray,
        ),activeIcon: Image.asset(
          'assets/icons/home_filled.webp',
          width: 20.ss,
          height: 20.ss,
          fit: BoxFit.cover,
          color: ColorTheme.Ghost_White,
        ),
        label: 'Home',),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/attendance_outlined.webp',
              width: 22.ss,
              height: 22.ss,
              fit: BoxFit.cover,
              color: ColorTheme.Gray,
            ),activeIcon: Image.asset(
          'assets/icons/attendance_filled.webp',
          width: 22.ss,
          height: 22.ss,
          fit: BoxFit.cover,
          color: ColorTheme.Ghost_White,
        ),
        label: 'Attendance'),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/wallet_outlined.webp',
              width: 24.ss,
              height: 24.ss,
              fit: BoxFit.cover,
              color: ColorTheme.Gray,
            ),activeIcon: Image.asset(
          'assets/icons/wallet_filled.webp',
          width: 24.ss,
          height: 24.ss,
          fit: BoxFit.cover,
          color: ColorTheme.Ghost_White,
        ),
        label: 'Fees'),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile_outline.webp',
              width: 21.ss,
              height: 21.ss,
              fit: BoxFit.cover,
              color: ColorTheme.Gray,
            ),activeIcon: Image.asset(
          'assets/icons/profile_filled.webp',
          width: 21.ss,
          height: 21.ss,
          fit: BoxFit.cover,
          color: ColorTheme.Ghost_White,
        ),
        label: 'Profile'),
      ]),
    );
  }
}
