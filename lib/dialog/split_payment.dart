import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplitPay extends StatefulWidget {
  double Balance=0.0;
  SplitPay({Key? key,required this.Balance}) : super(key: key);

  @override
  _SplitPayState createState() => _SplitPayState();
}

class _SplitPayState extends State<SplitPay> {
  int items=2;
  String dropdownValue1 ='Cash';
  String dropdownValue2 ='Card';
  bool isClickedAdd= true;
  bool isClickedCancel= true;
  bool addRow = false;
  String temp ='0';
  bool isActive = true;
  List<String> payment =['0','0'];
  List<String> paymentMode =['Cash','Card'];
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 100),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width/1.2,
                child: ListView.builder(
                  itemCount:items ,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Payment Amount',
                              style: GoogleFonts.ptSans(
                                  color: Colors.white
                              ),),
                            Padding(
                              padding: const EdgeInsets.only(top:4,bottom: 20),
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextFormField(
                                  onChanged: (text) {
                                    setState(() {
                                      temp=text;
                                      payment[index]=temp;
                                    });
                                    print(temp);
                                  },
                                  keyboardType:TextInputType.number,
                                  decoration: InputDecoration(
                                      prefix: Text('\$'),
                                      helperStyle: GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color:Colors.brown),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color:Colors.brown),
                                      ),
                                      hintText: payment[index] ?? '0'
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Payment Mode',
                              style: GoogleFonts.ptSans(
                                  color: Colors.white
                              ),),
                            Padding(
                              padding: const EdgeInsets.only(top:4,bottom: 20),
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,
                                      left: 25),
                                  child: DropdownButton<String>(
                                    value: paymentMode[index],
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Cash',
                                        child: Text('Cash'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Card',
                                        child: Text('Card'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'PayTM',
                                        child: Text('PayTM'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'UPI',
                                        child: Text('UPI'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Other',
                                        child: Text('Other'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        dropdownValue1 = value!;
                                        paymentMode[index] = dropdownValue1;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Container(
                    child:Center(child: Text('Add Row',
                      style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD45F),
                      borderRadius: BorderRadius.circular(45),
                    ),
                    height: 45,
                    width: 120,
                  ),
                  onTap:(){
                    setState(() {
                      payment.add('0');
                      paymentMode.add('Cash');
                      items++;
                    });
                  }
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  child: InkWell(
                    onTap: () async {
                      double sum =0;
                      for( int i=0;i<payment.length;i++){
                        sum=sum+double.parse(payment[i]);
                      }
                      print(sum);
                      if(sum < widget.Balance){

                        Fluttertoast.showToast(
                            msg: "Total amount must be equal or greater  than balance amount",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.green,
                            timeInSecForIosWeb: 4);
                      }
                      else
                      {
                        List<Map<String,dynamic>> list_of_payment=[];
                        for(int i=0;i<items;i++){
                          Map<String,dynamic> payment1={
                            "amount":payment[i],
                            "method": paymentMode[i],
                          };
                          list_of_payment.add(payment1);
                          print(list_of_payment);
                        }
                        SharedPreferences shared = await SharedPreferences.getInstance();
                        shared.setBool("split", true);
                        shared.setString("list_of_payment", json.encode(list_of_payment));
                        shared.setDouble("sum", sum);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color:Color(0xFFFFD45F),
                          borderRadius: BorderRadius.circular(35),
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
                        width: 250,
                        height: 50,
                        child: Center(
                            child: Text(
                              "Continue",
                              textScaleFactor: 2.0,
                              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                            ))),

                  ),
                ),
              ),
            ],
          ),
        )

    );
  }
}




