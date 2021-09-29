import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nav_bar/screens/HomeScreen.dart';
import 'package:flutter_nav_bar/screens/Category.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/screens/login.dart';
import 'package:flutter_nav_bar/screens/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Delay extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return  _HomePage();
  }
}
class _HomePage extends State<Delay> with SingleTickerProviderStateMixin
{

  @override
  Widget build(BuildContext context) {
    go();
    return Scaffold(
        backgroundColor: Color(0xffffd45f),
        body: go());
  }
  go(){
    Future.delayed(Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => CartScreen()), (
          Route<dynamic> route) => false);
    });
  }
}