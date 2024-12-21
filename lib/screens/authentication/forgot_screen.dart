import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import '../../utilities/color_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ForgetScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ForgetScreenStates();
}

class _ForgetScreenStates extends State<ForgetScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 32.ss,vertical: 10.ss),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/forgot_password_illustration.webp',
                          width: 250.ss,
                          height: 250.ss,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Forget password',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.left,
                            )),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          hintText: 'Mobile',
                        ),
                        SizedBox(
                          height: 10.ss,
                        ),
                        CustomTextField(
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Verification code',
                          obscureText: true,
                          enable: false,
                        ),
                        SizedBox(
                          height: 30.ss,
                        ),
                        CustomButton(
                          onTap: () {},
                          // => Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => LoginScreen())),
                          text: 'Get Code',
                          foregroundColor: ColorTheme.Snow_white,
                          backgroundColor: ColorTheme.Blue,
                        ),
                        SizedBox(
                          height: 3.ss,
                        ),
                        SizedBox(height: 10.ss),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.ss),
                child: RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
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
                              Navigator.of(context).pop();
                            },
                        )
                      ]),
                ),
              ),
            ],
          )),
    );
  }
  
}