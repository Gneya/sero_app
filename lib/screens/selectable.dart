//select table
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/dialog/notification.dart';
import 'package:flutter_nav_bar/screens/resume_screen.dart';
import 'package:flutter_nav_bar/dialog/void.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_nav_bar/screens/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_drawer.dart';

class SelectTable extends StatefulWidget {
  const SelectTable({Key ? key}) : super(key: key);
  @override
  State<SelectTable> createState() => _SelectTableState();
}
class _SelectTableState extends State<SelectTable> {
  bool _isloading = false;
  int _currentIndex = 0;
  List<String> _tablenos = [];
  List<String> _table_status=[];
  List<int> id=[];
  int i=0;
  _SelectTableState() {
    fetchData().then((val) =>
        setState(() {
          _tablenos = val;
        }));
  }
  //fetching table data from api
  Future<List<String>> fetchData() async {
    Map data = await getData();
    setState(() {
      _isloading=false;
    });
    List<String> tableno = [];
    for(var i in data['data'])
    {
      tableno.add(i["name"]);
      _table_status.add(i["table_status"]);
      id.add(i["id"]);
      print(id);
    }
    return tableno;
  }
  @override
  void initState() {
    setState(() {
      _isloading=true;
    });
    fetchData();
    super.initState();
  }
  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        marginBottom: 13, //margin bottom
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

        elevation: 8.0, //shadow elevation of button
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
                // shared.setInt("index", 0);
                shared.setString("total", "0");
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
      appBar: AppBar(
        title: Center(child: Text("SELECT TABLE",style: GoogleFonts.ptSans(color: Colors.black,fontSize: 18))),
        backgroundColor: Color(0xffffd45f),
        actions: [
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
              )),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(right: 10),
            child:  Container(
              margin: EdgeInsets.only(right: 6,bottom: 15,top: 10,left: 6),
              child: CircleAvatar(
                  backgroundColor:Colors.transparent,
                  backgroundImage: AssetImage("images/icon-b-s.png")
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
      body: _isloading? Center(
          child: CircularProgressIndicator(color: Color(0xff000066),)):
      //displaying table
      GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(18),
        itemBuilder: (BuildContext context, int index) {
          i=index;
          return GestureDetector(
            child:Container(
              //height: MediaQuery.of(context).size.height,
              //width:  MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                color:_table_status[i]=="occupied"?Color(0xfffd6360):_table_status[i]=="available"?Color(0xff00af20):Colors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset("images/row_4.png",height: MediaQuery.of(context).size.height/17,),
                  Text(
                    _tablenos[index],
                    style: GoogleFonts.ptSans(fontSize: 16,color: Colors.white),
                  ),
                ],
              ),
            ),
            onTap: ()async {
              // Phoenix.rebirth(context);
              List<dynamic> list_of_products=[];
              //if table is occupied
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("table_name", _tablenos[index]);
              if(_table_status[index]=="occupied")
              {
                sharedPreferences.setInt("table_id", id[index]);
                setState(() {
                  _isloading = true;
                });
                //if table has previous holds
                http.Response response = await http.get(
                    Uri.parse(
                        "https://seropos.app/connector/api/sell?per_page=-1")
                    , headers: {
                  'Authorization': sharedPreferences.getString("Authorization")??""
                });
                var v = (json.decode(response.body));
                var cart=FlutterCart();
                for(var i in v["data"])
                {
                  if(i["is_suspend"]==1 && i["res_table_id"]==id[index]) {
                    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    print(i["id"]);
                    sharedPreferences.setString("order_id", i["id"].toString());
                    cart.deleteAllCart();
                    print(id[index]);
                    for(var x in i["sell_lines"])
                    {
                      Map m={
                        "pid":x["product_id"],
                        "tax_id":x["tax_id"],
                        "note":x["sell_line_note"]??"",
                        "price_inc_tax":x["unit_price_inc_tax"]
                      };
                      list_of_products.add(m);
                      http.Response response = await http.get(
                          Uri.parse(
                              "https://seropos.app/connector/api/product/${x["product_id"]}")
                          , headers: {
                        'Authorization': sharedPreferences.getString("Authorization")??""
                      });
                      var list=sharedPreferences.getStringList("variation");
                      var v = (json.decode(response.body)["data"][0]["name"]);
                      print(v);
                      list!.add(x["variation_id"].toString());
                      sharedPreferences.setStringList("variation", list);
                      cart.addToCart(productId: x["product_id"], unitPrice: double.parse(x["unit_price"]),productName: v);
                    }
                    sharedPreferences.setString("total", cart.getCartItemCount().toString());
                    sharedPreferences.setString("products", json.encode(list_of_products));
                    print("LIST OF PRODUCTS");
                    print(list_of_products);
                    break;
                  }
                }
                if(cart.getCartItemCount()!=0){
                  sharedPreferences.setInt("index", 2);
                }
                if (!mounted) {
                  setState(() {
                    _isloading = false;
                  });
                }
              }else{

              //converting table status as occupied
                SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                sharedPreferences.setInt("table_id", id[index]);
                Map<String,dynamic> api={
                  "table_id":id[index],
                  "table_status":"occupied"
                };
                var dio=Dio();
                dio.options.headers["Authorization"]=sharedPreferences.getString("Authorization");
                var r=await dio.post("https://seropos.app/connector/api/change-table-status",data: json.encode(api));
                print(r);
                //print(json.decode(response.body));
                print(id[index]);
                setState(() {
                  _isloading=false;
                });
                //redirecting to category screen
                sharedPreferences.setInt("index", 1);
              }
            },
          );
        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 25.0,
      ),
        itemCount: _tablenos.length ,
      ),
    );
  }
}
//function to fetch data
Future<Map<String, dynamic>> getData() async {
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  String myUrl = "https://seropos.app/connector/api/table";
  http.Response response = await http.get(Uri.parse(myUrl), headers: {
    'Authorization':sharedPreferences.getString("Authorization")??""
  });
  return json.decode(response.body);
}


