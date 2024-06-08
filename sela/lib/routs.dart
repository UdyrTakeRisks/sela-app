import 'package:flutter/material.dart';
import 'package:sela/screens/forgot_password/forgot_password_screen.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/screens/login_success/login_success.dart';
import 'package:sela/screens/sign_in/sign_in_screen.dart';
import 'package:sela/screens/sign_up/sign_up_screen.dart';
import 'package:sela/screens/splash/splash_screen.dart';

import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/otp/otp_screen.dart';

// use name routs instead of routes
// all routes should be in routs map
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
};
