import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/screens/Category.dart';
import 'package:flutter_nav_bar/screens/productdetails.dart';
import 'package:flutter_nav_bar/tab/responsive.dart';
import 'package:flutter_nav_bar/tab/tabscreen.dart';
import 'package:flutter_nav_bar/screens/cart_screen.dart';


class Module2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: CategoryScreen(),
        tablet: TabScreen()
      ),
    );
  }
}