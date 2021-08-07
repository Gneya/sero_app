
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        canvasColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return  _HomePage();
  }
}
class _HomePage extends State<MyHomePage> with SingleTickerProviderStateMixin
{
  checkLoginStatus() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setInt("index",0);
    print(sharedPreferences.getString('user_id'));
    if (sharedPreferences.getString('user_id') != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()), (
          Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => login()), (
          Route<dynamic> route) => false);
    }
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      checkLoginStatus();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffd45f),
        body: Center(child:Container(
            width: MediaQuery.of(context).size.width/1.5,
            child:Center(
              child: Image.asset("images/logo.png"),)
        ),
        ));
  }
}