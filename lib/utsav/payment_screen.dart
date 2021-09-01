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

class PaymentScreen extends StatefulWidget {
  double Ammount=0.0;
  double Balance=0.0;
  double Discountt =0.0;
  int Redeem =0;
  PaymentScreen({ Key? key,
    required this.Ammount
    ,required this.Balance,
    required this.Discountt,
    required this.Redeem}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static double paymentAmount = 0;
  var size, height, width;
  double tipAmount = 0.0;
  String toBePaid = '0';
  int _currentIndex = 0;
  bool isClicked1 = false;
  bool isClicked2 = true;
  bool isClicked3 = true;
  bool isClicked4 = true;
  bool isClicked5 = true;
  bool value = false;
  bool isEnabled = false;
  bool isEnabledBalance = false;
  bool _isloading = false;
  String table_name = '';
  final _tipController = new TextEditingController();
  List<String> paymentMethod =[];
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

  _PaymentScreenState() {
    fetchData().then((val) =>
        setState(() {
          print(val);
          _payMeth = val;
          print(_payMeth);
        }));
  }

  Future<List<String>> fetchData() async {
    /*
     payment mode values are not showing on the screen whenever below values are used or not commented
    */

    Map data = await getData();
    amount=widget.Ammount;
    balance=widget.Balance;
    redeem=widget.Redeem;
    paymentMethod = [
      data['cash'],
      data['card'],
      data['cheque'],
      data['Reward Points'],
      data['other'],
      data['custom_pay_1'],
      data['custom_pay_2'],
      data['custom_pay_3'],
      data['custom_pay_4'],
      data['custom_pay_5'],
      data['custom_pay_6'],
      data['custom_pay_7'],
    ];
    print(paymentMethod[1]);
    return paymentMethod;
  }
  Future<void> getSharedPrefs() async {
    setState(() {
      _isloading =true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    table_name =prefs.getString("table_name")??"";
    setState(() {
      _isloading =false;
    });
  }
  Widget selectPaymentMode(){
    if(isClicked1 ==false){
      return Container(
        height: 320 ,
        color:Colors.white,
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
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
                                  width: MediaQuery.of(context).size.width,
                                  child: TextField(
                                    enableInteractiveSelection: false,
                                    focusNode: new AlwaysDisabledFocusNode(),
                                    keyboardType:TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '\$'+widget.Ammount.toStringAsFixed(2),
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
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey,
                                        //     offset: const Offset(
                                        //       1.0,
                                        //       1.0,
                                        //     ), //Offset
                                        //     blurRadius: 6.0,
                                        //     spreadRadius: 2.0,
                                        //   ), //BoxShadow
                                        //   BoxShadow(
                                        //     color: Colors.white,
                                        //     offset: const Offset(0.0, 0.0),
                                        //     blurRadius: 0.0,
                                        //     spreadRadius: 0.0,
                                        //   ),],
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
              )
            ],
          ),
        ),
      );
    }




    else if(isClicked2==false){
      return  Container(
          height: 320 ,
          color:Colors.white,
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
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
                                      child: TextField(
                                        enableInteractiveSelection: false,
                                        focusNode: new AlwaysDisabledFocusNode(),
                                        keyboardType:TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '\$'+paymentAmount.toStringAsFixed(2),
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
            ),)
      );
    }
    else if(isClicked3==false){
      return Container(
        height: 300,
        child: Center(
          child: Text('Cheque Service not started yet'),
        ),
      );
    }
    else if(isClicked4==false){
      return Container(
        height: 300,
        child: Center(
          child: Text('Bank Transfer  Service not started yet'),
        ),
      );
    }
    else if(isClicked5==false){
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

  // Future<double> getPD() async {
  //     SharedPreferences shared = await SharedPreferences.getInstance();
  //       widget.Ammount = shared.getDouble("Ammount")!;
  //       widget.Balance= shared.getDouble("Balance")!;
  //       widget.Discountt =shared.getDouble("Discountt")!;
  //       widget.Redeem =shared.getInt("Redeem")??0;
  //       print(widget.Ammount);
  //       print(widget.Balance);
  //       return widget.Balance;
  //       // print(widget.Discountt);
  //  }
  @override
  void initState() {
    fetchData();
    getSharedPrefs();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    //print("this is build");
    print("PRINT IN BUILD"+balance.toStringAsFixed(2));
    int _counter = 1;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    // paymentAmount=widget.Ammount;
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
              var r2=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api1));
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
                height:180,
                child:Padding(
                  padding: const EdgeInsets.only(top:30),
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
                        padding: EdgeInsets.only(top: 8),
                        //width: MediaQuery.of(context).size.width,
                        child:  Padding(
                          padding: const EdgeInsets.only(top: 15,),
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
        toolbarHeight: 170,
        backgroundColor: Colors.white,
      ),
      body:_isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)): SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: width,
              color:Colors.white54,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PAYMENT MODE',
                            style: GoogleFonts.ptSans(
                                fontSize: 18,fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    Container(
                      height: 140,
                      child:  SingleChildScrollView(
                        child: Wrap(
                          children: paymentMethod.map((f) => GestureDetector(
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  minWidth: 100,
                                  maxHeight: 50,
                                  maxWidth: 100),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                color: isClicked1 ? Colors.white : Color(0xFFFFD45F),
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

                            },
                          ))
                              .toList(),
                        ),
                      ),
                    ) ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30),
              color:Colors.white,
              child: Divider(
                height: 0,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ),
            selectPaymentMode(),
            Container(
              color:Colors.white,
              padding: EdgeInsets.only(left: 30,right: 30),
              child: Divider(
                height: 0,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: this.isEnabled,
                      activeColor: Color(0xFFFFD45F),
                      onChanged: (value) {
                        setState(() {
                          if(isClicked2==false)
                          {
                            if( _Key.currentState!.validate())
                            {
                              this.isEnabled = value!;
                              totalAmount();
                            }
                          }
                          else if(isClicked1 ==false){
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
                            var id = shared.getInt("table_id",);
                            print(shared.getInt("table_id"));
                            Map<String,dynamic> api1={
                              "table_id":id,
                              "table_status":"available"
                            };
                            dio.options.headers["Authorization"]=shared.getString("Authorization");
                            var r2=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api1));
                            print(r2);
                            print(id);
                            var variation=shared.getStringList("variation");
                            var cart=FlutterCart();
                            for(int index=0;index<cart.cartItem.length;index++)
                            {

                              Map<String,dynamic> product={
                                "product_id":double.parse(cart.cartItem[index].productId.toString()),
                                "variation_id":double.parse(variation![index]),
                                "quantity": cart.cartItem[index].quantity,
                                "unit_price": cart.cartItem[index].unitPrice*cart.cartItem[index].quantity,
                              };
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
                             print (dar);

                            if(shared.getString("order_id")=="")
                            {

                              Map<String,dynamic> api= {
                                "sells":[
                                  {
                                    "table_id" :shared.getInt("table_id")??0,
                                    "location_id": shared.getInt("bid")??1,
                                    "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                    "discount_amount": discountt,
                                    "discount_type": dar,
                                    "rp_redeemed": shared.getInt("Redeemed Points"),
                                    "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString()),
                                    // "shipping_details": null,
                                    // "shipping_address": null,
                                    // "shipping_status": null,
                                    // "delivered_to": null,
                                    "shipping_status":"offline",
                                    "types_of_service_id":sar,
                                    "is_suspend":0,
                                    "shipping_charges": shared.getDouble("Shipping"),
                                    "products":list_of_m,
                                    "tip":_tipController.text,
                                    "payments": [
                                      {
                                        "amount":cart.getTotalAmount()
                                      }
                                    ]
                                  }
                                ]
                              };
                              var dio=Dio();
                              dio.options.headers["Authorization"]=shared.getString("Authorization");
                              var r=await dio.post("https://pos.sero.app/connector/api/sell",data: json.encode(api));
                              print(r.data);
                              // var y =r.data["id"];
                              var v=r.data[0]["invoice_no"];
                              print(v.toString());
                              shared.setString("order_id", v);
                              shared.setInt("index",0);
                              shared.setInt("PAY_HOLD",1);
                              shared.setDouble("Shipping", 0.0);
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
                              print(shared.getInt("Redeemed Points"));
                              Map<String,dynamic> api=
                              {
                                "sells":[
                              {
                              "table_id": shared.getInt("table_id") ?? 0,
                              "location_id": shared.getInt("bid") ?? 1,
                              "contact_id": double.parse(shared.getString("customer_id") ?? "1"),
                              "discount_amount": discountt,
                              "discount_type": shared.getString("DiscountType"),
                              "tip":_tipController.text,
                              "is_suspend":0,
                              "rp_redeemed": shared.getInt("Redeemed Points"),
                              "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString()) ?? 0,
                              // "shipping_details": null,
                              // "shipping_address": null,
                              // "shipping_status": null,
                              // "delivered_to": null,
                              "shipping_charges": shared.getDouble("Shipping"),
                                "types_of_service_id":sar,
                                "shipping_status":"offline",
                              "products": list_of_m,
                              "payments": [
                              {
                              "amount": cart.getTotalAmount()
                              }
                              ]
                              }
                                ]

                              };
                              print(json.encode(api));

                              var dio=Dio();
                              var vid = shared.getString("order_id".toString());
                              dio.options.headers["Authorization"]=shared.getString("Authorization");
                              print(vid);
                              var r=await dio.put("https://pos.sero.app/connector/api/sell/$vid",data: json.encode(api));
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
                            var r=await dio.get("https://pos.sero.app/connector/api/sell/$oid");
                            print(oid);
                            print(r.data['data'][0]['invoice_token']);
                            var  url = "https://pos.sero.app/invoice/"+r.data['data'][0]['invoice_token'];
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
                            var r2=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api1));
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
          ],
        ),
      ),
      // bottomSheet:_currentIndex == 3 ? new Container(
      //   height: 70,
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey,
      //         offset: const Offset(
      //           1.0,
      //           1.0,
      //         ), //Offset
      //         blurRadius: 6.0,
      //         spreadRadius: 2.0,
      //       ), //BoxShadow
      //       BoxShadow(
      //         color: Colors.white,
      //         offset: const Offset(0.0, 0.0),
      //         blurRadius: 0.0,
      //         spreadRadius: 0.0,
      //       ),],
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed:(){
      //               setState(() {
      //               });
      //             },
      //             iconSize: 25,
      //             icon: Icon(Icons.table_chart_outlined,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //           Text('Tables',
      //             style: GoogleFonts.ptSans(
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey[800],
      //             ),)
      //         ],
      //       ),
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed:(){
      //               setState(() {
      //               });
      //             },
      //             iconSize: 29,
      //             icon: Icon(Icons.play_arrow_sharp,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //           Text('Resume',
      //             style: GoogleFonts.ptSans(
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey[800],
      //             ),
      //           )
      //         ],
      //       ),Column(
      //         children: [
      //           IconButton(
      //             onPressed:(){
      //               showDialog(
      //                   context: context,
      //                   builder: (context){
      //                     return VoidBill();
      //                   }
      //               );
      //             },
      //             iconSize: 25,
      //             icon: Icon(Icons.delete,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //           Text('Void',
      //             style: GoogleFonts.ptSans(
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey[800],
      //             ),)
      //         ],
      //       ),Column(
      //         children: [
      //           IconButton(
      //             onPressed:(){
      //               setState(() {
      //               });
      //             },
      //             iconSize: 25,
      //             icon: Icon(Icons.clear_all_sharp,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //           Text('Clear',
      //             style: GoogleFonts.ptSans(
      //               fontWeight: FontWeight.bold,
      //               color: Colors.grey[800],
      //             ),)
      //         ],
      //       ),
      //       Column(
      //         children: [
      //           IconButton(
      //             onPressed:(){
      //               setState(() {
      //                 Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) =>  PaymentScreen(Ammount: widget.Ammount, Balance: widget.Balance,
      //                     Discountt: widget.Discountt, Redeem: widget.Redeem,)),
      //                 );
      //               });
      //             },
      //             iconSize: 40,
      //             icon: Icon(Icons.keyboard_arrow_down_outlined,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //         ],
      //       ),
      //
      //     ],
      //   ),
      // ):null ,
    );
  }

  void testmethod() async {
    SharedPreferences indexData = await SharedPreferences.getInstance();
    _currentIndex = indexData.getInt('index')!;
  }

  // Future<void> changeValue() async {
  //   SharedPreferences shared=await SharedPreferences.getInstance();
  //   setState(() {
  //     widget.Balance=shared.getDouble("Balance")!;
  //   });
  // }
}

Future<Map<String, dynamic>> getData() async {
  SharedPreferences shared=await SharedPreferences.getInstance();
  String myUrl = "https://pos.sero.app/connector/api/payment-methods";
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


