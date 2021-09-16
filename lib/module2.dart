import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/productdetails.dart';
import 'package:flutter_nav_bar/responsive.dart';
import 'package:flutter_nav_bar/tabscreen.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';


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