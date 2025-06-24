import 'package:flutter/widgets.dart';
import 'package:recipe/screens/home.dart';
import 'package:recipe/screens/auth/signin.dart';
// import 'package:recipe/screens/auth/signup.dart';
import 'package:recipe/utils/onboard.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    '/': (context) => const Onboard(),
    // '/': (context) => const SignupPage(),
    'home': (context) => const HomePage(),
    // 'profile':(context)=>const ProfilePage(),
    'signin': (context) => const SignInPage(),
  };
}
