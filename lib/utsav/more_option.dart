import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/HomeScreen.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../selectable.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions({Key? key}) : super(key: key);
  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}
class _MoreOptionsState extends State<MoreOptions> {
  int index =0;
  Future<void> getIndex() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var screen = shared.getString("screen");
    if(screen == "Home"){
      index =0;
    }
    else if(screen =="Category"){
      index =1;
    }
    else if(screen == "Cart"){
    index =2 ;
    }
    else if(screen == "Payment"){
       index=3;
    }
    else{

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getIndex();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getIndex();
    var cart =FlutterCart();
    return Scaffold(
      body: index ==0 ? HomeScreen(title: 'title'): index ==1 ? CategoryScreen(): CartScreen(),
      bottomSheet: new Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(
                1.0,
                1.0,
              ), //Offset
              blurRadius: 6.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed:(){
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectTable()),
                      );
                    });
                  },
                  iconSize: 25,
                  icon: Icon(Icons.table_chart_outlined,
                    color: Colors.grey[800],
                  ),
                ),
                Text('Tables',
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),)
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed:(){
                    Navigator.push(
                               context,
                               MaterialPageRoute(
                               builder: (context) => ResumeScreen()));
                  },
                  iconSize: 29,
                  icon: Icon(Icons.play_arrow_sharp,
                    color: Colors.grey[800],
                  ),
                ),
                Text('Resume',
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                )
              ],
            ),Column(
              children: [
                IconButton(
                  onPressed:(){
                    showDialog(
                        context: context,
                        builder: (context){
                    return VoidBill();
                        }
                    );
                  },
                  iconSize: 25,
                  icon: Icon(Icons.delete,
                    color: Colors.grey[800],
                  ),
                ),
                Text('Void',
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),)
              ],
            ),Column(
              children: [
                IconButton(
                  onPressed:() async {
                    var dio = Dio();
                    SharedPreferences shared=await SharedPreferences.getInstance();
                    var id = shared.getInt("table_id",);
                    print(shared.getInt("table_id"));
                    Map<String,dynamic> api1={
                      "table_id":id,
                      "table_status":"available"
                    };
                    dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                    var r2=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api1));
                    print(r2);
                    print(id);
                    var cart = FlutterCart();
                    cart.deleteAllCart();
                    setState(() {
                      shared.setString("customer_name", "");
                      shared.setString("table_name", "");
                      shared.setString("total", "0");
                    });

                    Fluttertoast.showToast(
                        msg:"Order has been cleared you can go to home screen",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.green,
                        timeInSecForIosWeb: 10);
                  },
                  iconSize: 25,
                  icon: Icon(Icons.clear_all_sharp,
                    color: Colors.grey[800],
                  ),
                ),
                Text('Clear',
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}


