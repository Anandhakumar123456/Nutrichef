import 'package:recipe/utils/export.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    '/': (context) => const Onboard(),
    '/signup': (context) => const SignupPage(),
    '/home': (context) => const HomePage(),
    '/profile': (context) => const Profile(),
    '/signin': (context) => const SignInPage(),
  };
}
