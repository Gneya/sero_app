import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoidBill extends StatefulWidget {

  @override
  _VoidBillState createState() => _VoidBillState();
}

class _VoidBillState extends State<VoidBill> {
  bool isClickedAdd = true;
  bool isClickedCancel = true;
  List<Map<String,dynamic>> list=[];
  int index =0;
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
                                onTap: () async {


                                  SharedPreferences shared=await SharedPreferences.getInstance();

                                  var  getOdID = shared.getString("order_id")?? 0;
                                  print("ORDER:"+shared.getString("order_id").toString());
                                  Map<String,dynamic> api={
                                    "sell":getOdID
                                  };
                                  var dio=Dio();
                                  List<Map<String,dynamic>> list_of_m=[];
                                  var id = shared.getInt("table_id",);
                                  print(shared.getInt("table_id"));
                                  Map<String,dynamic> api1={
                                    "table_id":id,
                                    "table_status":"available"
                                  };
                                  dio.options.headers["Authorization"]=shared.getString("Authorization");
                                  var r2=await dio.post("https://seropos.app/connector/api/change-table-status",data: json.encode(api1));
                                  print(r2);
                                  print(id);

                                  dio.options.headers["Authorization"]=shared.getString("Authorization");
                                  var r=await dio.delete("https://seropos.app/connector/api/sell/${getOdID}",data: json.encode(api));
                                  print(r);
                                  var v = r.toString();
                                  print(v);

                                  Fluttertoast.showToast(
                                      msg: "Order Voided",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.green,
                                      timeInSecForIosWeb: 4);
                                  Navigator.pop(context);
                                  shared.setStringList("variation", []);
                                  setState(() {
                                    var cart=FlutterCart();
                                    cart.deleteAllCart();
                                    shared.setInt("index", 0);
                                    shared.setInt("PAY_HOLD", 1);
                                    shared.setString("total", "0");
                                  });
                                  shared.setInt("seconds", 0);
                                  Phoenix.rebirth(context);
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




