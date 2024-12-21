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
            children: [
              Expanded(
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
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Email',
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
                        height: 20.ss,
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
                            InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(Radius.circular(50.ss)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/google.webp',
                                    height: 32.ss,
                                    width: 32.ss,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(Radius.circular(50.ss)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/facebook.webp',
                                    height: 32.ss,
                                    width: 32.ss,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(Radius.circular(50.ss)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/twitter.webp',
                                    height: 32.ss,
                                    width: 32.ss,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RichText(
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
                            // Handle "Sign Up" click
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => SignUpPage()),
                            // );
                          },
                      )
                    ]),
              ),
              SizedBox(height: 10.ss,)
            ],
          )),
    );
  }
  
}