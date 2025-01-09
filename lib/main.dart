import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/model/consts.dart';
import 'package:rental_app/screens/authentication/welcome_screen.dart';
import 'package:rental_app/screens/dashboard.dart';
import 'package:rental_app/utilities/color_theme.dart';
import 'package:rental_app/utilities/theme_data.dart';
import 'package:rental_app/widgets/cust_circular_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool?> checkLoginStatus() async{
    final _prefs = await SharedPreferences.getInstance();
    final bool? _islogin = _prefs.getBool(Consts.IS_LOGIN);
    return _islogin ?? false;
  }

  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return SizingBuilder(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        home: FutureBuilder(builder: (context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data!){
              return Dashboard();
            }else{
              return const WelcomeScreen();
            }
          }else{
            return Scaffold(body: CustCircularProgress(color: ColorTheme.Blue,));
          }
        }, future: checkLoginStatus(),)
      ),
    );
  }
}


