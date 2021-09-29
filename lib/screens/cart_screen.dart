import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/screens/selectable.dart';
import 'package:flutter_nav_bar/dialog/edit_item.dart';
import 'package:flutter_nav_bar/tab/edit_item_tab.dart';
import 'package:flutter_nav_bar/dialog/notification.dart';
import 'package:flutter_nav_bar/screens/payment_screen.dart';
import 'package:flutter_nav_bar/screens/resume_screen.dart';
import 'package:flutter_nav_bar/dialog/void.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_drawer.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String customer_name="";
  List<dynamic> _modifiers=[];
  double paymentAmount=0;
  double discount =0.0;
  bool _isloading =false;
  List<String> counter=[];
  int points=0;
  List<dynamic> list_of_products=[];
  var size,height,width;
  int table_id=0;

  String table_name='';
  Map m={};
  double p=0.0;
  Future<void> getSharedPrefs() async {
    setState(() {
      _isloading =true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("GETTTTTT");
    customer_name=prefs.getString("customer_name")??"";
    table_id=  prefs.getInt("table_id")??0;
    table_name =prefs.getString("table_name")??"";
    setState(() {
      _isloading =false;
    });
  }
  @override
  void initState()  {
    getSharedPrefs();
    super.initState();
  }
  List<String> counterList=[];
  List<dynamic> _selectedItems =[];
  List<dynamic> _selectedItemsprice = [];
  bool isEmpty =true;
  @override
  Widget build(BuildContext context) {
    // key: _scaffoldKey;
    final cart=FlutterCart();
    // pay();
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        floatingActionButton: SpeedDial(
          marginBottom: 100, //margin bottom
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

          elevation: 8, //shadow elevation of button
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
                  shared.setInt("PAY_HOLD",1);
                });

                Fluttertoast.showToast(
                    msg:"Order has been cleared you can go to home screen",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.green,
                    timeInSecForIosWeb: 10);
                shared.setInt("seconds", 0);
                Phoenix.rebirth(context);
              },
              onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
            //add more menu item childs here
          ],
        ),
        drawer: MainDrawer(),
        appBar:AppBar(
          //leading: Container(),
          flexibleSpace:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30),),
                    color :const Color(0xFFFFD45F),
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
                  height:150,
                  child:Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              alignment: Alignment.topLeft,
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                setState(() {
                                });
                              },
                            ),
                            Text("ORDER",
                              style: GoogleFonts.ptSans(fontSize: 18),),
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
                                Container(
                                  margin: EdgeInsets.only(right: 6,bottom: 0,top: 10,left: 6),
                                  child: CircleAvatar(
                                      backgroundColor:Colors.transparent,
                                      backgroundImage: AssetImage("images/icon-b-s.png")
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12,left: 25,right: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(table_name,
                                    style: GoogleFonts.ptSans(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),),
                                  Text(customer_name,
                                    style: GoogleFonts.ptSans(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
          toolbarHeight: 135,
          backgroundColor: Colors.white,
        ),

        body: _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),))
            :Container(
            height:MediaQuery.of(context).size.height/1.85,
            child: ListView.builder(
                itemCount: cart.cartItem.length,
                itemBuilder: (context, index) {
                  if(counterList.length < _selectedItems.length ) {
                    counterList.add("1");
                  }
                  return GestureDetector(
                    onTap:(){
                      showDialog(context: context, builder: (context) {
                        return MediaQuery.of(context).size.width < 650 ? edit_item(name: cart.cartItem[index].productName.toString(),quantity: cart.cartItem[index].quantity.toString(),price: cart.cartItem[index].unitPrice.toString(), index: index,):
                        edit_item_TAB(name: cart.cartItem[index].productName.toString(),quantity: cart.cartItem[index].quantity.toString(),price: cart.cartItem[index].unitPrice.toString(), index: index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
                      child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/2.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(cart.cartItem[index].productName.toString(),
                                      style: GoogleFonts.ptSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.,
                                  children: [
                                    IconButton(
                                      onPressed:() async {
                                        SharedPreferences shared=await SharedPreferences.getInstance();
                                        setState(() {
                                          cart.decrementItemFromCart(index);
                                          for(int i=0;i<list_of_products.length;i++)
                                          {
                                            if(list_of_products[i]["pid"]==cart.cartItem[index].productId)
                                            {
                                              print("BREFORE");
                                              print(list_of_products);
                                              list_of_products[i]["total"]=double.parse(list_of_products[i]["price_inc_tax"])*double.parse(cart.cartItem[index].quantity.toString());
                                              shared.setString("products", json.encode(list_of_products));
                                              print("AFTER");
                                              print(list_of_products);
                                              getPaymentAmount();
                                            }
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.remove_circle,
                                        size: 17,),
                                    ),
                                    Text(cart.cartItem[index].quantity.toString(),
                                      style: GoogleFonts.ptSans(
                                          fontSize: 15
                                      ),
                                    ),
                                    IconButton(
                                      onPressed:() async {
                                        SharedPreferences shared=await SharedPreferences.getInstance();
                                        print(cart.cartItem[index].productId);
                                        setState(() {
                                          cart.incrementItemToCart(index);
                                          for(int i=0;i<list_of_products.length;i++)
                                          {
                                            if(list_of_products[i]["pid"]==cart.cartItem[index].productId)
                                            {
                                              print("BREFORE");
                                              print(list_of_products);
                                              list_of_products[i]["total"]=double.parse(list_of_products[i]["price_inc_tax"])*double.parse(cart.cartItem[index].quantity.toString());
                                              shared.setString("products", json.encode(list_of_products));
                                              print("AFTER");
                                              print(list_of_products);
                                              getPaymentAmount();
                                            }
                                          }
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
                                      double.parse((cart.cartItem[index].unitPrice*cart.cartItem[index].quantity).toString()).toStringAsFixed(2),
                                      style: GoogleFonts.ptSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )),
                                IconButton(
                                  onPressed:() async {
                                    SharedPreferences shared = await SharedPreferences.getInstance();
                                    setState(()  {
                                      for(int i=0;i<list_of_products.length;i++)
                                      {
                                        if(list_of_products[i]["pid"]==cart.cartItem[index].productId)
                                        {
                                          print("BREFORE");
                                          print(list_of_products);
                                          list_of_products.removeAt(i);
                                          shared.setString("products", json.encode(list_of_products));
                                          print("AFTER");
                                          print(list_of_products);
                                        }
                                      }
                                      cart.deleteItemFromCart(index);
                                      shared.setString("total", (cart.getCartItemCount()).toString());
                                      var list = shared.getStringList("variation");
                                      list!.removeAt(index);
                                      shared.setStringList("variation", list);
                                      paymentAmount = cart.getTotalAmount();
                                      print(cart.getCartItemCount());
                                    });
                                    // delete(cart.cartItem[index].productName);
                                  },
                                  icon: Icon(Icons.delete,
                                    color: Colors.red,
                                    size: 25,),
                                ),
                              ],
                            ),
                            Container(
                              height: 20,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              child:FutureBuilder(
                                  future:get(cart.cartItem[index].productName),
                                  builder: (context,snapshot){
                                    return ListView.builder(
                                      itemCount:1,
                                      itemBuilder: (context, i) {
                                        return Text(list_of_products[index]["note"]??"");
                                      },
                                    );}),
                            ),
                          ] ,
                        ),
                      ),
                    ),
                  );})),

        bottomSheet: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight:Radius.circular(25),topLeft:Radius.circular(25),),
            color :const Color(0xFFFFD45F),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: OutlinedButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                      ),
                      side: MaterialStateProperty.all(BorderSide(width: 2))
                  ),
                  icon: Icon(Icons.pause_outlined,
                    color: Colors.black87,),
                  label: Text("HOLD",style: GoogleFonts.ptSans(
                    color: Colors.black87,
                    fontSize: 20,
                  ),),
                  onPressed: () async {
                    print('haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaaa');
                    List<Map<String,dynamic>> list_of_m=[];
                    SharedPreferences shared=await SharedPreferences.getInstance();
                    var variation=shared.getStringList("variation");
                    print(variation);
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
                        "product_id":int.parse(cart.cartItem[index].productId.toString()),
                        "variation_id":double.parse(variation![index]),
                        "quantity": cart.cartItem[index].quantity,
                        "unit_price": cart.cartItem[index].unitPrice,
                        "tax_rate_id":tax_id,
                        "note":note
                      };
                      list_of_m.add(product);
                      print(list_of_m);
                    }
                    if(shared.containsKey("modifiers")){
                      if(shared.getString("modifiers")!=""){
                        List<dynamic> mod =json.decode(shared.getString("modifiers")?? "");
                        print(mod[0]);
                        for(int i =0;i<mod.length;i++){
                          list_of_m.add(mod[0]);
                          // print(mod[0]["name"]);
                        }}}

                    print(list_of_m);

                    if(shared.getString("order_id")=="")
                    {
                      Map<String,dynamic> api= {
                        "sells":[
                          {
                            "table_id" :shared.getInt("table_id")??1,
                            "location_id": shared.getInt("bid")??1,
                            "contact_id": double.parse(shared.getString("customer_id")??"1"),
                            "is_suspend": 1,
                            "tip":0,
                            "products":list_of_m,
                            "payments": [
                              {
                                "amount":cart.getTotalAmount(),
                              }
                            ]
                          }
                        ]
                      };
                      var dio=Dio();
                      dio.options.headers["Authorization"]=shared.getString("Authorization");
                      var r=await dio.post("https://seropos.app/connector/api/sell",data: json.encode(api));
                      print(r);
                      var v=r.data[0]["id"];
                      print(v.toString());
                      shared.setString("order_id", v.toString());
                      var u=r.data[0]["invoice_no"];
                      print(u);
                      shared.setString("invoice_no", u);
                      var inid =shared.getString("invoice_no");
                      print(inid);
                      Map<String,dynamic> api2={
                        "invoice_number":inid
                      };
                      dio.options.headers["Authorization"]=shared.getString("Authorization");
                      var r1=await dio.post("https://seropos.app/connector/api/get-invoice-url",data: json.encode(api2));
                      print(r1);
                      Fluttertoast.showToast(
                          msg: "Order on hold and Your Order Id is $v",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.green,
                          timeInSecForIosWeb: 4);
                    }
                    else{

                      Map<String,dynamic> api= {
                        "sells":[
                          {
                            "table_id" :shared.getInt("table_id")??0,
                            "location_id": shared.getInt("bid")??1,
                            "is_suspend": 1,
                            "tip":0,
                            "contact_id": double.parse(shared.getString("customer_id")??"1"),
                            "products":list_of_m,
                            "payments": [
                              {
                                "amount":cart.getTotalAmount()
                              }
                            ]
                          }
                        ]


                      };
                      print(json.encode(api));

                      var dio=Dio();
                      var vid = shared.getString("order_id");
                      dio.options.headers["Authorization"]=shared.getString("Authorization");
                      print(vid);
                      print("hahah");
                      var r=await dio.put("https://seropos.app/connector/api/sell/$vid",data: json.encode(api));

                      print(r.data);
                      var v=r.data["invoice_no"];
                      print(v);
                      shared.setString("invoice_no", v);
                      cart.deleteAllCart();

                      setState(() {
                        shared.setString("total","0");
                        shared.setInt("index", 0);
                        shared.setInt("PAY_HOLD",1);
                      });
                    }
                    shared.setString("modifiers", '');
                    shared.setStringList("selectedmodifiers", []);
                    shared.setStringList("selectedmodifiersprice", []);
                    shared.setStringList("variation", []);
                    cart.deleteAllCart();
                    // shared.clear();

                    // shared.setString("customer_name", '');
                    // shared.setString("table_name", '');
                    setState(() {
                      shared.setString("total","0");
                      shared.setInt("index", 0);
                      shared.setInt("PAY_HOLD",1);
                    });
                    shared.setInt("seconds", 0);
                    Phoenix.rebirth(context);
                    // get("");
                  },
                ),
              ),
              FutureBuilder(
                future:getPaymentAmount(),
                builder: (context,snapshot){
                  return OutlinedButton.icon(
                    onPressed: () async {
                      SharedPreferences shared =await SharedPreferences.getInstance();
                      shared.setString("screen", "Payment");
                      // shared.setInt("index", 2);
                      print("ONPRESSED"+paymentAmount.toStringAsFixed(2));
                      shared.setDouble("balance",paymentAmount);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentScreen(Ammount: paymentAmount, Balance:paymentAmount ,Discountt: discount, Redeem: points,)),
                      );
                      print(paymentAmount);
                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      //     builder: (BuildContext context) => PaymentScreen(Ammount: paymentAmount, Balance: paymentAmount, Discountt: discount, Redeem: points)), (
                      //     Route<dynamic> route) => true);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                        ),
                        side: MaterialStateProperty.all(BorderSide(width: 2))
                    ),
                    icon: Icon(Icons.payment,
                      color: Colors.black87,),
                    label: Text("PAY:\$${snapshot.data}",style: GoogleFonts.ptSans(
                        color: Colors.black87,
                        fontSize: 20
                    ),),
                  );

                },
              )

            ],
          ),
        )
    );
  }

  fetchData() async {
    p=0;
    setState(() {
      _isloading=true;
    });
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var list=sharedPreferences.getStringList("selected")??[];
    _selectedItems=list;
    _selectedItemsprice=sharedPreferences.getStringList("selectedprice")!;
    // print(_selectedItems);
    var _mod;
    for(int i=0 ;i<list.length;i++) {
      if(sharedPreferences.containsKey(list[i])) {
        var price=sharedPreferences.getStringList(list[i]+"price")??[];
        for(int i=0;i<price.length;i++)
        {
          print(price[i]);
          print(price[i]);
          p+=double.parse(price[i]);
          // print("PPPPPPPPPPPPPPPPPPPPPPPPPPP");
          // print(p);
        }
        _mod = sharedPreferences.getStringList(list[i]);
        // print(_mod);
        m[list[i]] = _mod;
        // print([list[i]]);
      }
      else
      {
        m[list[i]] = null;
      }
    }

    // Modi modi ;
    // modi = Modi.add(_mod!);
    //   _modifiers.add(modi)  ;

    setState(() {
      _isloading=false;
    });
    return list;
  }

  get(String? name) async {
    p=0;
    var cart =FlutterCart();
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    list_of_products=json.decode(sharedPreferences.getString("products")!);
    setState(() {
      customer_name=sharedPreferences.getString("customer_name")??"";
      table_name=sharedPreferences.getString("table_name")??"";
    });
    if(sharedPreferences.containsKey(name!)){
      m[name]=sharedPreferences.getStringList(name);
      var price=sharedPreferences.getStringList(name+"price");
      for (int i=0;i<price!.length;i++) {
        p += double.parse(price[i]);
      }
      print("PPPPPPPPPPPPPPPPPPPPP:"+p.toString());
      setState(() {
        paymentAmount = cart.getTotalAmount()+p;
      });

      return m;
    }
    else
    {
      return [];
    }
  }
  Future<String> getPaymentAmount() async {
    paymentAmount=0;
    SharedPreferences shared=await SharedPreferences.getInstance();
    if(shared.getString("products")!=""){
      List<dynamic> products=json.decode(shared.getString("products")??"")??"";
      print(products);
      for(int i=0;i<products.length;i++)
      {
        setState(() {
          paymentAmount+=double.parse(products[i]["total"].toString());
          print("AMOUNTTTTTTTT");
          print(paymentAmount);
        });
      }
      print(paymentAmount);}
    return paymentAmount.toStringAsFixed(2);
  }
}
class Modi {
  List<dynamic> _modi =[];

  Modi.add(List<dynamic> m){
    _modi=m;
  }
}

