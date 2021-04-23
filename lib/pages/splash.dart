import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    // preferences.remove('token');
    print(token);
    if (token == null) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.popAndPushNamed(context, 'login');
      });
    } else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.popAndPushNamed(context, 'dashboard');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Padne Sathi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            "Powered by: Anjila Gurung",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    ));
  }
}
