import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/redeem.dart';
import 'package:flutter_nav_bar/utsav/shipping.dart';
import 'package:flutter_nav_bar/utsav/split_payment.dart';
import 'package:flutter_nav_bar/utsav/discount.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
        widget.Balance = (widget.Balance + tipAmount)
            : widget.Balance = (widget.Balance - tipAmount);
      });
    }

    return widget.Balance.toStringAsFixed(2);
  }

  List<String> _payMeth = ["", "", "", "", "",];

  _PaymentScreenState() {
    fetchData().then((val) =>
        setState(() {
          _payMeth = val;
        }));
  }

  Future<List<String>> fetchData() async {
    Map data = await getData();
    List<String> paymentMethod = [
      data['cash'],
      data['card'],
      data['cheque'],
      data['bank_transfer'],
      data['other'],
    ];
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
                                              '\$'+widget.Discountt.toStringAsFixed(2),
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
                                            widget.Redeem.toString(),
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
                                                widget.Redeem.toString(),
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
    print("PRINT IN BUILD"+widget.Balance.toStringAsFixed(2));
    int _counter = 1;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    // paymentAmount=widget.Ammount;
    return Scaffold(
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
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return Discount(Ammount: widget.Ammount, Balance:widget.Balance , Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      ).then((value){
                                        setState(() {
                                          widget.Balance=shared.getDouble("Balance")!;
                                          print("PRINT:"+widget.Balance.toString());
                                        });
                                      });

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
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return SplitPay(Ammount: widget.Ammount,);
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
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return RedeemPoint(Ammount: widget.Ammount,
                                              Balance: widget.Ammount,
                                              Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      );
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
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return Shipping(Ammount: widget.Ammount, Balance: widget.Balance,
                                              Discountt: widget.Discountt, Redeem: widget.Redeem,);
                                          }
                                      );
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
              height: 170 ,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child:Center(
                                    child: _payMeth[0].length>6 ?
                                    Text(
                                      _payMeth[0].substring(0,6),
                                      style: GoogleFonts.ptSans(
                                        fontWeight:FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ):Text(
                                      _payMeth[0],
                                      style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
                                    ),
                                  ),
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
                                  height: 45,
                                  width: 100,
                                ),
                                onTap: (){
                                  setState(() {
                                    isClicked1 =! isClicked1;
                                    isClicked2 = true;
                                    isClicked3 = true;
                                    isClicked4 = true;
                                    isClicked5=true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child:Center(
                                    child: _payMeth[1].length>6 ?
                                    Text(
                                      _payMeth[1].substring(0,6),
                                      style: GoogleFonts.ptSans(
                                        fontWeight:FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ):Text(
                                      _payMeth[1],
                                      style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isClicked2 ? Colors.white : Color(0xFFFFD45F),
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
                                  height: 45,
                                  width: 100,
                                ),
                                onTap: (){
                                  setState(() {
                                    isClicked2 =! isClicked2;
                                    isClicked1 = true;
                                    isClicked3 = true;
                                    isClicked4 = true;
                                    isClicked5=true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child:Center(
                                    child: _payMeth[2].length>6 ?
                                    Text(
                                      _payMeth[2].substring(0,6),
                                      style: GoogleFonts.ptSans(
                                        fontWeight:FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ):Text(
                                      _payMeth[2],
                                      style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isClicked3 ? Colors.white : Color(0xFFFFD45F),
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
                                  height: 45,
                                  width: 100,
                                ),
                                onTap: (){
                                  setState(() {
                                    isClicked3 =! isClicked3;
                                    isClicked2 = true;
                                    isClicked4 = true;
                                    isClicked1 = true;
                                    isClicked5=true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:10),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child:Center(
                                    child: _payMeth[3].length>6 ?
                                    Text(
                                      _payMeth[3].substring(0,6),
                                      style: GoogleFonts.ptSans(
                                        fontWeight:FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ):Text(
                                      _payMeth[3],
                                      style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isClicked4 ? Colors.white : Color(0xFFFFD45F),
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
                                  height: 45,
                                  width: 100,
                                ),
                                onTap: (){
                                  setState(() {
                                    isClicked4 =! isClicked4;
                                    isClicked2 = true;
                                    isClicked3= true;
                                    isClicked1 = true;
                                    isClicked5=true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Container(
                              child: GestureDetector(
                                child: Container(
                                  child:Center(
                                    child: _payMeth[4].length>6 ?
                                    Text(
                                      _payMeth[4].substring(0,6),
                                      style: GoogleFonts.ptSans(
                                        fontWeight:FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ):Text(
                                      _payMeth[4],
                                      style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 18),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isClicked5 ? Colors.white : Color(0xFFFFD45F),
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
                                  height: 45,
                                  width: 100,
                                ),
                                onTap: (){
                                  setState(() {
                                    isClicked5 =! isClicked5;
                                    isClicked2 = true;
                                    isClicked3= true;
                                    isClicked1 = true;
                                    isClicked4=true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
                      // Container(
                      //   child: InkWell(
                      //     onTap:() async {
                      //       print('haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaaa');
                      //       List<Map<String,dynamic>> list_of_m=[];
                      //       SharedPreferences shared=await SharedPreferences.getInstance();
                      //       var variation=shared.getStringList("variation");
                      //       var cart=FlutterCart();
                      //       for(int index=0;index<cart.cartItem.length;index++)
                      //         {
                      //
                      //           Map<String,dynamic> product={
                      //             "product_id":double.parse(cart.cartItem[index].productId),
                      //             "variation_id":double.parse(variation![index]),
                      //             "quantity": cart.cartItem[index].quantity,
                      //             "unit_price": cart.cartItem[index].unitPrice*cart.cartItem[index].quantity,
                      //           };
                      //           list_of_m.add(product);
                      //           // print(list_of_m);
                      //         }
                      //        if(shared.containsKey("modifiers")){
                      //          if(shared.getString("modifiers")!=""){
                      //         List<dynamic> mod =json.decode(shared.getString("modifiers")?? "");
                      //         print(mod[0]);
                      //         for(int i =0;i<mod.length;i++){
                      //           list_of_m.add(mod[0]);
                      //           // print(mod[0]["name"]);
                      //         }}}
                      //
                      //       print(list_of_m);
                      //       if(shared.getInt("order_id")==0)
                      //       {
                      //         Map<String,dynamic> api= {
                      //           "sells":[
                      //             {
                      //               "table_id" :shared.getInt("table_id")??0,
                      //               "location_id": shared.getInt("bid")??1,
                      //               "contact_id": double.parse(shared.getString("customer_id")??""),
                      //               // "status": "draft",
                      //               "is_suspend": 1,
                      //               "products":list_of_m,
                      //               "payments": [
                      //                 {
                      //                   "amount":cart.getTotalAmount(),
                      //                 }
                      //               ]
                      //             }
                      //           ]
                      //         };
                      //         var dio=Dio();
                      //         dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                      //         var r=await dio.post("https://pos.sero.app/connector/api/sell",data: json.encode(api));
                      //         print(r);
                      //         var v=r.data[0]["id"];
                      //         print(v.toString());
                      //         shared.setInt("order_id", v);
                      //
                      //         Fluttertoast.showToast(
                      //             msg: "Order on hold and Your Order Id is $v",
                      //             toastLength: Toast.LENGTH_LONG,
                      //             gravity: ToastGravity.BOTTOM,
                      //             textColor: Colors.green,
                      //             timeInSecForIosWeb: 4);
                      //       }
                      //       shared.setString("modifiers", '');
                      //       shared.setStringList("selectedmodifiers", []);
                      //       shared.setStringList("selectedmodifiersprice", []);
                      //       cart.deleteAllCart();
                      //       shared.clear();
                      //
                      //       setState(() {
                      //         shared.setString("customer_name", '');
                      //         shared.setString("table_name", '');
                      //         // get("");
                      //       });
                      //     },
                      //     child: Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(35),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey,
                      //               offset: const Offset(
                      //                 1.0,
                      //                 1.0,
                      //               ), //Offset
                      //               blurRadius: 6.0,
                      //               spreadRadius: 2.0,
                      //             ), //BoxShadow
                      //             BoxShadow(
                      //               color: Colors.white,
                      //               offset: const Offset(0.0, 0.0),
                      //               blurRadius: 0.0,
                      //               spreadRadius: 0.0,
                      //             ),],
                      //           color :Color(0xFFFFD45F),
                      //         ),
                      //         margin: EdgeInsets.only(top: 10),
                      //         width: 100,
                      //         height: 45,
                      //         child: Center(
                      //             child:Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(Icons.pause_outlined),
                      //                 Text(
                      //                   'Hold',
                      //                   textScaleFactor: 1.5,
                      //                   style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                      //                 ),
                      //
                      //               ],
                      //             ) )),
                      //
                      //   ),
                      // ),
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
                            dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
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

                            if(shared.getInt("order_id")==0)
                            {
                              Map<String,dynamic> api= {
                                "sells":[
                                  {
                                    "table_id" :shared.getInt("table_id")??0,
                                    "location_id": shared.getInt("bid")??1,
                                    "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                    //"status": "draft",
                                    "products":list_of_m,
                                    "payments": [
                                      {
                                        "amount":widget.Balance,
                                      }
                                    ]
                                  }
                                ]
                              };
                              var dio=Dio();
                              dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                              var r=await dio.post("https://pos.sero.app/connector/api/sell",data: json.encode(api));
                              print(r.data);
                              var v=r.data[0]["id"];
                              print(v.toString());
                              shared.setInt("order_id", v);
                              shared.setInt("index",0);
                              shared.setInt("PAY_HOLD",1);
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
                              Map<String,dynamic> api= {
                                "products":list_of_m,
                                "payments": [
                                  {
                                    "amount":widget.Balance,
                                  }
                                ],

                                "is_suspend": 0,
                              };
                              print(json.encode(api));

                              var dio=Dio();
                              var vid = shared.getInt("order_id");
                              dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                              print(vid);
                              var r=await dio.put("https://pos.sero.app/connector/api/sell/$vid",data: json.encode(api));
                              print("hahah");
                              print(r.data);
                              var v=r.data["id"];
                              print(v.toString());
                              shared.setInt("order_id", v);
                              cart.deleteAllCart();
                              shared.clear();

                              setState(() {
                                shared.setString("total","0");
                                shared.setInt("index", 0);
                                shared.setInt("PAY_HOLD",1);
                              });

                              Fluttertoast.showToast(
                                  msg: "Payment Successful and Your Order Id is $v",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.green,
                                  timeInSecForIosWeb: 4);



                            }



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
                            SharedPreferences shared =await SharedPreferences.getInstance();
                            var id = shared.getInt("table_id",);
                            print(shared.getInt("table_id"));
                            setState(() {
                              _isloading=true;
                            });
                            Map<String,dynamic> api1={
                              "table_id":id,
                              "table_status":"billing"
                            };
                            var dio = Dio();
                            dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
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
      bottomSheet:_currentIndex == 3 ? new Container(
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
                  onPressed:(){
                    setState(() {
                    });
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
                  onPressed:(){
                    setState(() {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  PaymentScreen(Ammount: widget.Ammount, Balance: widget.Balance,
                          Discountt: widget.Discountt, Redeem: widget.Redeem,)),
                      );
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
      ):null ,
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
  String myUrl = "https://pos.sero.app/connector/api/payment-methods";
  http.Response response = await http.get((Uri.parse(myUrl)), headers: {
    'Authorization':
    'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjlhNTYwNGYxZDAxMzU2NTRhY2YyYjE4MmEyOGUwMjA4M2QxOGUxY2Y1ZTY0MzM1MzdmNzc3MzFkMTMzZjNmNWQ5MTU3ZTEwOTQ5NDE3ZmQ3In0.eyJhdWQiOiIzIiwianRpIjoiOWE1NjA0ZjFkMDEzNTY1NGFjZjJiMTgyYTI4ZTAyMDgzZDE4ZTFjZjVlNjQzMzUzN2Y3NzczMWQxMzNmM2Y1ZDkxNTdlMTA5NDk0MTdmZDciLCJpYXQiOjE2MjM2NjAxMzksIm5iZiI6MTYyMzY2MDEzOSwiZXhwIjoxNjU1MTk2MTM5LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.WGLAu9KVi-jSt0q9yUyENDoEQnSLF1o0tezej5YozBFXJVQuEvSykvA9T6nnJghujQ2uU-nxUCRftLBhYzGjsu26YoKZBin70k1cqoYDfIWlVZ-fNkJi1vAXYOk9Pzxz7YFBa6hgz1MyUlDOI1LsSSsJh87hGBzIN6Ib_cYmGoo8KHVEfqbDtCNnZdOq68vjhwf6dwYEJUtxanaocuC-_XHkdM7769JiO48Ot93BqZjmRuVwvK9zE_8bilmhktlgD65ahgKOSS2yQlMdpgpsqP1W5Mfy_SBu32BkqTpAc5v2QWRTVhevES-blsfqdoZ59aw0OzrxyC8PvipyuhGQjs6V7eCrKK0jOei9g4RyhKlQueDXxxrWrqsStIsPzkn-kXA5k2NINIFgr2MlLtypTR76xnncWE5rCqm39K5V2_q3aXDQvCHdl3SVBKDqwNCUKq1CxbJlkF8r1R1mxXxN76TBZbcalO7wUX0F-D1j9oWkwXSZBe7L6vQQqvhC2AsQO2LB4QiByuFi1-J4h05vM3Kab0nmRvVeNYekhNP9HtTGWCH_UDuiDAp23VqUhMTrFygUAPEASU0fnw-rMKhrll_O0wMaBE33ZfItsV0o6pHCQhUjsDKwfmgVynOyYu0rX_huVN_PUBSYQVuCiabUMp8Q5Dv7n8Ky7_yI8XypQK4'
  });
  return json.decode(response.body);
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


