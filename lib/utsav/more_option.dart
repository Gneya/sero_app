import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreOptions extends StatefulWidget {
  const MoreOptions({Key? key}) : super(key: key);

  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
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
                    setState(() {
                    });
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
            Column(
              children: [
                IconButton(
                  onPressed:()async{
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setInt('index',2);
                    // table_id=  prefs.getInt("table_id")!;
                    // table_name =prefs.getString("table_name")!;
                    // customer_name=prefs.getString("customer_name")!;
                    setState(() {

                      // _currentIndex =2;
                      // setState(() {
                      //   _isloading =false;
                      // });
                      // setState(() {
                      //
                      //
                      // });
                    });
                  },
                  iconSize: 40,
                  icon: Icon(Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}


