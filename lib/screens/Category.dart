import 'dart:convert';
import 'dart:ui';
//import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dio/dio.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/screens/selectable.dart';
import 'package:flutter_nav_bar/dialog/notification.dart';
import 'package:flutter_nav_bar/screens/resume_screen.dart';
import 'package:flutter_nav_bar/dialog/void.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sero_app/productdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personaldetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:process/process.dart';
import 'package:flutter_nav_bar/screens/productdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key? key, this.title}) : super(key: key);
  final String ?title;
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list=[];
  bool _isSearching=false;
  List<String> searchresult = [];
  TextStyle style = TextStyle(fontSize: 15.0);
  List<String>? _selectedItems = [];
  List<String>? _selectedItemsprice = [];
  var _searchText;
  var _datalist=[];
  var _images=[];
  var _print=[];
  int _currentIndex = 0;
  bool _isloading=false;
  var v;
  bool value = false;
  bool value1 = false;
  //barcode scanner
  Future<void> _scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    print(barcodeScanRes);
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    http.Response response = await http.get(
        Uri.parse("https://seropos.app/connector/api/product?sku=$barcodeScanRes"), headers: {
      'Authorization': sharedPreferences.getString("Authorization")??""
    });
    var cart=FlutterCart();
    v = (json.decode(response.body));
    if(v["data"]!=[])
    {
      String s=v["data"][0]["name"]+" added to cart";
      var price=v["data"][0]["product_variations"][0]["variations"][0]["sell_price_inc_tax"];
      print(price);
      cart.addToCart(productId:v["data"][0]["id"], unitPrice: double.parse(v["data"][0]["product_variations"][0]["variations"][0]["sell_price_inc_tax"]),productName: v["data"][0]["name"]);
      Fluttertoast.showToast(
          msg: s,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.green,
          timeInSecForIosWeb: 4);

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }
  //fetching categories
  Future<void> get() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        _isloading=true;
      });}
    int i=1;
    http.Response response = await http.get(
        Uri.parse("https://seropos.app/connector/api/variation?per_page=-1"), headers: {
      'Authorization': sharedPreferences.getString("Authorization")??""
    });
    v = (json.decode(response.body));
    for(var i in v["data"])
    {
      if(_datalist.contains(i["category"])){
      }
      else {
        if(i["category"]!=null)
          _datalist.add(i["category"]);
        print(_datalist);
      }
    }
    if(mounted){
      setState(() {
        _isloading=false;
      });}
  }
  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });}
  @override
  void initState() {
    get();
    _isSearching = false;
    super.initState();
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
                  shared.setInt("index", 0);
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
        appBar: AppBar(
          flexibleSpace:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30),),
                    color :const Color(0xffffd45f),
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
                  height:148,
                  child:Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Column(
                      children:[Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              alignment: Alignment.topLeft,
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                              },
                            ),
                            Center(child: Text("CATEGORY",style: GoogleFonts.ptSans(fontSize: 18),)),

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
                                  margin: EdgeInsets.only(right: 8,bottom: 15,top: 10,left: 6),
                                  child: CircleAvatar(
                                      backgroundColor:Colors.transparent,
                                      backgroundImage: AssetImage("images/icon-b-s.png")
                                  ),
                                ),
                              ],
                            ),

                          ]),
                        Container(
                          width: MediaQuery.of(context).size.width/1.3,
                          child:
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            child: MaterialButton(
                              minWidth:MediaQuery.of(context).size.width/3,
                              height: MediaQuery.of(context).size.height/20,
                              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //Search product
                                  Container(
                                      height: MediaQuery.of(context).size.height/20,
                                      width: MediaQuery.of(context).size.width/1.6,
                                      child:TypeAheadField<Customer>(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          //controller: _typeAheadController,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Search Product",
                                              suffixIcon: IconButton(
                                                  icon:Image.asset("images/barcode.png",height: 20,width: 20,),
                                                  padding: EdgeInsets.zero,
                                                  color: Colors.black,
                                                  onPressed:_scanQR
                                              ),
                                              prefixIcon:  IconButton(
                                                padding: EdgeInsets.zero,
                                                icon:Icon(Icons.search),
                                                color: Colors.black,
                                                onPressed:(){} ,
                                              ),
                                            )
                                        ),
                                        itemBuilder: (BuildContext context,Customer? suggestion) {
                                          final content=suggestion!;
                                          return ListTile(
                                            title: Text(content._name),
                                          );
                                        },
                                        onSuggestionSelected: (Customer? suggestion) async {
                                          List<dynamic> list_of_products=[];
                                          print("IDDDDDDDDDD");
                                          SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                                          var cart=FlutterCart();
                                          print(suggestion!.id);

                                          //hint=suggestion!._name;
                                          //_typeAheadController.text=suggestion._name;
                                          var list = sharedPreferences.getStringList("variation");
                                          http.Response response = await http.get(
                                              Uri.parse("https://seropos.app/connector/api/variation/?name=${suggestion._name}"), headers: {
                                            'Authorization': sharedPreferences.getString("Authorization")??""
                                          });
                                          print("IDDDDDDDDDD");
                                          var tax=json.decode(response.body)["data"][0]["tax_id"];
                                          print(json.decode(response.body)["data"][0]["variation_id"].toString());
                                          list!.add(json.decode(response.body)["data"][0]["variation_id"].toString());
                                          var customer_id=sharedPreferences.getString("customer_id")!;
                                          var bid=sharedPreferences.getInt("bid");
                                          http.Response response2 = await http.get(
                                              Uri.parse("https://seropos.app/connector/api/sells/pos/get_discount_product/${json.decode(response.body)["data"][0]["variation_id"]}/$bid?customer_id=$customer_id"), headers: {
                                            'Authorization': sharedPreferences.getString("Authorization")??""
                                          });
                                          var x=json.decode(response2.body);
                                          cart.addToCart(productId: suggestion.id, unitPrice: x["data"]["default_sell_price"],productName: suggestion._name);
                                          //print(suggestion.variation_id);
                                          sharedPreferences.setStringList("variation", []);
                                          sharedPreferences.setStringList("variation", list);
                                          if(sharedPreferences.getString("products")!=""){
                                            list_of_products=json.decode(sharedPreferences.getString("products")??"")??[];}
                                          Map m={
                                            "pid":suggestion.id,
                                            "tax_id":tax,
                                            "price_inc_tax":x["data"]["sell_price_inc_tax"],
                                            "total":x["data"]["sell_price_inc_tax"],
                                            "note":""
                                          };
                                          int flag=0;
                                          for(int i=0;i<list_of_products.length;i++)
                                          {
                                            if(list_of_products[i]["pid"]==suggestion.id)
                                            {
                                              flag=1;
                                              break;
                                              print("Yes product id exist");
                                            }
                                          }
                                          if(flag==0)
                                            list_of_products.add(m);
                                          print(list_of_products);
                                          sharedPreferences.setString("products", json.encode(list_of_products));
                                          sharedPreferences.setString("total",cart.getCartItemCount().toString());
                                          Fluttertoast.showToast(
                                              msg:suggestion._name+" is selected",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              textColor: Colors.green,
                                              timeInSecForIosWeb: 4);
                                        },
                                        suggestionsCallback: CustomerApi.getUserSuggestion,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          //],
                          //)
                        )],
                    ),
                  ),
                ),
              ]
          ),
          toolbarHeight: 110,
          backgroundColor: Colors.white,
        ),
        body: _isloading?Center(
            child: CircularProgressIndicator(color: Color(0xff000066),)):searchresult.length != 0 || _controller.text.isNotEmpty?
        Center(
          child:Container(
            padding: EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: searchresult.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(child:Container(
                  height: MediaQuery.of(context).size.height/10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: const Offset(
                            2.0,
                            2.0,
                          ),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ]//BoxShadow
                  ),
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        //child:Image.network(_images[index],height: 30,width:MediaQuery.of(context).size.width/4.5,)),
                        /* SizedBox(
                            width: 15,
                          ),*/),
                      Container(
                          width: MediaQuery.of(context).size.width/3,
                          child:Text(searchresult[index],
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: style.copyWith(color: Colors.black))),
                      /*SizedBox(
                            width:50,
                          ),*/
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child:  IconButton(icon:Icon(
                          Icons.arrow_forward,
                        ),
                          onPressed:(){

                          } ,
                        ),
                      )
                    ],
                  ),

                ),
                  onTap:() async {
                    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    _selectedItemsprice!.addAll(sharedPreferences.getStringList("selected")??[]);
                    print(_selectedItemsprice);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //    builder: (context) => SelectItem(category:searchresult[index],selectedItemsprice:_selectedItemsprice??[],selectedItems: _selectedItems??[],)));
                  } ,
                );
              },
              // SizedBox(
              //   height: 20,
              // ),

            ),
          ),
        )://No search found then
        Container(
          padding: EdgeInsets.all(20),
          child:Center(
            child:ListView.builder(
              itemCount: _datalist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(child:Container(
                  height: MediaQuery.of(context).size.height/10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: const Offset(
                            2.0,
                            2.0,
                          ),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ]//BoxShadow
                  ),
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        //child:Image.network(_images[index],height: 30,width:MediaQuery.of(context).size.width/4.5,)),
                        /* SizedBox(
                          width: 15,
                        ),*/),
                      Container(
                          width: MediaQuery.of(context).size.width/3,
                          child:Text(_datalist[index].toString().toUpperCase(),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSans(color: Color(0xff707070),fontSize: 16,fontWeight: FontWeight.bold))),
                      /*SizedBox(
                          width:50,
                        ),*/
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        child:  IconButton(icon:Icon(
                          Icons.arrow_forward,
                        ),
                          onPressed:(){

                          } ,
                        ),
                      )
                    ],
                  ),

                ),
                  onTap:() async {
                    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                    //_selectedItemsprice!.addAll(sharedPreferences.getStringList("selected")??[]);
                    print(_selectedItemsprice);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectItem(category:_datalist[index],selectedItemsprice:_selectedItemsprice??[],selectedItems: _selectedItems??[],)));
                  } ,
                );
              },
              // SizedBox(
              //   height: 20,
              // ),

            ),
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
class Customer
{
  final String _name;
  final String _phone;
  final String id;
  Customer.fromJson(Map<String,dynamic> json):
        this._name=json["name"],
        this._phone=json["product_variations"][0]["variations"][0]["sell_price_inc_tax"],
        this.id=json["id"].toString();

}
class CustomerApi {
  static Future<List<Customer>> getUserSuggestion(String query)
  async {
    int i = 1;
    var pages;
    List<Customer>name = [];
    late Customer cus;
    SharedPreferences shared  = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse("https://seropos.app/connector/api/product/?per_page=-1"),
        headers: {
          'Authorization': shared.getString("Authorization")??""        });
    final List d = json.decode(response.body)["data"];
    pages=json.decode(response.body);
    print(d);
    name.addAll(d.map((e) => Customer.fromJson(e)).where((element) {
      final name = element._name.toLowerCase();
      final _name = query.toLowerCase();
      print("NAME");
      return name.contains(_name);
    }).toList());
    return name;
  }
}

