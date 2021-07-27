import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
class edit_item extends StatefulWidget {
  String name;
  String quantity;
  String price;
  edit_item({
    required this.name,
    required this.quantity,
    required this.price,
});
  @override
  _edit_item_State createState() => _edit_item_State();
}

class _edit_item_State extends State<edit_item> {
  String dropdownValue1 ='Percentage';
  final _formKey = GlobalKey<FormState>();
  final _amountController = new TextEditingController();
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
            height: 450,
            padding: EdgeInsets.all(8),
            child: (
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text("EDIT ITEM",style: TextStyle(fontSize: 20),),
                ),
                Container(
                  // height:MediaQuery.of(context).size.height/1.85,
                  child:Padding(
                        padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
                        child: Container(
                          // height:MediaQuery.of(context).size.height/10 ,
                            padding: EdgeInsets.only(left:10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
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
                                          style: TextStyle(
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
                                              widget.quantity=c.toString();
                                              //saveState();
                                            });
                                          },
                                          icon: Icon(Icons.remove_circle,
                                            size: 17,),
                                        ),
                                        Text(widget.quantity.toString(),
                                          style: TextStyle(
                                              fontSize: 12
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:(){
                                            setState(() {
                                              var c=int.parse(widget.quantity);
                                              c++;
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
                                          '\$'+double.parse(widget.price).toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 12,
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,
                          left: 25),
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
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
                        child: DropdownButton<String>(
                          value: dropdownValue1,
                          items: [
                            DropdownMenuItem(
                              value: 'Fixed',
                              child: Text('Fixed'),
                            ),
                            DropdownMenuItem(
                              value: 'Percentage',
                              child: Text('Percentage'),
                            ),

                          ],
                          onChanged: (value) {
                            setState(() {
                              var dropdownValue1 = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 120,
                      child: TextField(
                        enableInteractiveSelection: false,
                        focusNode: new AlwaysDisabledFocusNode(),
                        keyboardType:TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Hi',
                          hintStyle: TextStyle(
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
                Container(
                  height: 200,
                  width: 320,
                  child: TextField(
                    maxLines: 10,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      hintText: 'Hi',
                      hintStyle: TextStyle(
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
                SizedBox(
                  width: 180,
                  height: 50,
                  child: CupertinoButton(
                    child: Center(child: Text('Done',style: TextStyle(color:Colors.black),)),
                    color: Color(0xFFFFD45F), onPressed: () {  },
                  ),
                )
              ],
            )
    ),
          ),
        ));
  }
}

