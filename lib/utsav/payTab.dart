import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/main.dart';
import 'package:flutter_nav_bar/utsav/redeem.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/shipping.dart';
import 'package:flutter_nav_bar/utsav/split_payment.dart';
import 'package:flutter_nav_bar/utsav/discount.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../selectable.dart';


class PayTab extends StatefulWidget {
  double Ammount=0.0;
  double Balance=0.0;
  double Discountt =0.0;
  int Redeem =0;
  PayTab({ Key? key,
    required this.Ammount
    ,required this.Balance,
    required this.Discountt,
    required this.Redeem}) : super(key: key);

  @override
  _PayTabState createState() => _PayTabState();
}

class _PayTabState extends State<PayTab> {
  static double paymentAmount = 0;
  var size, height, width;
  double tipAmount = 0.0;
  String toBePaid = '0';
  int _currentIndex = 0;
  bool isClicked1 = true;
  bool isClicked2 = false;
  bool isClicked3 = false;
  bool isClicked4 = false;
  bool isClicked5 = false;
  bool isClicked6 = false;
  bool isClicked7 = false;
  bool isClicked8 = false;
  bool isClicked9 = false;
  bool isClicked10 = false;
  bool isClicked11 = false;
  bool isClicked12 = false;
  bool isClicked13 = false;
  TextEditingController pay=new TextEditingController();
  var flag=false;
  bool value = false;
  bool isEnabled = false;
  bool isEnabledBalance = false;
  bool _isloading = false;
  String table_name = '';
  final _tipController = new TextEditingController();
  final change_return = new TextEditingController();
  List<String> paymentMethod =[];
  List<bool> isclicked =[];
  final _formKey = GlobalKey<FormState>();
  final _Key = GlobalKey<FormState>();

  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String totalAmount() {
    if (_tipController.text != '') {
      tipAmount = double.parse(_tipController.text);
      setState(() {
        isEnabled ?
        balance = (balance + tipAmount)
            : balance = (balance - tipAmount);
      });
    }

    return balance.toStringAsFixed(2);
  }
  double amount=0;
  double balance=0;
  double discountt=0;
  String discount_type ="";
  int redeemPoint =0;
  double shipping_charge =0.0;
  int redeem=0;
  List<String> _payMeth = ["", "", "", "", "",];
  _PayTabState() {
    fetchData().then((val) =>
        setState(() {
          print(val);
          _payMeth = val;
          print(_payMeth);
        }));
  }
  Future<void> select(String name)
  async {
    SharedPreferences shared=await SharedPreferences.getInstance();
    print("NAME="+name);
    if(name=="Cash")
    {
      shared.setString("method","cash");
      isClicked1=true;
    }
    else if(name=="Card")
    {
      shared.setString("method","card");
      setState(() {
        isClicked1=false;
        isClicked2=true;
      });
    }
    else
    {
      setState(() {
        isClicked1=false;
        isClicked4=true;
        isClicked2=false;
      });
    }
  }
  bool func(String f)
  {
    bool flag=false;
    for(int i=0;i<paymentMethod.length;i++)
    {
      if(paymentMethod[i]==f) {
        if (i < isclicked.length) {
          if (isclicked[i] == true) {
            flag = true;
            break;
          }
          else {
            flag = false;
          }
        }
      }
    }
    return flag;
  }

  Future<List<String>> fetchData() async {
    /*
     payment mode values are not showing on the screen whenever below values are used or not commented
    */
    setState(() {
      _isloading=true;
    });
    Map data = await getData();
    amount=widget.Ammount;
    redeem=widget.Redeem;
    SharedPreferences shared=await SharedPreferences.getInstance();
    balance=shared.getDouble("balance")!;
    print(balance.toStringAsFixed(2)+" Balance in payment");
    String myUrl = "https://seropos.app/connector/api/business-details";
    http.Response response = await http.get((Uri.parse(myUrl)), headers: {
      'Authorization':shared.getString("Authorization")??""
    });
    var v=json.decode(response.body);
    var i =v["data"]["locations"][0]["default_payment_accounts"];
    print( v["data"]["locations"][0]["default_payment_accounts"]);
    paymentMethod=[];
    print(paymentMethod);
    if(i["cash"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["cash"]);
      isclicked.add(true);
    }
    if(i["card"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["card"]);
      isclicked.add(false);
    }
    if(i["Reward Points"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["Reward Points"]);
      isclicked.add(false);
    }
    if(i["cheque"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["cheque"]);
      isclicked.add(false);
    }
    if(i["paytm"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["paytm"]);
      isclicked.add(false);
    }
    if(i["other"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["other"]);
      isclicked.add(false);
    }
    if(i["custom_pay_1"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_1"]);
      isclicked.add(false);
    }
    if(i["custom_pay_2"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_2"]);
      isclicked.add(false);
    }
    if(i["custom_pay_3"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_3"]);
      isclicked.add(false);
    }
    if(i["custom_pay_4"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_4"]);
      isclicked.add(false);
    }
    if(i["custom_pay_5"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_5"]);
      isclicked.add(false);
    }
    if(i["custom_pay_6"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_6"]);
      isclicked.add(false);
    }
    if(i["custom_pay_7"]["is_enabled"]=="1"){
      print("yes");
      paymentMethod.add(data["custom_pay_7"]);
      isclicked.add(false);
    }
    print(paymentMethod.length);
    print(isclicked.length);
    print(paymentMethod[1]);
    setState(() {
      _isloading=false;
    });
    return paymentMethod;
  }
  Widget selectPaymentMode(){
    if(isClicked1 ==true){
      return Container(
        height: 385 ,
        color:Colors.white,
        width: width/3,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CASH',
                        style: GoogleFonts.ptSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ],
                ),
                Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,right: 30,left: 23),
                                    child: Text('Discount Amount',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ) ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(35),
                                            color :Colors.white,
                                          ),
                                          width: MediaQuery.of(context).size.width/2.5,
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                                '\$'+discountt.toStringAsFixed(2),
                                                textScaleFactor: 1.25,
                                                // style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                              ))),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,right:8),
                                    child: Text('Redeemed Points',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(35),
                                          color :Colors.white,
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              redeemPoint.toString(),
                                              textScaleFactor: 1.25,
                                              // style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                            )
                                        )
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 8),
                                    child: Text('Tip Amount',
                                      style:GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ) ,),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        readOnly: isEnabled,
                                        controller: _tipController,
                                        keyboardType:TextInputType.number,
                                        decoration: InputDecoration(
                                          prefix: Text('\$'),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 20),
                                    child: Text('Change Return',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(35),
                                          color :Colors.white,
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              '\$'+(change_return.text),
                                              textScaleFactor: 1.25,
                                            ))),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text('Final Amount',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          color :Color(0xFFFFD45F),
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              '\$'+balance.toStringAsFixed(2),
                                              textScaleFactor: 1.25,
                                              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                            ))),

                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: this.isEnabled,
                      activeColor: Color(0xFFFFD45F),
                      onChanged: (value) {
                        setState(() {
                          if(isClicked2==true)
                          {
                            if( _Key.currentState!.validate())
                            {
                              this.isEnabled = value!;
                              totalAmount();
                            }
                          }
                          else if(isClicked1 ==true){
                            // if( _Key.currentState!.validate())
                            {
                              this.isEnabled = value!;
                              totalAmount();
                            }
                          }
                        }
                        );
                      },
                    ),
                    Text(
                      'Continue',
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }


    else if(isClicked2==true){
      return  Container(
          height: 320 ,
          color:Colors.white,
          width: width/3,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CARD',
                        style: GoogleFonts.ptSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 8),
                                    child: Text('Payment Amount',
                                      style:GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ) ,),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: TextFormField(
                                      keyboardType:TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '\$'+pay.text,
                                        hintStyle: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color:Colors.brown),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color:Colors.brown),
                                        ),
                                      ),
                                      onFieldSubmitted: (value){
                                        print("Hii");
                                        setState(() {
                                          change_return.text=(double.parse(pay.text)-balance).toStringAsFixed(2);
                                          print(change_return.text);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 8),
                                    child: Text('Card Number',
                                      style:GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ) ,),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: Form(
                                      key: _Key,
                                      child: TextFormField(
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(4)
                                        ],
                                        readOnly: isEnabled,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter last 4 digit of your card number';
                                          }
                                          return null;
                                        },
                                        keyboardType:TextInputType.number,
                                        obscureText: true,
                                        decoration: InputDecoration(

                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                        ),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,right: 30,left: 23),
                                    child: Text('Discount Amount',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(35),
                                          color :Colors.white,
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              '\$'+widget.Discountt.toStringAsFixed(2),
                                              textScaleFactor: 1.25,
                                            ))),
                                  ),
                                ]
                            ),
                          ),
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,right: 8),
                                    child: Text('Redeemed Points',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(35),
                                          color :Colors.white,
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              redeemPoint.toString(),
                                              textScaleFactor: 1.25,
                                            ))),

                                  ),
                                ]
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 8),
                                    child: Text('Tip Amount',
                                      style:GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ) ,),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        readOnly: isEnabled,
                                        controller: _tipController,
                                        keyboardType:TextInputType.number,
                                        decoration: InputDecoration(
                                          prefix: Text('\$'),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color:Colors.brown),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text('Balance Amount',
                                      style:GoogleFonts.ptSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      ) ,),
                                  ),
                                  Container(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          color :Color(0xFFFFD45F),
                                        ),
                                        width: MediaQuery.of(context).size.width/2.5,
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                              '\$'+widget.Balance.toStringAsFixed(2),
                                              textScaleFactor: 1.25,
                                              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                            ))),

                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      );
    }
    else if(isClicked3==true){
      return Container(
        height: 300,
        child: Center(
          child: Text('Cheque Service not started yet'),
        ),
      );
    }
    else if(isClicked4==true){
      return Container(
        height: 300,
        child: Center(
          child: Text('Bank Transfer  Service not started yet'),
        ),
      );
    }
    else if(isClicked5==true){
      return Container(
        height: 300,
        child: Center(
          child: Text('Other Services not started yet'),
        ),
      );
    }
    return Container();
  }
  bool result = false;
  @override
  void initState() {
    fetchData();
    //getSharedPrefs();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    print("PRINT IN BUILD"+balance.toStringAsFixed(2));
    int _counter = 1;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      floatingActionButton: SpeedDial(
        marginBottom: 13, //margin bottom
        icon: Icons.open_in_browser_outlined, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.amber, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor: Colors.amber, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: 50.0, //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes

        elevation: 8.0, //shadow elevation of button
        shape: CircleBorder(), //shape of button

        children: [
          SpeedDialChild( //speed dial child
            child: Icon(Icons.table_chart_sharp),
            foregroundColor: Colors.white,
            backgroundColor: Colors.amber,
            // label: 'table',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectTable()),
                );
              });
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.play_arrow_sharp),
            foregroundColor: Colors.white,
            backgroundColor: Colors.amber,
            // label: 'resume',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResumeScreen()));
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.delete),
            foregroundColor: Colors.white,
            backgroundColor: Colors.amber,
            // label: 'void',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return VoidBill();
                  }
              );
            },
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.clear_all),
            foregroundColor: Colors.white,
            backgroundColor: Colors.amber,
            // label: 'clear',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              var dio = Dio();
              SharedPreferences shared=await SharedPreferences.getInstance();
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
              shared.setStringList("variation", []);
              var cart = FlutterCart();
              cart.deleteAllCart();
              setState(() {
                shared.setString("customer_name", "");
                shared.setString("table_name", "");
                shared.setInt("index", 0);
                shared.setString("total", "0");
              });

              Fluttertoast.showToast(
                  msg:"Order has been cleared you can go to home screen",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.green,
                  timeInSecForIosWeb: 10);
              shared.setInt("seconds", 0);
              Phoenix.rebirth(context);
              /*
               *
               * here the rebirth thing is added
               *
               *
               * */
            },
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
          //add more menu item childs here
        ],
      ),
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(bottom:80,left:0),
            child:IconButton(
              icon:Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            )
        ),
        automaticallyImplyLeading: false,
        flexibleSpace:  Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30),),
                  color :const Color(0xffffd45f),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        1.0,
                        1.0,
                      ), //Offset
                      blurRadius: 0.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),],
                ),
                height:145,
                child:Padding(
                  padding: const EdgeInsets.only(top:25),
                  child: Column(
                    children:[Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            icon: const Icon(Icons.menu,),
                            onPressed: () {
                            },
                          ),
                          Text(table_name,style: GoogleFonts.ptSans(color: Colors.black,fontSize: 18)),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 0),
                                child: IconButton(
                                  icon: const Icon(Icons.notifications,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return OnlineOrder();
                                        }
                                    );
                                  },
                                ),),
                              CircleAvatar(
                                  backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')
                              ),
                            ],
                          ),
                        ]),
                      Container(
                        padding: EdgeInsets.only(top: 0),
                        //width: MediaQuery.of(context).size.width,
                        child:  Padding(
                          padding: const EdgeInsets.only(top: 0,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  OutlineButton(
                                    onPressed: () async {
                                      var cart=FlutterCart();
                                      SharedPreferences shared = await SharedPreferences.getInstance();
                                      final _dialog=await showDialog(
                                          context: context,
                                          builder: (context){
                                            return Discount(Ammount: widget.Ammount, Balance:balance , Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      );
                                      if(_dialog) {
                                        print("Inside if");
                                        setState(() {
                                          balance =shared.getDouble("Balance")!;
                                          amount=shared.getDouble("Ammount")!;
                                          discountt=shared.getDouble("Discountt")!;
                                          discount_type = shared.getString("DiscountType")!;
                                          print("ddddddddddddddddddddddd"+discount_type);
                                          // redeemPoint =shared.getInt("Redeemed Points")!;
                                          // print(redeemPoint);
                                          print("PRINT:" + balance.toString());
                                        });
                                      }

                                    },
                                    highlightedBorderColor: Colors.black87,
                                    textColor: Colors.black87,
                                    // splashColor: isClickedButton? Colors.white : Color(0xFFFFD45F),
                                    child: Icon(
                                      Icons.sell_outlined,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(13),
                                    shape: CircleBorder(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('Discount',
                                      style: GoogleFonts.ptSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      ),),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  OutlineButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return SplitPay( Balance: balance,);
                                          }
                                      );
                                    },
                                    highlightedBorderColor: Colors.black87,
                                    textColor: Colors.black87,
                                    child: Icon(
                                      Icons.safety_divider,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(13),
                                    shape: CircleBorder(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('Split',
                                      style: GoogleFonts.ptSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      ),),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  OutlineButton(
                                    onPressed: ()  async {
                                      SharedPreferences shared = await SharedPreferences.getInstance();
                                      final _dialog = await showDialog(
                                          context: context,
                                          builder: (context){
                                            return RedeemPoint(Ammount: widget.Ammount, Balance:balance , Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      );
                                      if(_dialog) {
                                        print("Inside if");
                                        setState(() {
                                          balance =shared.getDouble("Balance")!;
                                          amount=shared.getDouble("Ammount")!;
                                          // discountt=shared.getDouble("Discountt")!;
                                          // discount_type = shared.getString("DiscountType")!;
                                          print("ddddddddddddddddddddddd"+redeemPoint!.toString());
                                          redeemPoint =shared.getInt("Redeemed Points")!;
                                          print(redeemPoint);
                                          print("PRINT:" + balance.toString());
                                        });
                                      }
                                    },
                                    highlightedBorderColor: Colors.black87,
                                    textColor: Colors.black87,
                                    child: Icon(
                                      Icons.redeem_rounded,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(13),
                                    shape: CircleBorder(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('Points',
                                      style: GoogleFonts.ptSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      ),),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  OutlineButton(
                                    onPressed: () async {
                                      SharedPreferences shared = await SharedPreferences.getInstance();
                                      final _dialog=await showDialog(
                                          context: context,
                                          builder: (context){
                                            return Shipping(Ammount: widget.Ammount, Balance: balance,
                                              Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      );
                                      if(_dialog) {
                                        print("Inside if");
                                        setState(() {
                                          balance =shared.getDouble("Balance")!;
                                          amount=shared.getDouble("Ammount")!;
                                          // redeemPoint =shared.getInt("Redeemed Points")!;
                                          // print(redeemPoint);
                                          shipping_charge =shared.getDouble("Shipping")!;
                                          print(shipping_charge);
                                          print("PRINT:" + balance.toString());
                                        });
                                      }
                                    },
                                    highlightedBorderColor: Colors.black87,
                                    textColor: Colors.black87,
                                    child: Icon(
                                      Icons.local_shipping,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(13),
                                    shape: CircleBorder(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('Shipping',
                                      style: GoogleFonts.ptSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      ),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        ),
        toolbarHeight: 135,
        backgroundColor: Colors.white,
      ),
      body:_isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)): Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  height: height,
                  width: width/3.3,
                  color:Colors.white54,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PAYMENT MODE',
                                style: GoogleFonts.ptSans(
                                    fontSize: 18,fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: paymentMethod.length*40,
                            child:  SingleChildScrollView(
                              child: Wrap(
                                children: paymentMethod.map((f) => GestureDetector(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: 50,
                                        minWidth: 80,
                                        maxHeight: 50,
                                        maxWidth: 80),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color:  func(f) ?Color(0xFFFFD45F):Colors.white ,
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
                                    child: f.length>6 ?
                                    Center(
                                      child: Text(f.substring(0,6),
                                        style: GoogleFonts.ptSans(
                                          fontWeight:FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ):
                                    Center(
                                      child: Text(
                                        f,
                                        style: GoogleFonts.ptSans(
                                          fontWeight:FontWeight.w600,
                                          fontSize: 18,
                                        ),

                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    int res=0;
                                    for(int i=0;i<paymentMethod.length;i++)
                                    {
                                      if(paymentMethod[i]==f)
                                      {
                                        isclicked[i]=true;
                                        res=i;
                                        flag=true;
                                      }
                                      else
                                      {
                                        isclicked[i]=false;
                                        flag=false;
                                      }
                                      print("METHODS");
                                    }
                                    select(f);
                                  },
                                ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ) ],
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 0.5,
              ),
              selectPaymentMode(),
              VerticalDivider(
                thickness: 0.5,
              ),
              Container(
                height: height,
                width: width/3.3,
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Checkbox(
                    //       value: this.isEnabled,
                    //       activeColor: Color(0xFFFFD45F),
                    //       onChanged: (value) {
                    //         setState(() {
                    //           if(isClicked2==true)
                    //           {
                    //             if( _Key.currentState!.validate())
                    //             {
                    //               this.isEnabled = value!;
                    //               totalAmount();
                    //             }
                    //           }
                    //           else if(isClicked1 ==true){
                    //             // if( _Key.currentState!.validate())
                    //             {
                    //               this.isEnabled = value!;
                    //               totalAmount();
                    //             }
                    //           }
                    //         }
                    //         );
                    //       },
                    //     ),
                    //     Text(
                    //       'Continue',
                    //     )
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 73),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8,left: 8),
                                    child: Text('Payment Amount',
                                      style:GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400
                                      ) ,),
                                  ),
                                  Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: TextFormField(
                                      key:_Key,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Payment Amount';
                                        }
                                        return null;
                                      },
                                      enableInteractiveSelection: false,
                                      //focusNode: new AlwaysDisabledFocusNode(),
                                      controller: pay,
                                      keyboardType:TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "00.00",
                                        hintStyle: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color:Colors.brown),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color:Colors.brown),
                                        ),
                                      ),
                                      onFieldSubmitted: (value){
                                        print("Hii");
                                        setState(() {
                                          print(pay.text);
                                          change_return.text=(double.parse(pay.text)-balance).toStringAsFixed(2);
                                          print(change_return.text);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: InkWell(
                              onTap:isEnabled ? () async {
                                var dio=Dio();
                                List<Map<String,dynamic>> list_of_m=[];
                                SharedPreferences shared=await SharedPreferences.getInstance();
                                List<dynamic> list_of_products=json.decode(shared.getString("products")!);
                                var id = shared.getInt("table_id",);
                                print("tttttttttaaabbbbbbbbbbbbbbbbbbbbllllllleeee");
                                print(shared.getInt("table_id"));
                                Map<String,dynamic> api1={
                                  "table_id":id,
                                  "table_status":"available"
                                };
                                dio.options.headers["Authorization"]=shared.getString("Authorization");
                                var r2=await dio.post("https://seropos.app/connector/api/change-table-status",data: json.encode(api1));
                                print(r2);
                                print(id);


                                var variation=shared.getStringList("variation");
                                var cart=FlutterCart();
                                for(int index=0;index<cart.cartItem.length;index++)
                                {
                                  String note="";
                                  int tax_id=0;
                                  for(int i=0;i<list_of_products.length;i++)
                                  {
                                    if(list_of_products[i]["pid"]==cart.cartItem[index].productId)
                                    {
                                      note=list_of_products[i]["note"]??"";
                                      tax_id=list_of_products[i]["tax_id"]??0;
                                      print(note);
                                      break;
                                    }
                                  }
                                  Map<String,dynamic> product={
                                    "product_id":double.parse(cart.cartItem[index].productId.toString()),
                                    "variation_id":double.parse(variation![index]),
                                    "quantity": cart.cartItem[index].quantity,
                                    "unit_price": cart.cartItem[index].unitPrice,
                                    "tax_rate_id":tax_id,
                                    "note":note??""
                                  };
                                  print(product);
                                  list_of_m.add(product);
                                  // print(list_of_m);
                                }
                                if(shared.containsKey("modifiers")){
                                  if(shared.getString("modifiers")!="") {
                                    List<dynamic> mod = json.decode(
                                        shared.getString("modifiers") ?? "");
                                    print(mod[0]);
                                    for (int i = 0; i < mod.length; i++) {
                                      list_of_m.add(mod[0]);
                                    }
                                  }
                                }
                                print(list_of_m);
                                var sar =shared.getInt("types_of_service_id");
                                var dar = shared.getString("DiscountType");
                                var car = shared.getString("customer_name");
                                print(car!*10);
                                print (dar);
                                var service_id=shared.getInt("types_of_service_id");
                                print(service_id.toString()+"servvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv" );
                                String typ_ser ;
                                if(service_id == 3){
                                  typ_ser = "ordered";
                                }
                                else{
                                  typ_ser = "offline";
                                }

                                if(shared.getString("order_id")=="")
                                {

                                  Map<String,dynamic> api= {
                                    "sells":[
                                      {
                                        "table_id" :shared.getInt("table_id")??null,
                                        "location_id": shared.getInt("bid")??1,
                                        "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                        "discount_amount": shared.getDouble("Discountt_for_db")??0,
                                        "discount_type": dar,
                                        "rp_redeemed": shared.getInt("Redeemed Points"),
                                        "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString()),
                                        // "shipping_details": null,
                                        // "shipping_address": null,
                                        // "shipping_status": null,
                                        // "delivered_to": null,
                                        "shipping_status":typ_ser,
                                        "delivered_to":car,
                                        "types_of_service_id":sar,
                                        "is_suspend":0,
                                        "shipping_charges": shared.getDouble("Shipping"),
                                        "packing_charge":shared.getDouble("packing_charge")?? 0.0,
                                        "products":list_of_m,
                                        "tip":_tipController.text,
                                        "change_return":double.parse(change_return.text),
                                        "payments": [
                                          {
                                            "amount":double.parse(pay.text),
                                            "method":shared.getString("method")
                                          }
                                        ]
                                      }
                                    ]
                                  };
                                  print(api);
                                  var dio=Dio();
                                  dio.options.headers["Authorization"]=shared.getString("Authorization");
                                  var r=await dio.post("https://seropos.app/connector/api/sell",data: json.encode(api));
                                  print(r.data);
                                  // var y =r.data["id"];
                                  var v=r.data[0]["invoice_no"];
                                  print(v.toString());
                                  shared.setString("order_id", v);
                                  shared.setInt("index",0);
                                  shared.setInt("PAY_HOLD",1);
                                  shared.setDouble("Shipping", 0.0);
                                  shared.setDouble("packing_charge", 0.0);
                                  shared.setDouble("Discountt", 0.0);
                                  cart.deleteAllCart();
                                  shared.setString("total", "0");
                                  Fluttertoast.showToast(
                                      msg: "Payment Successful and Your Order Id is $v",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.green,
                                      timeInSecForIosWeb: 4);


                                }
                                else{
                                  print('haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaaa');
                                  Map<String,dynamic> driver={
                                    "order_id":shared.getString("order_id"),
                                    "driver_id":shared.getString("driver_id")
                                  };
                                  var dio=Dio();
                                  dio.options.headers["Authorization"]=shared.getString("Authorization");
                                  var r3=await dio.post("https://seropos.app/connector/api/assign-order",data: json.encode(driver));
                                  print("order is assigned");
                                  print(r3);
                                  print(shared.getInt("Redeemed Points"));
                                  Map<String,dynamic> api=
                                  {
                                    "sells":[
                                      {
                                        "table_id" :shared.getInt("table_id")??null,
                                        "location_id": shared.getInt("bid")??1,
                                        "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                        "discount_amount": shared.getDouble("Discountt_for_db")??0,
                                        "discount_type": dar,
                                        "rp_redeemed": shared.getInt("Redeemed Points"),
                                        "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString()),
                                        // "shipping_details": null,
                                        // "shipping_address": null,
                                        // "shipping_status": null,
                                        // "delivered_to": null,
                                        "shipping_status":typ_ser,
                                        "delivered_to":car,
                                        "types_of_service_id":sar,
                                        "is_suspend":0,
                                        "shipping_charges": shared.getDouble("Shipping"),
                                        "packing_charge":shared.getDouble("packing_charge")?? 0.0,
                                        "products":list_of_m,
                                        "tip":_tipController.text,
                                        "change_return":double.parse(change_return.text),
                                        "payments": [
                                          {
                                            "amount":double.parse(pay.text),
                                            "method":shared.getString("method")
                                          }
                                        ]
                                      }
                                    ]
                                  };
                                  print(json.encode(api));

                                  var vid = shared.getString("order_id".toString());
                                  dio.options.headers["Authorization"]=shared.getString("Authorization");
                                  print(vid);
                                  var r=await dio.put("https://seropos.app/connector/api/sell/$vid",data: json.encode(api));
                                  print("hahah");
                                  print(r.data);
                                  var v=r.data["invoice_no"];
                                  print(v);
                                  shared.setString("order_id", v);
                                  cart.deleteAllCart();
                                  setState(() {
                                    shared.setString("total","0");
                                    shared.setInt("index", 0);
                                    shared.setInt("PAY_HOLD",1);
                                    shared.setDouble("Shipping", 0.0);
                                    shared.setDouble("packing_charge", 0.0);
                                    shared.setDouble("Discountt", 0.0);
                                  });



                                  Fluttertoast.showToast(
                                      msg: "Payment Successful and Your Order Id is $vid",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.green,
                                      timeInSecForIosWeb: 4);
                                }
                                shared.setInt("seconds", 0);
                                Phoenix.rebirth(context);

                              }:(){},
                              child: Container(
                                  decoration: BoxDecoration(
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
                                    color : isEnabled  ?  Color(0xFFFFD45F):Colors.grey,
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                  width: 100,
                                  height: 45,
                                  child: Center(
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.credit_card),
                                          Text(
                                            'Pay',
                                            textScaleFactor: 1.5,
                                            style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ) )),
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            child: InkWell(
                              onTap:() async {
                                var dio=Dio();
                                SharedPreferences shared=await SharedPreferences.getInstance();
                                dio.options.headers["Authorization"]=shared.getString("Authorization");
                                var oid = shared.getString("order_id");
                                var r=await dio.get("https://seropos.app/connector/api/sell/$oid");
                                print(oid);
                                print(r.data['data'][0]['invoice_token']);
                                var  url = "https://seropos.app/invoice/"+r.data['data'][0]['invoice_token'];
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }

                                var id = shared.getInt("table_id",);
                                print(shared.getInt("table_id"));
                                setState(() {
                                  _isloading=true;
                                });
                                Map<String,dynamic> api1={
                                  "table_id":id,
                                  "table_status":"billing"
                                };
                                dio.options.headers["Authorization"]=shared.getString("Authorization");
                                var r2=await dio.post("https://seropos.app/connector/api/change-table-status",data: json.encode(api1));
                                print(r2);
                                print(id);
                                setState(() {
                                  _isloading=false;
                                });

                              },
                              child: Container(
                                  decoration: BoxDecoration(
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
                                    color : isEnabled  ?  Color(0xFFFFD45F):Colors.grey,
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                  width: 100,
                                  height: 45,
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.print_outlined),
                                          Text(
                                            'Print',
                                            textScaleFactor: 1.5,
                                            style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                                          ),

                                        ],
                                      ))),

                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getData() async {
  SharedPreferences shared=await SharedPreferences.getInstance();
  String myUrl = "https://seropos.app/connector/api/payment-methods";
  http.Response response = await http.get((Uri.parse(myUrl)), headers: {
    'Authorization':shared.getString("Authorization")??""
  });
  print(json.decode(response.body));
  return json.decode(response.body);
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
