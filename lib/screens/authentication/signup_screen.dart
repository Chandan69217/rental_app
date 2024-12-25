import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:rental_app/screens/authentication/login_screen.dart';
import 'package:rental_app/widgets/custom_button.dart';
import 'package:rental_app/widgets/custom_textfield.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';
import '../../utilities/color_theme.dart';
import '../../widgets/circular_icon_button.dart';
import '../dashboard.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenStates();
}

class _SignupScreenStates extends State<SignupScreen> with WidgetsBindingObserver {
  final TextEditingController _passwordTxtController = TextEditingController();
  final TextEditingController _nameTxtController = TextEditingController();
  final TextEditingController _mobileTxtController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _passwordTxtController.addListener((){
      setState(() {

      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if(MediaQuery.of(context).viewInsets.bottom != 0 ){
      if(View.of(context).viewInsets.bottom == 0){

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 32.ss,right:32.ss,top: 32.ss),
                    child: Column(
                      children: [
                      Image.asset(
                        'assets/icons/sign_up_illustration.webp',
                        width: 250.ss,
                        height: 250.ss,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.left,
                          )),
                      CustomTextField(
                        controller: _nameTxtController,
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocusNode,
                        hintText: 'Name',
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 10.ss,
                      ),
                      CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: _mobileTxtController,
                        focusNode: _mobileFocusNode,
                        hintText: 'Mobile',
                        maxLine: 10,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 10.ss,
                      ),
                        CustomTextField(
                          controller: _passwordTxtController,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Password',
                          suffixIcon: Visibility(
                            visible: _passwordTxtController.text.isNotEmpty,
                            child: IconButton(
                                onPressed: () => setState(() {
                                  _obscureText = !_obscureText;
                                }),
                                icon: Icon(_obscureText
                                    ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined)),
                          ),
                          obscureText: _obscureText,
                          textInputAction: TextInputAction.done,
                        ),
                      SizedBox(
                        height: 20.ss,
                      ),
                      CustomButton(
                        onTap: register,
                        isLoading: _isLoading,
                        text: 'Sign In',
                        foregroundColor: ColorTheme.Snow_white,
                        backgroundColor: ColorTheme.Blue,
                      ),
                      SizedBox(
                        height: 3.ss,
                      ),
                      SizedBox(height: 10.ss),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 250.ss,
                            child: const Divider(
                              thickness: 2,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5.ss),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: ColorTheme.Snow_white),
                            child: Text(
                              'or',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 16.fss, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircularIconButton(icon: 'assets/icons/google.webp',onTap: (){},),
                            CircularIconButton(icon: 'assets/icons/facebook.webp',onTap: (){},),
                            CircularIconButton(icon: 'assets/icons/twitter.webp',onTap: (){},)
                          ],
                        ),
                      ),
                    ],),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.ss),
                child: RichText(
                  text: TextSpan(
                      text: 'Already have an account ',
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: ColorTheme.Blue,
                              fontSize: 12.fss,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle "Sign Up" click
                              if(Navigator.canPop(context)){
                                Navigator.of(context).pop();
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              }
                            },
                        )
                      ]),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void register() async {
    String name = _nameTxtController.text;
    String mobile = _mobileTxtController.text;
    String password = _passwordTxtController.text;
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    setState(() {
      _isLoading = true;
    });
    
    if(name.isEmpty){
      _nameFocusNode.requestFocus();
      return;
    }

    if(mobile.isEmpty || mobile.length < 10){
      _mobileFocusNode.requestFocus();
      return;
    }

    if(password.isEmpty){
    _passwordFocusNode.requestFocus();
      return;
    }


    if(connectivityResult.contains(ConnectivityResult.mobile)||connectivityResult.contains(ConnectivityResult.wifi)||connectivityResult.contains(ConnectivityResult.ethernet)){
      try{
        var uri = Uri.parse('https://appadmin.atharvaservices.com/api/Register/UserRegister');

        var body = json.encode({
          Consts.USER_NAME: name,
          Consts.MOBILE: mobile,
          Consts.PASSWORD: password,
        });

        var response = await post(uri, body: body ,headers: {
          Consts.CONTENT_TYPE: 'application/json',
        });

        var rawData = await json.decode(response.body);

        if(response.statusCode == 200 && rawData[Consts.STATUS] == 'success'){
          Fluttertoast.showToast(msg: 'user register successfully');
          if(Navigator.canPop(context)){
            Navigator.of(context).pop();
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
          }
          // final pref = await SharedPreferences.getInstance();
          // pref.setBool(Consts.IS_LOGIN, true);
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => Dashboard()),
          //       (route) => false,
          // );
        }else if(response.statusCode == 400 && rawData[Consts.STATUS] == 'error'){
          Fluttertoast.showToast(msg: rawData[Consts.MESSAGE]);
        };
      }catch(exception,trace){
        print('exception : $exception, trace : $trace');
      }
    }else{
      Fluttertoast.showToast(msg: 'check your internet connection',);
    }
    

    setState(() {
      _isLoading = false;
    });

  }
}
