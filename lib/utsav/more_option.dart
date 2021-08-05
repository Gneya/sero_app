

import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/HomeScreen.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      body: index ==0 ? HomeScreen(title: 'title'): index ==1 ? CategoryScreen():CartScreen(),
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
                      // add tablenumber//////
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
                    // showDialog(
                    //     context: context,
                    //     builder: (context){
                    // return VoidBill(Ammount: paymentAmount,);
                    //     }
                    // );
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
                  onPressed:(){

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


