//first screen(splash screen)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/login.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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

  runApp(
      Phoenix(
        child: MyApp(),
      ),

  );
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
  bool _isloading = false;
  int sec=3;
  checkLoginStatus() async {
    var cart=FlutterCart();
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setStringList("variation", []);
    sharedPreferences.setString("total",cart.getCartItemCount().toString());
    sharedPreferences.setInt("index",0);
    sharedPreferences.setInt("seconds",3);
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
  fetchSec() async {
    setState(() {
      _isloading = true;
    });
    SharedPreferences shared = await SharedPreferences .getInstance();
    sec = shared.getInt("seconds")?? 3;
    print(sec);
    Future.delayed(Duration(seconds: sec)).then((value) {
      checkLoginStatus();
    });
    setState(() {
      _isloading =false;
    });
  }

  @override
  void initState() {

    fetchSec();

    print("intintintintinti"+sec.toString());
    super.initState();
      // Future.delayed(Duration(seconds: sec)).then((value) {
      //   checkLoginStatus();
      // });

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffd45f),
        body:   _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)): Center(child:Container(
            width: MediaQuery.of(context).size.width/1.5,
            child:Center(
              child: Image.asset("images/logo.png"),)
        ),
        ));
  }
}