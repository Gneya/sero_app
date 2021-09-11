import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/selectable.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'addons_and_modifiers.dart';

class SelectItem extends StatefulWidget {
  String category;
  List<String> selectedItems = [];
  List<String> selectedItemsprice = [];
  SelectItem({Key ? key,required this.category,required this.selectedItemsprice,required this.selectedItems});

  @override
  State<SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {
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
  Future<void> get() async {
    setState(() {
      _isloading = true;
    });
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
    int i=1;
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    http.Response response = await http.get(
        Uri.parse("https://seropos.app/connector/api/variation/?per_page=-1"), headers: {
      'Authorization': sharedPreferences.getString("Authorization")??""
    });
    v = (json.decode(response.body));
    for (var i in v["data"]) {
      if (i["category"] == widget.category) {
        print(i);
        if(i["not_for_selling"]==0){
          _product=product.fromJson(i);
          _productlist.add(_product);
          print(_productlist);
        }
      }
    }
    i++;
    print(_productlist);
    setState(() {
      _isloading = false;
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
      var list = sharedPreferences.getStringList("variation");
      http.Response response = await http.get(
          Uri.parse("https://seropos.app/connector/api/variation/?name=${v["data"][0]["name"]}"), headers: {
        'Authorization': sharedPreferences.getString("Authorization")??""
      });
      print("IDDDDDDDDDD");
      print(json.decode(response.body)["data"][0]["variation_id"].toString());
      list!.add(json.decode(response.body)["data"][0]["variation_id"].toString());
      //print(suggestion.variation_id);
      sharedPreferences.setStringList("variation", []);
      sharedPreferences.setStringList("variation", list);
      String s=v["data"][0]["name"]+" added to cart";
      var price=v["data"][0]["product_variations"][0]["variations"][0]["default_sell_price"];
      print(price);
      cart.addToCart(productId:v["data"][0]["id"], unitPrice: double.parse(v["data"][0]["product_variations"][0]["variations"][0]["default_sell_price"]),productName: v["data"][0]["name"]);
      Fluttertoast.showToast(
          msg: s,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.green,
          timeInSecForIosWeb: 4 );

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }
  @override
  void initState() {
    get();
    super.initState();
  }
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void searchOperation(String searchText) {
    searchresult.clear();
    searchresultImages.clear();
    searchresultprice.clear();
    if (_isSearching == true && searchText!="") {
      for (int i = 0; i < _productlist.length; i++) {
        print(i);
        String data = _productlist[i].name;
        var img=_productlist[i].url;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
          searchresultImages.add(img);
          print(searchresult);
          print(searchresultImages);
          searchresultprice.add(_productlist[i].price);
        }
      }
    }
  }
  int _currentIndex = 0;
  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });}
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
                  height:180,
                  child:Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Column(
                      children:[Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              alignment: Alignment.topLeft,
                              icon: const Icon(Icons.menu,),
                              onPressed: () {
                              },
                            ),
                            Text(widget.category.toUpperCase(),style: GoogleFonts.ptSans(color: Colors.black,fontSize: 18)),
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
                          ]),
                        /*Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [*/
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
                              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
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
                                          print("IDDDDDDDDDD");
                                          SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                                          var cart=FlutterCart();
                                          print(suggestion!.id);
                                          cart.addToCart(productId: double.parse(suggestion!.id), unitPrice: double.parse(suggestion._phone),productName: suggestion!._name);
                                          //hint=suggestion!._name;
                                          //_typeAheadController.text=suggestion._name;
                                          var list = sharedPreferences.getStringList("variation");
                                          http.Response response = await http.get(
                                              Uri.parse("https://seropos.app/connector/api/variation/?name=${suggestion._name}"), headers: {
                                            'Authorization': sharedPreferences.getString("Authorization")??""
                                          });
                                          print("IDDDDDDDDDD");
                                          print(json.decode(response.body)["data"][0]["variation_id"].toString());
                                          list!.add(json.decode(response.body)["data"][0]["variation_id"].toString());
                                          //print(suggestion.variation_id);
                                          sharedPreferences.setStringList("variation", []);
                                          sharedPreferences.setStringList("variation", list);
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
          toolbarHeight: 170,
          backgroundColor: Colors.white,
        ),
        /*'Select your food item'-*/

        body: _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)):searchresult.length != 0 || _controller.text.isNotEmpty?
        GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(10),
            itemCount: searchresult.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 22.0,
              mainAxisSpacing: 25.0,

            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 4,
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
                    Container(
                      height: MediaQuery.of(context).size.height/14,
                      width: MediaQuery.of(context).size.width/4,
                      child: Image.network(searchresultImages[index]),
                    ),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 25,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Center(
                        child: searchresult[index].length>15?Text(
                          searchresult[index].substring(0,13),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
                        ):Text(
                          searchresult[index],
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
                        ),),
                    )],
                ),
              ),
                  onTap: () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    if(sharedPreferences.getString("customer_name")=="")
                    {
                      Fluttertoast.showToast(
                          msg: "Please select thre customer and table first",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.green,
                          timeInSecForIosWeb: 4);
                    }
                    else {
                      print(_productlist[index].id);
                      http.Response response = await http.get(
                          Uri.parse(
                              "https://seropos.app/connector/api/product/${_productlist[index]
                                  .id}")
                          , headers: {
                        'Authorization': sharedPreferences.getString("Authorization")??""
                      });
                      var v = (json.decode(response.body));
                      //print(v["data"][0]["modifiers"]);
                      List<dynamic> check = v["data"][0]["modifiers"];
                      List<String> modifiers = [];
                      if (check.isNotEmpty) {
                        for (var _mod in v["data"][0]["modifiers"][0]) {
                          print(_mod["name"]);
                          modifiers.add(_mod["name"]);
                        }
                      }
                      if (modifiers.isEmpty) {
                        var list = sharedPreferences.getStringList("selected");
                        var listofprice = sharedPreferences.getStringList(
                            "selectedprice");
                        //_selectedItems.add(name[index]);
                        setState(() {
                          var _price = searchresultprice[index];
                          var product = searchresult[index];
                          list!.add(product);
                          listofprice!.add(_price);
                          sharedPreferences.setStringList("selected", []);
                          sharedPreferences.setStringList("selected", list);
                          sharedPreferences.setStringList("selectedprice", []);
                          sharedPreferences.setStringList(
                              "selectedprice", listofprice);
                        });
                        print(sharedPreferences.getStringList("selected"));
                        Fluttertoast.showToast(
                            msg: "Item added to cart",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.green,
                            timeInSecForIosWeb: 4);
                      }
                      else {
                        // showDialog(context: context, builder: (context) {
                        //   return add(modifiers: modifiers);
                        // });
                      }
                    }});
            }):GridView.builder(
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
                      "price_inc_tax":_productlist[index].price_inc_tax
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
    );
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
  product.fromJson(Map<String,dynamic> json):
        price=json["default_sell_price"],
        name=json["product_name"],
        url=json["product_image_url"],
        id=json["product_id"].toString(),
        variation_id=json["variation_id"].toString(),
        price_inc_tax=json["sell_price_inc_tax"],
        this.tax_id=json["tax_id"];
}
class Customer
{
  final String _name;
  final String _phone;
  final String id;
  final String variation_id;
  Customer.fromJson(Map<String,dynamic> json):
        this._name=json["name"],
        this._phone=json["product_variations"][0]["variations"][0]["default_sell_price"],
        this.id=json["id"].toString(),
        this.variation_id=json["product_variation_id"].toString();


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
          'Authorization': shared.getString("Authorization")??""
        });
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


