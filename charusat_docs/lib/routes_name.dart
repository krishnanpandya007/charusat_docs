import 'package:charusat_docs/done.dart';
import 'package:charusat_docs/screens/signin.dart';
import 'package:charusat_docs/screens/signup.dart';
import 'package:charusat_docs/screens/verify.dart';
import 'package:get/get.dart';

class RoutesName {
  static const String signin = "/signin";
  static const String signup = "/signup";
  static const String done = "/done";
  static const String verify = "/verify";
}

class Pages {
  static final pages = [
    GetPage(
      name: RoutesName.signin,
      page: () => const SignIn(),
    ),
    GetPage(
      name: RoutesName.signup,
      page: () => const SignUp(),
    ),
    GetPage(
      name: RoutesName.done,
      page: () => const Done(),
    ),
    GetPage(
      name: RoutesName.verify,
      page: () => const EmailVerification(),
    ),
  ];
}