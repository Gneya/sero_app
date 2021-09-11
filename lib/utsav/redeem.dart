import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemPoint extends StatefulWidget {
  double Ammount=0.0;
  double Balance=0.0;
  double Discountt =0.0;
  int Redeem =0;
  RedeemPoint({Key? key,
    required this.Ammount,
    required this.Balance,
    required this.Discountt,
    required this.Redeem
  }) : super(key: key);

  @override
  _RedeemPointState createState() => _RedeemPointState();
}

class _RedeemPointState extends State<RedeemPoint> {
  bool isClickedAdd = true;
  bool _isloading = false;
  bool isClickedCancel = true;
  int points=250;
  int redeemAmount =0;
  int redeemed=0;
  String redeemedAmount ='0';
  double balance=0.0;
  var pt =0;
  final pointscontroller= new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<String> totalAmounttype()async{
    // SharedPreferences shared = await SharedPreferences.getInstance();
    // balance =shared.getDouble("Balance")!;
    // print("hellllllllllllllllllllllllllllllllllllllll"+balance.toString());
    redeemAmount =int.parse(pointscontroller.text) ;
    double totalAmount = (widget.Balance - redeemAmount);
    setState(() {
      redeemedAmount =totalAmount.toStringAsFixed(2);
    });
    return redeemedAmount;
  }
  int Redeemed(){
    redeemed =int.parse(pointscontroller.text);
    return redeemed;
  }
  getPoints() async {
    setState(() {
      _isloading =true;
    });
    var dio=Dio();
    SharedPreferences shared = await SharedPreferences.getInstance();
    var  cid = shared.getString("customer_id");
    dio.options.headers["Authorization"]=shared.getString("Authorization");
    print(cid);
    var r=await dio.get("https://seropos.app/connector/api/contactapi/$cid");
    print(r.data);
    pt =r.data["data"][0]["total_rp"];

    setState(() {
      _isloading =false;
    });
  }
  @override
  void initState() {
    getPoints();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 90),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            child: Container(
                height: 500,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('$pt POINTS',
                          style: GoogleFonts.ptSans(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold
                          ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40,top: 20),
                              child: Text('Redeem Points',
                                style: GoogleFonts.ptSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                ),),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,left: 30,right: 20),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter points to be redeemed';
                                }
                                return null;
                              },
                              controller: pointscontroller,
                              keyboardType:TextInputType.number,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.ptSans(color: Color(0xFFFFD45F),fontWeight: FontWeight.bold,fontSize: 12),
                                  fillColor: Colors.white, filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color:Colors.brown),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color:Colors.brown),
                                  ),
                                  hintText: 'How many Points to Redeem'
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40,top: 20),
                              child: Text('Coupon Code',
                                style: GoogleFonts.ptSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                ),),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,left: 30,right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color:Colors.brown),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color:Colors.brown),
                                ),
                                hintText: 'Enter Coupon Code',
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 130),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('Add',
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
                                  SharedPreferences shared =await SharedPreferences.getInstance();
                                  setState(() {
                                    if(_formKey.currentState!.validate()) {
                                      totalAmounttype();
                                      Redeemed();
                                      shared.setDouble("Ammount",widget.Ammount );
                                      shared.setDouble("Balance", double.parse(redeemedAmount));
                                      shared.setInt("Redeemed Points",redeemAmount);
                                      Navigator.of(context).pop(true);
                                    }
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('Cancel',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
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
    );;;
  }
}


