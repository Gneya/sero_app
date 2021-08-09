import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoidBill extends StatefulWidget {

  @override
  _VoidBillState createState() => _VoidBillState();
}

class _VoidBillState extends State<VoidBill> {
  bool isClickedAdd = true;
  bool isClickedCancel = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 140),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            child: Container(
                height: 430,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('VOID BILL',
                          style: GoogleFonts.ptSans(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80,right: 30,left: 30),
                          child: Column(
                            children: [
                              Text('Are you Sure You want to Void this Bill.Once Voided it cannot be reversed',
                                style: GoogleFonts.ptSans(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('Yes',
                                    style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,

                                        fontSize: 30
                                    ),
                                  ),

                                  ),
                                  decoration: BoxDecoration(
                                    color:  Color(0xFFFFD45F),
                                    borderRadius: BorderRadius.circular(45),

                                  ),
                                  height: 60,
                                  width: 130,
                                ),
                                onTap: (){
                                  setState(() async {
                                    Navigator.pop(context);
                                    var cart=FlutterCart();
                                    cart.deleteAllCart();
                                    SharedPreferences shared = await SharedPreferences.getInstance();
                                    setState(() {
                                      shared.setString("customer_name", "");
                                      shared.setString("table_name", "");
                                      shared.setString("total", "0");
                                      shared.setInt("index", 0);
                                    });
                                    Fluttertoast.showToast(
                                        msg:"Void bill has been generated",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        textColor: Colors.green,
                                        timeInSecForIosWeb: 10);
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('No',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                                      fontSize: 30
                                  ),
                                  ),

                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFD45F),
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  height: 60,
                                  width: 130,
                                ),
                                onTap :(){
                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }
}


