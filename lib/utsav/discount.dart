import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Discount extends StatefulWidget {
  double Ammount=0.0;
  double Balance=0.0;
  double Discountt =0.0;
  int Redeem =0;
  Discount({ Key? key,
    required this.Ammount,
    required this.Balance,
    required this.Discountt,
    required this.Redeem
  }) : super(key: key);

  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  double discountAmount =0.0;
  double discountted =0.0;
  bool isClickedDiscount= true;
  bool isClickedDiscountCash= true;
  bool isClicked1= true;
  bool isClicked2= true;
  bool isClicked3= true;
  bool isClicked4= true;
  bool isClickedAdd= true;
  bool isClickedCancel= true;
  bool _isloading =true;
  String  discountedAmount ='0';
  var num_list = ['5','10','15','20'];
  final _formKey = GlobalKey<FormState>();
  String dropdownValue ='Percentage %';
  final _amountController = new TextEditingController();
  String totalAmounttype(){
    discountAmount =double.parse(_amountController.text);
    if(dropdownValue=='Percentage %'){
      double totalAmount = (widget.Balance - (widget.Balance*discountAmount/100));
      setState(() {
        discountedAmount = totalAmount.toStringAsFixed(2);
      });}
    else{
      {
        setState(() {
          double totalAmount = (widget.Balance - discountAmount);
          discountedAmount = totalAmount.toStringAsFixed(2);
        });}
    }
    return discountedAmount;
  }
  double DiscountAmount()
  {
    discountted=double.parse(_amountController.text) ;
    if(dropdownValue=='Percentage %'){
      double totalAmount = (widget.Balance*discountAmount/100);
      setState(() {
        discountted = totalAmount;
      });}
    else{
      {
        double totalAmount = (discountAmount);
        setState(() {
          discountted = totalAmount;
        });}
    }
    return discountted;
  }
  // Future<void> getSharedPrefs() async {
  //   setState(() {
  //     _isloading =true;
  //   });
  //   SharedPreferences shared = await SharedPreferences.getInstance();
  //   shared.getDouble("Ammount");
  //   shared.getDouble("Balance");
  //   shared.getDouble("Discountt");
  //   shared.getInt("Redeem");
  //   setState(() {
  //     _isloading=false;
  //   });
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // getSharedPrefs();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 100),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            child: Container(
              height: 450,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color:Color(0xFFFFD45F) ,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            items: [
                              DropdownMenuItem(
                                value: 'Fixed',
                                child: Text('Fixed'),
                              ),
                              DropdownMenuItem(
                                value: 'Percentage %',
                                child: Text('Percentage %'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15,left: 50),
                    child: Text('Amount',
                      style: GoogleFonts.ptSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:4,left: 45,bottom: 20,right: 45),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount to be discounted';
                          }
                          return null;
                        },
                        controller: _amountController,
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.ptSans(color: Color(0xFFFFD45F),fontWeight: FontWeight.bold,fontSize: 12),
                          fillColor: Colors.white, filled: true,
                          prefix: dropdownValue =='Percentage %' ? Text('%') : Text('\$'),
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
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Container(
                          child:Center(child: dropdownValue =='Percentage %' ? Text(num_list[0]+'%',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                              fontSize: 18
                          ),
                          ):Text('\$'+num_list[0],style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                              fontSize: 18
                          ),
                          ),

                          ),
                          decoration: BoxDecoration(
                            color: isClicked1 ? Colors.white : Color(0xFFFFD45F),
                            borderRadius: BorderRadius.circular(15),

                          ),
                          height: 90,
                          width: 90,
                        ),
                        onTap: (){
                          setState(() {
                            isClicked1 =! isClicked1;
                            isClicked2 = true;
                            isClicked3 = true;
                            isClicked4 = true;
                            _amountController.text=num_list[0];
                          });
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          child:Center(child: dropdownValue =='Percentage %' ? Text(num_list[1]+'%',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                              fontSize: 18
                          ),
                          ):Text('\$'+num_list[1],style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                              fontSize: 18
                          ),
                          ),

                          ),
                          decoration: BoxDecoration(
                            color: isClicked2 ? Colors.white : Color(0xFFFFD45F),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 90,
                          width: 90,
                        ),
                        onTap: (){
                          setState(() {
                            isClicked2 =! isClicked2;
                            isClicked1 = true;
                            isClicked3 = true;
                            isClicked4 = true;
                            _amountController.text=num_list[1];
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Container(
                            child:Center(child: dropdownValue =='Percentage %' ? Text(num_list[2]+'%',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                                fontSize: 18
                            ),
                            ):Text('\$'+num_list[2],style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                                fontSize: 18
                            ),
                            ),

                            ),
                            decoration: BoxDecoration(
                              color: isClicked3 ? Colors.white : Color(0xFFFFD45F),
                              borderRadius: BorderRadius.circular(15),

                            ),
                            height: 90,
                            width: 90,
                          ),
                          onTap: (){
                            setState(() {
                              isClicked3 =! isClicked3;
                              isClicked2 = true;
                              isClicked4 = true;
                              isClicked1 = true;
                              _amountController.text=num_list[2];
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child:Center(child: dropdownValue =='Percentage %' ? Text(num_list[3]+'%',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                                fontSize: 18
                            ),
                            ):Text('\$'+num_list[3],style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                                fontSize: 18
                            ),
                            ),

                            ),
                            decoration: BoxDecoration(
                              color: isClicked4 ? Colors.white : Color(0xFFFFD45F),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 90,
                            width: 90,
                          ),
                          onTap: (){
                            setState(() {
                              isClicked4 =! isClicked4;
                              isClicked2 = true;
                              isClicked3= true;
                              isClicked1 = true;
                              _amountController.text=num_list[3];
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Container(
                          child:Center(child: Text('Add',
                            style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
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
                        onTap: () async {
                          SharedPreferences shared = await SharedPreferences.getInstance() ;
                          setState(() {
                            if(_formKey.currentState!.validate()){
                              totalAmounttype();
                              DiscountAmount();
                              shared.setDouble("Ammount",widget.Ammount );
                              shared.setDouble("Balance", double.parse(discountedAmount));
                              print("IN DISCOUNT SCREEN"+shared.getDouble("Balance").toString());
                              shared.setString("DiscountType",dropdownValue );
                              print(shared.getString("DiscountType"));
                              shared.setDouble("Discountt", discountted);
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
                ],
              ),
            ),
          ),
        )
    );
  }
}



