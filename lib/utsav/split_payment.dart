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
                      if(sum.toStringAsFixed(2)!= widget.Balance.toStringAsFixed(2)){
                        Fluttertoast.showToast(
                            msg: "Total amount must be equal to balance amount",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.green,
                            timeInSecForIosWeb: 4);
                      }
                      else
                      {
                        var dio=Dio();
                        List<Map<String,dynamic>> list_of_m=[];
                        List<Map<String,dynamic>> list_of_payment=[];
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
                        for(int i=0;i<items;i++){
                          Map<String,dynamic> payment1={
                            "amount":payment[i],
                            "method": paymentMode[i],
                          };
                          list_of_payment.add(payment1);
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

                        if(shared.getString("order_id")=="")
                        {

                          Map<String,dynamic> api= {
                            "sells":[
                              {
                                "table_id" :shared.getInt("table_id")??0,
                                "location_id": shared.getInt("bid")??1,
                                "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                "discount_amount": shared.getDouble("Discountt"),
                                "discount_type": shared.getString("DiscountType"),
                                "rp_redeemed": shared.getInt("Redeemed Points"),
                                "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString()),
                                // "shipping_details": null,
                                // "shipping_address": null,
                                // "shipping_status": null,
                                // "delivered_to": null,
                                "shipping_charges": shared.getDouble("Shipping"),
                                "products":list_of_m,
                                "payments":list_of_payment
                              }
                            ]
                          };
                          var dio=Dio();
                          dio.options.headers["Authorization"]=shared.getString("Authorization");
                          var r=await dio.post("https://seropos.app/connector/api/sell",data: json.encode(api));
                          print(r.data);
                          var v=r.data[0]["invoice_no"];
                          print(v.toString());
                          shared.setString("order_id", v);
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
                          Navigator.pop(context);

                        }
                        else{
                          print('haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaaa');
                          print(shared.getInt("Redeemed Points"));
                          Map<String,dynamic> api= {
                            "sells":[
                              {
                                "table_id" :shared.getInt("table_id")??0,
                                "location_id": shared.getInt("bid")??1,
                                "contact_id": double.parse(shared.getString("customer_id")??"1"),
                                "discount_amount": shared.getDouble("Discountt"),
                                "discount_type": shared.getString("DiscountType"),
                                "rp_redeemed": shared.getInt("Redeemed Points"),
                                "rp_redeemed_amount": double.parse(shared.getInt("Redeemed Points").toString())??0,
                                // "shipping_details": null,
                                // "shipping_address": null,
                                // "shipping_status": null,
                                // "delivered_to": null,
                                "shipping_charges": shared.getDouble("Shipping"),
                                "products":list_of_m,
                                "payments": list_of_payment
                              }
                            ]
                          };
                          print(json.encode(api));

                          var dio=Dio();
                          var vid = shared.getString("order_id");
                          dio.options.headers["Authorization"]=shared.getString("Authorization");
                          print(vid);
                          var r=await dio.put("https://seropos.app/connector/api/sell/$vid",data: json.encode(api));
                          print("hahah");
                          print(r.data);
                          var v=r.data["invoice_no"];
                          print(v);
                          shared.setString("order_id", v);
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
                          Navigator.pop(context);

                        }
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




