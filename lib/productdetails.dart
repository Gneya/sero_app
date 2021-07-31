import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
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
  var cart=FlutterCart();
  late product _product;
  List<product> _productlist=[];
  bool _isSearching=false;
  List<String> searchresult = [];
  List<String> searchresultImages = [];
  List<String> searchresultprice=[];
  List<String> images = [];
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
          Uri.parse("https://pos.sero.app/connector/api/variation/?per_page=-1"), headers: {
        'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
      });
      v = (json.decode(response.body));
      for (var i in v["data"]) {
        if (i["category"] == widget.category) {
          _product=product.fromJson(i);
          _productlist.add(_product);
          print(_productlist);
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
        Uri.parse("https://pos.sero.app/connector/api/product?sku=$barcodeScanRes"), headers: {
      'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
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
          timeInSecForIosWeb: 10);

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
                  height:150,
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
                                        var cart=FlutterCart();
                                        cart.addToCart(productId: double.parse(suggestion!.id), unitPrice: double.parse(suggestion._phone),productName: suggestion!._name);
                                        //hint=suggestion!._name;
                                        //_typeAheadController.text=suggestion._name;
                                        Fluttertoast.showToast(
                                            msg:suggestion._name+" is selected",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            textColor: Colors.green,
                                            timeInSecForIosWeb: 10);
                                        SharedPreferences prefs= await SharedPreferences.getInstance();
                                        print(prefs.getString("customer_name"));
                                        prefs.setString("customer_name",suggestion._name);
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
          toolbarHeight: 130,
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
                            timeInSecForIosWeb: 10);
                      }
                    else {
                      print(_productlist[index].id);
                      http.Response response = await http.get(
                          Uri.parse(
                              "https://pos.sero.app/connector/api/product/${_productlist[index]
                                  .id}")
                          , headers: {
                        'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
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
                            timeInSecForIosWeb: 10);
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
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height/14,
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
                    if(sharedPreferences.getString("customer_name")=="")
                    {
                      Fluttertoast.showToast(
                          msg: "Please select the customer and table first",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.green,
                          timeInSecForIosWeb: 10);
                    }
                    else{
                      cart.addToCart(productId: _productlist[index].id, unitPrice: double.parse(_productlist[index].price),productName: _productlist[index].name);
                    http.Response response = await http.get(
                        Uri.parse(
                            "https://pos.sero.app/connector/api/product/${_productlist[index].id}")
                        ,  headers: {
                      'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
                    });
                    var v = (json.decode(response.body));
                    //print(v["data"][0]["modifiers"]);
                    List<dynamic> check = v["data"][0]["modifiers"];
                    List<String> modifiers = [];
                    List<String> _modifiers_price=[];
                    if (check.isNotEmpty) {
                      for (var _mod in v["data"][0]["modifiers"][0]) {
                        print(_mod["name"]);
                        print(_mod["sell_price_inc_tax"]);
                        _modifiers_price.add(_mod["sell_price_inc_tax"]);
                        modifiers.add(_mod["name"]);
                      }
                    }
                    if (modifiers.isNotEmpty) {
                      showDialog(context: context, builder: (context) {
                        return add(modifiers: modifiers,product: _productlist[index].name,price:_modifiers_price);
                      });
                    }
                    //_selectedItemsprice.add(price[index]);
                    Fluttertoast.showToast(
                        msg: "Item added to cart",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.green,
                        timeInSecForIosWeb: 10);
                  }}
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
  product.fromJson(Map<String,dynamic> json):
        price=json["sell_price_inc_tax"],
        name=json["product_name"],
        url=json["product_image_url"],
        id=json["product_id"].toString();
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
    var response = await http.get(
        Uri.parse("https://pos.sero.app/connector/api/product/?per_page=-1"),
        headers: {
          'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8" ??
              ''
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