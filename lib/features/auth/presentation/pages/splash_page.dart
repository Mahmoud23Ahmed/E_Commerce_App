import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart'; // استيراد مكتبة Lottie
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset(
        'assets/images/Me142akW2O.json',
        width: 350,
        height: 350,
        fit: BoxFit.cover,
      ),
      nextScreen: LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 2500, // مدة العرض
    );
  }
}
