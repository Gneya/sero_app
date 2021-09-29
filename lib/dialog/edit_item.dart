import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
class edit_item extends StatefulWidget {
  String name;
  String quantity;
  String price;
  int index;
  edit_item({
    required this.name,
    required this.quantity,
    required this.price,
    required this.index,
  });
  @override
  _edit_item_State createState() => _edit_item_State();
}
class _edit_item_State extends State<edit_item> {
  double discountAmount =0.0;
  double discountted =0.0;
  String  discountedAmount ='0';
  String dropdownValue ='Percentage';
  TextEditingController _discount = TextEditingController();
  TextEditingController note = TextEditingController();
  var cart = FlutterCart();
  String editPrice(){
    var q = cart.cartItem[widget.index].quantity;
    var p =cart.cartItem[widget.index].unitPrice;
    var total =0.0;
    total =p*q;
    // print(total);
    print("000000000000000000");
    print(cart.cartItem[widget.index].productName);

    return total.toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    var dropdownValue1;
    return Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height/1.58,
            padding: EdgeInsets.all(8),
            child: (
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("EDIT ITEM",style: GoogleFonts.ptSans(fontSize: 18),),
                    ),
                    Container(
                      // height:MediaQuery.of(context).size.height/1.85,
                      child:Padding(
                        padding: const EdgeInsets.only(top: 10,left: 8,right: 7),
                        child: Container(
                          // height:MediaQuery.of(context).size.height/10 ,
                            padding: EdgeInsets.only(left:10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(
                                    0.0,
                                    0.3,
                                  ), //Offset
                                  blurRadius: 1.0,
                                  spreadRadius: 0.5,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(0.5, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),],
                            ),
                            child:Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/2.8,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(
                                          widget.name,
                                          style: GoogleFonts.ptSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.,
                                      children: [
                                        IconButton(
                                          onPressed:(){
                                            setState(() {
                                              var c=int.parse(widget.quantity);
                                              if( c>1)
                                                c--;
                                              var cart = FlutterCart();
                                              cart.decrementItemFromCart(widget.index);
                                              widget.quantity=c.toString();
                                              //saveState();
                                            });
                                          },
                                          icon: Icon(Icons.remove_circle,
                                            size: 17,),
                                        ),
                                        Text(widget.quantity,
                                          style: GoogleFonts.ptSans(
                                              fontSize: 12
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:(){
                                            setState(() {
                                              var c=int.parse(widget.quantity);
                                              c++;
                                              var cart = FlutterCart();
                                              cart.incrementItemToCart(widget.index);
                                              widget.quantity=c.toString();
                                              //saveState();
                                            });
                                          },
                                          icon: Icon(Icons.add_circle_outlined,
                                            size: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width/9,
                                        child:Text(
                                          cart.cartItem[widget.index].subTotal.toString(),
                                          style: GoogleFonts.ptSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )),
                                  ],
                                ),
                              ] ,
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height:30 ,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width/2.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(
                                    0.0,
                                    0.3,
                                  ), //Offset
                                  blurRadius: 1.0,
                                  spreadRadius: 0.5,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(0.5, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),],
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              items: [
                                DropdownMenuItem(
                                  value: 'Fixed',
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Fixed'),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Percentage',
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Percentage'),
                                  ),
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
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width/2.6,
                          child: TextField(
                            controller: _discount,
                            enableInteractiveSelection: false,
                            keyboardType:TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0.00',
                              hintStyle: TextStyle(
                                  color: Colors.grey
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
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 150,
                      width: 320,
                      child: TextField(
                        maxLines: 10,
                        enableInteractiveSelection: false,
                        controller: note,
                        decoration: InputDecoration(
                          hintText: 'Cooking Instruction',
                          hintStyle: TextStyle(
                              color: Colors.grey
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color:Colors.grey,width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color:Colors.grey,width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child: GestureDetector(
                        child: Container(
                          child:Center(child: Text('DONE',style: GoogleFonts.ptSans(fontWeight:FontWeight.bold,
                              fontSize: 18
                          ),
                          ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD45F),
                            borderRadius: BorderRadius.circular(45),
                          ),
                          height: 40,
                          width: 130,
                        ),
                        onTap :() async {
                          SharedPreferences shared = await SharedPreferences.getInstance();
                          setState(()  {
                            if(dropdownValue == "Fixed"){
                              cart.cartItem[widget.index].unitPrice-= double.parse(_discount.text);
                              print(cart.cartItem[widget.index].unitPrice);
                              cart.addToCart(productId: cart.cartItem[widget.index].productId, unitPrice: cart.cartItem[widget.index].unitPrice
                                  ,productName: cart.cartItem[widget.index].productName);
                              print(cart.cartItem[widget.index].subTotal);
                            }
                            print(cart.getTotalAmount().toString());
                            cart.cartItem[widget.index].productDetails=note.text;
                            print(cart.cartItem[widget.index].productDetails);
                          });
                          List<dynamic> list_of_products=[];
                          list_of_products=json.decode(shared.getString("products")!);
                          for(int i=0;i<list_of_products.length;i++)
                          {
                            if(list_of_products[i]["pid"]==cart.cartItem[widget.index].productId)
                            {
                              list_of_products[i]["note"]=note.text;
                            }
                          }
                          print(list_of_products);
                          shared.setString("products", json.encode(list_of_products));
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
            ),
          ),
        ));
  }
}
