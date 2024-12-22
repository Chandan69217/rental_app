import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/model/consts.dart';
import 'package:rental_app/model/dummy_json.dart';
import 'package:rental_app/screens/authentication/forgot_screen.dart';
import 'package:rental_app/screens/authentication/signup_screen.dart';
import 'package:rental_app/screens/dashboard.dart';
import 'package:rental_app/widgets/circular_icon_button.dart';
import 'package:rental_app/widgets/custom_button.dart';
import 'package:rental_app/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';

import '../../utilities/color_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenStates();
}

class _LoginScreenStates extends State<LoginScreen>
    with WidgetsBindingObserver {
  final TextEditingController _mobileTxtController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _mobileTxtError = false;
  bool _passwordTxtError = false;
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mobileTxtController.addListener(() {
      setState(() {
        _mobileTxtError = false;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordTxtError = false;
      });
    });
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
                padding: EdgeInsets.only(
                  left: 32.ss,
                  right: 32.ss,
                ),
                child: Column(
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
                      controller: _mobileTxtController,
                      keyboardType: TextInputType.number,
                      hintText: 'Mobile',
                      error: _mobileTxtError,
                      textInputAction: TextInputAction.next,
                      focusNode: _mobileFocusNode,
                    ),
                    SizedBox(
                      height: 10.ss,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Password',
                      suffixIcon: Visibility(
                        visible: _passwordController.text.isNotEmpty,
                        child: IconButton(
                            onPressed: () => setState(() {
                                  _obscureText = !_obscureText;
                                }),
                            icon: Icon(_obscureText
                                ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined)),
                      ),
                      error: _passwordTxtError,
                      obscureText: _obscureText,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                    ),
                    SizedBox(
                      height: 20.ss,
                    ),
                    CustomButton(
                      isLoading: _isLoading,
                      onTap: _login,
                      text: 'Log In',
                      foregroundColor: ColorTheme.Snow_white,
                      backgroundColor: ColorTheme.Blue,
                    ),
                    SizedBox(
                      height: 3.ss,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10.ss),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgetScreen())),
                          child: Padding(
                            padding: EdgeInsets.all(3.ss),
                            child: Text(
                              'Forget password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: ColorTheme.Gray,
                                  ),
                            ),
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
                              shape: BoxShape.circle,
                              color: ColorTheme.Snow_white),
                          child: Text(
                            'or',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 16.fss,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularIconButton(
                            icon: 'assets/icons/google.webp',
                            onTap: () {},
                          ),
                          CircularIconButton(
                            icon: 'assets/icons/facebook.webp',
                            onTap: () {},
                          ),
                          CircularIconButton(
                            icon: 'assets/icons/twitter.webp',
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
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
                      text: 'Sing Up',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: ColorTheme.Blue,
                          fontSize: 12.fss,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle "Sign Up" click
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
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

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final String mobileTxt = _mobileTxtController.text.trim();
    final String passwordTxt = _passwordController.text.trim();

    if (mobileTxt.isEmpty) {
      _mobileFocusNode.requestFocus();
      return;
    }
    if (passwordTxt.isEmpty) {
      _passwordFocusNode.requestFocus();
      return;
    }
    // here code for fetching response based on user inputs
    String responseMobile = DummyJson.loginRequest[Consts.MOBILE];
    String responsePassword = DummyJson.loginRequest[Consts.PASSWORD];

    if (mobileTxt == responseMobile && passwordTxt == responsePassword) {
      final pref = await SharedPreferences.getInstance();
      pref.setBool(Consts.IS_LOGIN, true);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (route) => false,
      );
    } else {
      if (mobileTxt != responseMobile) {
        setState(() {
          _mobileTxtController.clear();
          _mobileFocusNode.requestFocus();
          _mobileTxtError = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _passwordController.clear();
          _passwordFocusNode.requestFocus();
          _passwordTxtError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      if (View.of(context).viewInsets.bottom == 0) {
        _mobileFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
