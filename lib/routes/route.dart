import 'package:invest_mobile/screens/beginScreen.dart';
import 'package:invest_mobile/screens/compte/change_password.dart';
import 'package:invest_mobile/screens/compte/details_profil.dart';
import 'package:invest_mobile/screens/compte/portfeuil.dart';
import 'package:invest_mobile/screens/compte/transaction.dart';
import 'package:invest_mobile/screens/detailSouscri.dart';
import 'package:invest_mobile/screens/detailsPackScreen.dart';
import 'package:invest_mobile/screens/homePage.dart';
import 'package:invest_mobile/screens/loginPage.dart';
import 'package:invest_mobile/screens/othScreen.dart';
import 'package:invest_mobile/screens/signInPage.dart';
import 'package:flutter/material.dart';

import '../screens/recoverPassword.dart';

class MyRoute {
  static const String loginPage = "/";
  static const String onBoarding = "/onboarding";
  static const String begin = "/begin";
  static const String signIn = "/signin";
  static const String otp = "/otp";
  static const String forgetPassword = "/forgetpass";
  static const String homePage = "/homepage";
  static const String detailPack = "/detailpack";
  static const String detailSouscription = "/detailsouscription";
  static const String transaction = "/transaction";
  static const String portefeuil = "/portefeuil";
  static const String profilDetail = "/profildetail";
  static const String changePassword = "/changepassword";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: ((context) => const Login()));

      case signIn:
        return MaterialPageRoute(builder: ((context) => const SignIn()));

      case begin:
        return MaterialPageRoute(builder: ((context) => const BeginScreen()));

      case otp:
        return MaterialPageRoute(builder: ((context) => const Othen()));

      case forgetPassword:
        return MaterialPageRoute(
            builder: ((context) => const RecoverPassword()));

      case homePage:
        return MaterialPageRoute(builder: ((context) => const HomePage()));

      case detailPack:
        return MaterialPageRoute(builder: ((context) => const DetailsPack()));

      case detailSouscription:
        return MaterialPageRoute(
            builder: ((context) => const DetailsSouscription()));

      case transaction:
        return MaterialPageRoute(builder: ((context) => const Transaction()));

      case portefeuil:
        return MaterialPageRoute(builder: ((context) => const Wallet()));

      case profilDetail:
        return MaterialPageRoute(builder: ((context) => const DetailsProfil()));

      case changePassword:
        return MaterialPageRoute(
            builder: ((context) => const ChangePassword()));

      default:
        throw const FormatException('Route not found check route again');
    }
  }
}
