import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:google_fonts/google_fonts.dart';
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
  var cart = FlutterCart();
  String editPrice(){
    var q = int.parse(widget.quantity);
    var p =(double.parse(widget.price));
    var total =0.0;
    total =p*q;
    print(total);
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
                                          editPrice(),
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
                        onTap :(){
                          setState(() {
                            if(dropdownValue == "Fixed"){
                              cart.cartItem[widget.index].unitPrice-= double.parse(_discount.text);
                              cart.cartItem[widget.index].subTotal-= double.parse(_discount.text);
                            }
                            print(cart.getTotalAmount().toString());
                             Navigator.pop(context);
                          });
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



