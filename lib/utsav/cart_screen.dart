import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/edit_item.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/payment_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  var size,height,width;
  int table_id=0;

  String table_name='';
  Map m={};
  double p=0.0;
  int _currentIndex = 0;
  setBottomBarIndex(index){
    setState(() {
      _currentIndex = index;
    });
  }
  List<String> counterList=[];
  Future<void> getSharedPrefs() async {
    setState(() {
      _isloading =true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("GETTTTTT");
    customer_name=prefs.getString("customer_name")??"";
    table_id=  prefs.getInt("table_id")??0;
    table_name =prefs.getString("table_name")??"";
    //selectedItems=prefs.getStringList("selected")!;
    setState(() {
      _isloading =false;
    });
  }
  @override
  void initState()  {
    getSharedPrefs();
    super.initState();
  }

  List<dynamic> _selectedItems =[];
  List<dynamic> _selectedItemsprice = [];
  bool isEmpty =true;

  @override
  Widget build(BuildContext context) {
    final cart=FlutterCart();
    // pay();
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<void> saveState() async {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.setStringList("quantity",[]);
      prefs.setStringList("quantity",counterList);
    }

    Future<void> delete(String name ) async {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      if(prefs.containsKey(name)){
        prefs.setStringList(name, []);
        var price=prefs.getStringList(name+"price");
        for(int i=0;i<price!.length;i++)
        {
          setState(() {
            p=p-double.parse(price[i]);
          });
        }
        prefs.setStringList(name+"price",[]);
      }
    }
    return Scaffold(
        appBar:AppBar(
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
                                CircleAvatar(
                                    backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')
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
                        return edit_item(name: cart.cartItem[index].productName.toString(),quantity: cart.cartItem[index].quantity.toString(),price: cart.cartItem[index].unitPrice.toString());
                      });
                    },
                    child: Padding(
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
                                        onPressed:(){
                                          setState(() {
                                            cart.decrementItemFromCart(index);
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
                                        onPressed:(){
                                          print(cart.cartItem[index].productId);
                                          setState(() {
                                            cart.incrementItemToCart(index);
                                          });
                                        },
                                        icon: Icon(Icons.add_circle_outlined,
                                          size: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width/8,
                                      child:Text(
                                        (cart.cartItem[index].unitPrice*cart.cartItem[index].quantity).toString(),
                                        style: GoogleFonts.ptSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )),
                                  IconButton(
                                    onPressed:(){
                                      setState(() async {
                                        cart.deleteItemFromCart(index);
                                        SharedPreferences shared = await SharedPreferences.getInstance();
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
                                child:FutureBuilder(
                                    future:get(cart.cartItem[index].productName) ,
                                    builder: (context,snapshot){
                                      return ListView.builder(
                                        itemCount:1,
                                        itemBuilder: (context, i) {
                                          if(m[cart.cartItem[index].productName]!=null)
                                            return Text(' - Extra '+m[cart.cartItem[index].productName].toString());
                                          else{
                                            return Text("");
                                          }
                                        },
                                      );}),
                              )
                            ] ,
                          )
                      ),
                    ),
                  );})),

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
                      // showDialog(
                      //     context: context,
                      //     builder: (context){
                      //       return VoidBill(Ammount: paymentAmount,);
                      //     }
                      // );
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
                    onPressed:()async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      table_id =  prefs.getInt("table_id")!;
                      table_name =prefs.getString("table_name")!;
                      customer_name=prefs.getString("customer_name")!;
                      setState(() {
                        _currentIndex =0;

                        setState(() {
                          _isloading =false;
                        });
                        setState(() {


                        });
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
        ): Container(
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
                  onPressed: () async {
                      List<Map<String,dynamic>> list_of_m=[];
                      SharedPreferences shared=await SharedPreferences.getInstance();
                      var variation=shared.getStringList("variation");
                      var cart=FlutterCart();
                      for(int index=0;index<cart.cartItem.length;index++)
                      {

                        Map<String,dynamic> product={
                          "product_id":double.parse(cart.cartItem[index].productId),
                          "variation_id":double.parse(variation![index]),
                          "quantity": cart.cartItem[index].quantity,
                          "unit_price": cart.cartItem[index].unitPrice*cart.cartItem[index].quantity,
                        };
                        list_of_m.add(product);
                        // print(list_of_m);
                      }
                      print(list_of_m);
                      Map<String,dynamic> api= {
                        "sells":[
                          {
                            "table_id" :shared.getInt("table_id")??0,
                            "location_id": shared.getInt("bid")??1,
                            "contact_id": double.parse(shared.getString("customer_id")??""),
                            // "status": "draft",
                            "is_suspend": 1,
                            "products":list_of_m,
                            "payments": [
                              {
                                "amount":cart.getTotalAmount(),
                              }
                            ]
                          }
                        ]
                      };
                      if(shared.getInt("order_id")==0)
                      {
                        var dio=Dio();
                        dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                        var r=await dio.post("https://pos.sero.app/connector/api/sell",data: json.encode(api));
                        var v=r.data[0]["id"];
                        print(v.toString());
                        shared.setInt("order_id", v);
                        Fluttertoast.showToast(
                            msg: "Order on hold and Your Order Id is $v",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.green,
                            timeInSecForIosWeb: 4);
                      }
                      cart.deleteAllCart();

                      setState(() {
                        shared.setString("customer_name", '');
                        shared.setString("table_name", '');
                        get("");
                      });

                    },
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
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen(Ammount: paymentAmount, Balance:paymentAmount ,Discountt: discount, Redeem: points,)),
                  );
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                    ),
                    side: MaterialStateProperty.all(BorderSide(width: 2))
                ),
                icon: Icon(Icons.payment,
                  color: Colors.black87,),
                label: Text("PAY:\$${getPaymentAmount()}",style: GoogleFonts.ptSans(
                    color: Colors.black87,
                    fontSize: 20
                ),),
              )
            ],
          ),
        )
    );
  }

  // void pay() {
  //   paymentAmount=0;
  //   for(int i=0;i<_selectedItemsprice.length;i++)
  //   {
  //     paymentAmount+=double.parse(_selectedItemsprice[i]);
  //     // print(paymentAmount.toString()+"+ "+_selectedItemsprice[i]);
  //     paymentAmount+=p;
  //   }
  //   }

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
  String getPaymentAmount() {
    var cart =FlutterCart();
    setState(() {
      paymentAmount=cart.getTotalAmount()+p;
    });
    return paymentAmount.toStringAsFixed(2);
  }
}
class Modi {
  List<dynamic> _modi =[];

  Modi.add(List<dynamic> m){
    _modi=m;
  }
}





