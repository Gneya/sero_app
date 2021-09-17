import 'dart:convert';
import 'dart:ui';
//import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dio/dio.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/selectable.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
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
import 'Category.dart';
import 'addons_and_modifiers.dart';
import 'personaldetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:process/process.dart';
import 'package:flutter_nav_bar/productdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabScreen extends StatefulWidget {
  TabScreen({Key? key, this.title}) : super(key: key);
  final String ?title;
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  var v;
  //List<String> selectedReportList = [];
  Map m={};
  var cart=FlutterCart();
  late product _product;
  List<Map<String,dynamic>> list_of_m=[];
  List<product> _productlist=[];
  bool _isSearching=false;
  List<String> searchresult = [];
  List<String> searchresultImages = [];
  List<String> searchresultprice=[];
  List<String> images = [];
  List<dynamic> list_of_products=[];
  List<String> price=[];
  List<String> _selectedItems = [];
  List<String> _selectedItemsprice = [];
  TextEditingController _controller=new TextEditingController();
  List<String> name = [];
  List<String> id = [];
  bool _isloading = false;
  var _searchText;

  List<dynamic> _list=[];

  TextStyle style = TextStyle(fontSize: 15.0);


  var _datalist=[];
  bool value = false;
  bool value1 = false;
  _CategoryScreenState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }
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


    _SelectItemState() {
      _controller.addListener(() {
        if (_controller.text.isEmpty) {
          setState(() {
            _isSearching = false;
            _searchText = "";
          });
        } else {
          setState(() {
            _isSearching = true;
            _searchText = _controller.text;
          });
        }
      });
    }
     i=1;

    http.Response response1 = await http.get(
        Uri.parse("https://seropos.app/connector/api/variation/?per_page=-1"), headers: {
      'Authorization': sharedPreferences.getString("Authorization")??""
    });
    var customer_id=sharedPreferences.getString("customer_id")!;
    var bid=sharedPreferences.getInt("bid");
    v = (json.decode(response1.body));
    for (var i in v["data"]) {
     {
        print(i);
        if(i["not_for_selling"]==0){
          http.Response response2 = await http.get(
              Uri.parse("https://seropos.app/connector/api/sells/pos/get_discount_product/${i["variation_id"]}/$bid?customer_id=$customer_id"), headers: {
            'Authorization': sharedPreferences.getString("Authorization")??""
          });
          var x=json.decode(response2.body);
          _product=product.fromJson(i,x["data"]);
          _productlist.add(_product);
        }
      }
    }
    i++;
    print(_productlist);
    if(mounted){
      setState(() {
        _isloading=false;
      });}
  }
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _datalist.length; i++) {
        String data = _datalist[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }}
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
        body:_isloading?Center(
            child: CircularProgressIndicator(color: Color(0xff000066),)):
        Row(
          children: [
            Expanded(
              flex: 5,
              child:Center(
                child://No search found then
            Container(
            padding: EdgeInsets.only(top: 10,bottom:10),
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
                margin: EdgeInsets.only(top: 10,bottom:10),
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
                  ],
                ),

              ),
                onTap:() async {
                  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                  //_selectedItemsprice!.addAll(sharedPreferences.getStringList("selected")??[]);
                  print(_selectedItemsprice);
                  _productlist.clear();
                  http.Response response1 = await http.get(
                      Uri.parse("https://seropos.app/connector/api/variation/?per_page=-1"), headers: {
                    'Authorization': sharedPreferences.getString("Authorization")??""
                  });
                  var customer_id=sharedPreferences.getString("customer_id")!;
                  var bid=sharedPreferences.getInt("bid");
                  v = (json.decode(response1.body));
                  for (var i in v["data"]) {
                    {
                      print(i);
                      if(i["category"]==_datalist[index]){
                      if(i["not_for_selling"]==0){
                        http.Response response2 = await http.get(
                            Uri.parse("https://seropos.app/connector/api/sells/pos/get_discount_product/${i["variation_id"]}/$bid?customer_id=$customer_id"), headers: {
                          'Authorization': sharedPreferences.getString("Authorization")??""
                        });
                        var x=json.decode(response2.body);
                        _product=product.fromJson(i,x["data"]);
                        _productlist.add(_product);
                      }}
                    }
                  }
                  print(_productlist);
                  if(mounted){
                    setState(() {
                      _isloading=false;
                    });}
                } ,
              );
            },
            // SizedBox(
            //   height: 20,
            // ),

          ),
             ),
              ),
              ),
            ),
            Expanded(
                flex: 5,
                child: GridView.builder(
                primary: false,
                padding: const EdgeInsets.all(10),
                itemCount: _productlist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 25.0,
                  mainAxisSpacing: 25.0,

                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    //width: 550,
                    //width: 550,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height/12,
                            width: MediaQuery.of(context).size.width,
                            child:Image.network(_productlist[index].url)
                        ),
                        Container(
                          // height: MediaQuery
                          //     .of(context)
                          //     .size
                          //     .height / 25,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Center(child: _productlist[index].name.length>15?Text(
                            _productlist[index].name.substring(0,13),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
                          ):Text(
                            _productlist[index].name,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
                          ),),
                        )],
                    ),
                  ),
                      onTap: () async {
                        SharedPreferences sharedPreferences = await SharedPreferences
                            .getInstance();

                        var list = sharedPreferences.getStringList("variation");
                        list!.add(_productlist[index].variation_id);
                        print(_productlist[index].variation_id);
                        sharedPreferences.setStringList("variation", []);
                        sharedPreferences.setStringList("variation", list);
                        Map<String,dynamic> product={};
                        if(cart.cartItem.contains( _productlist[index].id))
                        {
                          print("YESSSSSS");
                        }
                        else
                        {
                          print("NOOOO");
                          print("NOOOO");
                        }
                        int flag1 =0;
                        for (int i =0 ;i<cart.cartItem.length;i++){
                          if(cart.cartItem[i].productId==_productlist[index].id){
                            cart.addToCart(productId: _productlist[index].id,
                                unitPrice: double.parse(_productlist[index].price),
                                productName: _productlist[index].name,
                                quantity: ++cart.cartItem[i].quantity);
                            flag1 =1;
                            print("&&&&&&&&&&&&&&&&&**************(())))))))))))))))))");
                            break;
                          }

                        }
                        if( flag1 ==0){
                          cart.addToCart(productId: _productlist[index].id, unitPrice: double.parse(_productlist[index].price),productName: _productlist[index].name);
                        }

                        sharedPreferences.setString("total", cart.getCartItemCount().toString());
                        if(sharedPreferences.getString("products")!=""){
                          list_of_products=json.decode(sharedPreferences.getString("products")??"")??[];}
                        m={
                          "pid":_productlist[index].id,
                          "tax_id":_productlist[index].tax_id,
                          "price_inc_tax":_productlist[index].price_inc_tax,
                          "note":""
                        };
                        int flag=0;
                        for(int i=0;i<list_of_products.length;i++)
                        {
                          if(list_of_products[i]["pid"]==_productlist[index].id)
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
                        http.Response response = await http.get(
                            Uri.parse(
                                "https://seropos.app/connector/api/product/${_productlist[index].id}")
                            ,  headers: {
                          'Authorization': sharedPreferences.getString("Authorization")??""
                        });
                        var v = (json.decode(response.body));
                        List<dynamic> check = v["data"][0]["modifiers"];
                        if (check.isNotEmpty) {
                          showDialog(context: context, builder: (context) {
                            return add(product: _productlist[index].name);
                          });
                        }
                        Fluttertoast.showToast(
                            msg: "Item added to cart",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.green,
                            timeInSecForIosWeb: 4);
                      }
                  );
                })
            ),
            Expanded(
              flex: 5,
              child:CartScreen() ,
            ),
          ]
        )
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

class product
{
  final String id;
  final String name;
  final String price;
  final String url;
  final String price_inc_tax;
  final String variation_id;
  final int tax_id;
  product.fromJson(Map<String,dynamic> json,Map<String,dynamic> json2):
        price=json2["default_sell_price"].toString(),
        name=json["product_name"],
        url=json["product_image_url"],
        id=json["product_id"].toString(),
        variation_id=json["variation_id"].toString(),
        price_inc_tax=json2["sell_price_inc_tax"].toString(),
        this.tax_id=json["tax_id"]?? 0;
}

