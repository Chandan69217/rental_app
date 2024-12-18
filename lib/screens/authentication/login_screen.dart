import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/screens/authentication/forgot_screen.dart';
import 'package:rental_app/screens/authentication/signup_screen.dart';
import 'package:rental_app/screens/dashboard.dart';
import 'package:rental_app/widgets/custom_button.dart';
import 'package:rental_app/widgets/custom_textfield.dart';
import 'package:sizing/sizing.dart';

import '../../utilities/color_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenStates();
}

class _LoginScreenStates extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.ss),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/icons/login_illustration.webp',
                width: 250.ss,
                height: 250.ss,
                fit: BoxFit.cover,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Log In',
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
                hintText: 'Password',
                ObscureText: true,
              ),
              SizedBox(
                height: 20.ss,
              ),
              CustomButton(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Dashboard()),(route) => false,),
                text: 'Log In',
                foregroundColor: ColorTheme.Snow_white,
                backgroundColor: ColorTheme.Blue,
              ),
              SizedBox(
                height: 3.ss,
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 250.ss,
                child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ForgetScreen())),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: Text('Forget password?',style: TextStyle(color: ColorTheme.Gray),),
                    )),
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
              SizedBox(
                height: 8.ss,
              ),
              RichText(
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: 'Sing Up',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: ColorTheme.Blue,
                            fontSize: 12.fss,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle "Sign Up" click
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupScreen()),
                            );
                          },
                      )
                    ]),
              )
            ],
          ),
        ),
      )),
    );
  }
}
