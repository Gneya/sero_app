import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/edit_customer.dart';
import 'package:flutter_nav_bar/main_drawer.dart';
import 'package:flutter_nav_bar/selectable.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:flutter_nav_bar/utsav/resume_screen.dart';
import 'package:flutter_nav_bar/utsav/void.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personaldetails.dart';
// import 'package:sero_app/selecttable.dart';
// import 'package:sero_app/forget_password.dart';
// import 'package:sero_app/searchCustomer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key,  required this.title}) : super(key: key);

  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextStyle style = TextStyle(fontSize: 20.0,fontFamily: 'Product Sans');
  bool value = false;
  bool value1 = false;
  String _selectedAnimal="";
  int _currentIndex = 0;
  bool _isloading = false;
  late String _name;
  String hint="Walk In Customer";
  final List<String> _suggestions = [
    'Alligator',
    'Buffalo',
    'Chicken',
    'Dog',
    'Eagle',
    'Frog'
  ];

  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity="";
  fetch()
  async {
    print("round"+(3.4).round().toString());
    if(mounted){
    setState(() {
      _isloading = true;
    });}
    var cart =FlutterCart();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("total",cart.getCartItemCount().toString());
    var list=sharedPreferences.getStringList("selected")??[];
    sharedPreferences.setString("order_id","");
    sharedPreferences.setString("invoice", "");
    sharedPreferences.setInt("Redeemed Points",0);
    if(list.length>0) {
      for (int i = 0; i < list.length; i++) {
        if (sharedPreferences.containsKey(list[i])) {
          sharedPreferences.setStringList(list[i], []);
          sharedPreferences.setStringList(list[i] + "price", []);
        }
      }
    }
    sharedPreferences.setStringList("selected", []);
    sharedPreferences.setStringList("selectedprice", []);
    sharedPreferences.setString("customer_name", "");
    sharedPreferences.setStringList("quantity", []);
    sharedPreferences.setString("modifiers","");
    var Response = await http.get(
        Uri.parse("https://pos.sero.app/connector/api/user/loggedin"),
        headers: {
          'Authorization': sharedPreferences.getString("Authorization")??""
        });
    var d = json.decode(Response.body.toString());
    if(mounted){
    setState(() {
      _name = d["data"]["first_name"];
      sharedPreferences.setInt("bid",d["data"]["business_id"]);
      print("BIDDDDDDDDD:"+sharedPreferences.getInt("bid").toString());
    });}
    if(mounted){
    setState(() {
      _isloading = false;
    });}
  } setBottomBarIndex(index) {
    if(mounted){
    setState(() {
      _currentIndex = index;
    });}
  }

  @override
  void initState() {
    // TODO: implement initState

    fetch();
    super.initState();
  }
  var id="0";
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
              var r2=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api1));
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
      drawer: MainDrawer(),
      appBar: AppBar(

        //leading: Icon(Icons.menu),
        title: Center(child: Image.asset("images/logo.png",height: MediaQuery.of(context).size.height/22,width: MediaQuery.of(context).size.width/3,)),
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
            child: CircleAvatar(
                backgroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500')
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
      backgroundColor: Color(0xfff5f5f5),
      body:  _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)):Padding(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 60.0,
              ),
              Text(
                _name,
                style:GoogleFonts.ptSans(fontSize: 22)),
              SizedBox(
                height: 30,
              ),
              Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: const Color(0xFFFFD45F),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {},
                    child: Container(
                        padding: EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height/22,
                        child:TypeAheadField<Customer>(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: hint,
                                suffixIcon: IconButton(
                                  icon:Icon(Icons.person_add_rounded),
                                  padding: EdgeInsets.zero,
                                  color: Colors.black,
                                  onPressed:(){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PersonalDetails()));
                                     } ,
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
                              title: Text(content._name+"  ("+content._phone+")"),
                            );
                          },
                          onSuggestionSelected: (Customer? suggestion) async {
                            hint=suggestion!._name;
                            id=suggestion.id;
                            print("ID IS:$id");
                            _typeAheadController.text=suggestion._name;
                            Fluttertoast.showToast(
                                msg:suggestion._name+" is selected",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.green,
                                timeInSecForIosWeb: 10);
                            SharedPreferences prefs= await SharedPreferences.getInstance();
                            print(prefs.getString("customer_name"));
                            prefs.setString("customer_name",suggestion._name);
                            prefs.setString("customer_id",suggestion.id);
                          },
                          suggestionsCallback: CustomerApi.getUserSuggestion,
                        )

                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              Text('Select Mode',style: GoogleFonts.ptSans(fontSize: 22),),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                    onPressed: () async {
                      // Phoenix.rebirth(context);
                     SharedPreferences shared=await SharedPreferences.getInstance();
                      if(shared.getString("customer_name")=="")
                        {
                            shared.setString("customer_name", "Walk-In Customer");
                            shared.setString("customer_id","1");
                        }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectTable()));
                    },
                    child: Text("Dine in",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(fontSize: 18)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left:20,right: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      SharedPreferences shared=await SharedPreferences.getInstance();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CategoryScreen()));
                      if(shared.getString("customer_name")=="")
                      {
                        shared.setString("customer_name", "Walk-In Customer");
                        shared.setString("customer_id","1");
                      }
                      shared.setInt("index", 1);
                    },
                    child: Text("Take Away",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(fontSize: 18)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      SharedPreferences shared=await SharedPreferences.getInstance();
                      setState(() {
                        _isloading=true;
                      });
                      var response = await http.get(
                          Uri.parse("https://pos.sero.app/connector/api/contactapi/$id"),
                          headers: {
                            'Authorization': shared.getString("Authorization")??""
                          });
                      print(json.decode(response.body));
                      final d = json.decode(response.body)["data"][0];
                      print(d);
                      var fname=d["first_name"];
                      var mname=d["middle_name"];
                      var lname=d["last_name"];
                      var email_id=d["email"];
                      var phone=d["mobile"];
                      var city=d["city"];
                      var state=d["state"];
                      var country=d["country"];
                      var address=d["address_line_1"]??d["address_line_2"];
                      var dob=d["dob"];
                      if(address==null)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => edit_customer(id:id,fname: fname,mname:mname,lname: lname,email_id: email_id,phone: phone,city: city,state: state,country: country,dob: dob)));
                       setState(() {
                         _isloading=false;
                       });
                        }
                      else{
                        SharedPreferences share=await SharedPreferences.getInstance();
                        share.setInt("index", 1);
                      }
                      setState(() {
                        _isloading=false;
                      });
                    },
                    child: Text("Home Delivery",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(fontSize: 18)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomSheet:_currentIndex == 3 ? Container(
      //   height: 50,
      //   color: Colors.black,
      // ):Container(
      //   height: 50,
      //   color: Colors.blue,
      // ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class Customer
{
  final String _name;
  final String _phone;
  final String id;
  Customer.fromJson(Map<String,dynamic> json):
        this._name=json["first_name"]??json["name"],
        this._phone=json["mobile"],
        this.id=json["id"].toString();

}
class CustomerApi {
  static Future<List<Customer>> getUserSuggestion(String query)
  async {
    int i = 1;
    var pages;
    List<Customer>name = [];
    SharedPreferences shared=await SharedPreferences.getInstance();
    late Customer cus;
      var response = await http.get(
          Uri.parse("https://pos.sero.app/connector/api/contactapi/?per_page=-1"),
          headers: {
            'Authorization': shared.getString("Authorization")??""
          });
      final List d = json.decode(response.body)["data"];
      pages=json.decode(response.body);
      print(d);
      name.addAll(d.map((e) => Customer.fromJson(e)).where((element) {
        final name = element._name.toLowerCase();
        final _name = query.toLowerCase();
        final phone = element._phone;
        final _phone = query;
        if (name.contains(_name))
          return name.contains(_name);
        else if(phone.contains(_phone))
          return phone.contains(_phone);
        else
          return false;
      }
      ).toList());
    return name;
  }
}