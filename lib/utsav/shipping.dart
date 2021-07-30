import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Shipping extends StatefulWidget {
  double Ammount=0.0;
  double Balance=0.0;
  double Discountt =0.0;
  int Redeem =0;
  Shipping({Key? key,
    required this.Ammount,
    required this.Balance,
    required this.Discountt,
    required this.Redeem
  }) : super(key: key);

  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  var _isloading=false;
  double shipAmount=0.0;
  double packageAmount=0.0;
  String dropdownValue1 ='Driver Contact';
  bool isClickedAdd = true;
  bool isClickedCancel = true;
  String shippingCharge ='0';
  TextEditingController _shipChargeController = new TextEditingController();
  TextEditingController _packageChargeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late customer _customer;
  String totalAmounttype(){
    shipAmount =double.parse(_shipChargeController.text);
    if(_packageChargeController.text != ''){
      packageAmount =double.parse(_packageChargeController.text);
      double totalAmount = (widget.Ammount + shipAmount+packageAmount);
      setState(() {
        shippingCharge =totalAmount.toStringAsFixed(2);
      });
    }
    else{
      double totalAmount = (widget.Ammount + shipAmount);
      setState(() {
        shippingCharge =totalAmount.toStringAsFixed(2);
      });
    }

    return shippingCharge;
  }
  List<String> _charges =[];
  _ShippingState() {
    fetchData().then((val) => setState(() {
      _charges= val;
    }));
  }

  Future<List<String>> fetchData() async {
    Map data = await getData();
    List<String> charges =[];
    for(var i in data['data'])
    {
      charges.add(i['shipping_charges']);
      charges.add(i['packing_charge']);
      print(charges);
    }
    return charges;
  }

  Map input={};
  _sendData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("customer_id");
    var response = await http.put(
        Uri.parse("https://pos.sero.app/connector/api/sell/$id"), body: input,
        headers: {
          'Authorization':
          sharedPreferences.getString("Authorization") ?? ''
        }
    );
    print(response);
    _customer = customer.fromJson(json.decode(response.body));
    if (_customer.error != "null") {
      setState(() {
        _isloading = false;
      });
    }
    else {
      setState(() {
        _isloading = false;
        print(_customer.id);
        _charges.clear();
        print(_charges);
      });
      setState(() {
        _isloading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(Ammount:widget.Ammount , Balance:double.parse(shippingCharge),
              Discountt: widget.Discountt, Redeem: widget.Redeem ,),
          ));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 110),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:_isloading?Center(
            child: CircularProgressIndicator(color: Color(0xff000066),)):
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            child: Container(
                height: 550,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text('ADD SHIPPING',
                            style: GoogleFonts.ptSans(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15,left: 50,bottom: 8),
                              child: Text('Shipping Cost',
                                style: GoogleFonts.ptSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:4,left: 45,bottom: 20,right: 45),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the shipping cost';
                                }
                                return null;
                              },
                              controller: _shipChargeController,
                              keyboardType:TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.white, filled: true,
                                errorStyle:
                                GoogleFonts.ptSans(color: Color(0xFFFFD45F),fontSize: 12,fontWeight: FontWeight.bold),

                                prefix:  Text('\$'),
                                hintText: 'Enter Shipping Cost here',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15,left: 50,bottom: 8),
                              child: Text('Packaging Cost',
                                style: GoogleFonts.ptSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:4,left: 45,bottom: 20,right: 45),
                          child: TextFormField(
                            controller: _packageChargeController,
                            keyboardType:TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: Colors.white, filled: true,
                              prefix:  Text('\$'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color:Colors.brown),
                              ),
                              hintText: 'Enter Packaging Cost here',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color:Colors.brown),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15,left: 50,bottom: 8),
                              child: Text('Select Driver',
                                style: GoogleFonts.ptSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:4,bottom: 20),
                          child: Container(
                            height: 40,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,
                                  left: 25),
                              child: DropdownButton<String>(
                                value: dropdownValue1,
                                items: [
                                  DropdownMenuItem(
                                    value: 'Driver Contact',
                                    child: Text('Ramesh - 9804048393'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Driver Contact1',
                                    child: Text('Suresh - 9804048393'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Driver Contact2',
                                    child: Text('Manish - 9804048393'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Driver Contact3 ',
                                    child: Text('Hari - 9804048393'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue1 = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('Ship',
                                    style: GoogleFonts.ptSans(fontSize: 30,fontWeight: FontWeight.bold),
                                  ),
                                  ),

                                  decoration: BoxDecoration(
                                    color:Color(0xFFFFD45F),
                                    borderRadius: BorderRadius.circular(45),

                                  ),
                                  height: 60,
                                  width: 130,
                                ),
                                onTap: (){
                                  input={
                                    'shipping_charges':_shipChargeController.text.toString(),
                                    'packing_charge':_packageChargeController.text.toString()
                                  };
                                  setState(() {
                                    if(_formKey.currentState!.validate()){
                                      _sendData();
                                    totalAmounttype();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PaymentScreen(Ammount:widget.Ammount , Balance:double.parse(shippingCharge), Discountt: widget.Discountt, Redeem: widget.Redeem ,)),
                                    );}
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  child:Center(child: Text('Cancel',style: GoogleFonts.ptSans(fontSize: 30,fontWeight: FontWeight.bold),
                                  ),

                                  ),
                                  decoration: BoxDecoration(
                                    color:  Color(0xFFFFD45F),
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
Future<Map<String, dynamic>> getData() async {
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
   var id = sharedPreferences.getString("customer_id");
   print(id);

  String myUrl = "https://pos.sero.app/connector/api/sell/$id";
  http.Response response = await http.get(Uri.parse(myUrl), headers: {
    'Authorization':
    sharedPreferences.getString("Authorization") ?? ''
  });
  return json.decode(response.body);
}
class customer
{
  final String error;
  final String id;
  customer.fromJson(Map<String,dynamic> Json):
        this.error=Json["error"].toString(),
        this.id=Json["id"].toString();
}
