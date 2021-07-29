import 'dart:convert';
import 'dart:ui';
//import 'package:barcode_scan/barcode_scan.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
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
import 'package:flutter_nav_bar/productdetails.dart';
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
  Future<void> get() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        _isloading=true;
      });}
    int i=1;
      http.Response response = await http.get(
          Uri.parse("https://pos.sero.app/connector/api/variation?per_page=-1"), headers: {
        'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
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
                                  child:TextField(
                                      controller: _controller,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                          fillColor: Colors.black,
                                          focusColor: Colors.black,
                                          hoverColor: Colors.black,
                                          hintText: "Search..",
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black)
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,color: Colors.black,
                                          ),

                                          suffixIcon: IconButton(
                                            icon:Image.asset("images/barcode.png"),
                                            onPressed:_scanQR,
                                            color: Colors.black,
                                          )
                                      ),
                                      onChanged: (value){
                                        _handleSearchStart();
                                        searchOperation(value);
                                      }
                                  ),),
                                // GestureDetector(child:Icon(Icons.search),
                                //   onTap: (){
                                //        Navigator.push(
                                //        context,
                                //        MaterialPageRoute(
                                //        builder: (context) => searchproduct()));
                                //   },
                                // ),
                                //
                                // Text(
                                //   "Search Category",
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //   ),
                                // ),


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
