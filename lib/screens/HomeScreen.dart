//Home Screen
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/screens/Category.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:flutter_nav_bar/screens/edit_customer.dart';
import 'package:flutter_nav_bar/main_drawer.dart';
import 'package:flutter_nav_bar/screens/selectable.dart';
import 'package:flutter_nav_bar/dialog/notification.dart';
import 'package:flutter_nav_bar/screens/resume_screen.dart';
import 'package:flutter_nav_bar/dialog/void.dart';
import 'package:flutter_nav_bar/tab/pesonal_details_tab.dart';
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
  List<int> types_of_service_id=[];
  List<String> types_of_service_name=[];
  String hint="Walk In Customer";

  final TextEditingController _typeAheadController = TextEditingController();
  fetch()
  async {
    print("round"+(3.4).round().toString());
    if(mounted){
      setState(() {
        _isloading = true;
      });}
    var cart =FlutterCart();
    int flag=0;
    //clearing shared pref
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("total",cart.getCartItemCount().toString());
    var list=sharedPreferences.getStringList("selected")??[];
    sharedPreferences.setString("method", "cash");
    sharedPreferences.setDouble("Discountt_for_db", 0);
    sharedPreferences.setString("order_id","");
    sharedPreferences.setString("invoice", "");
    sharedPreferences.setInt("Redeemed Points",0);
    sharedPreferences.setDouble("Shipping", 0.0);
    sharedPreferences.setString("products","");
    sharedPreferences.setBool("split", false);
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
    sharedPreferences.setInt("table_id", 0);
    var Response = await http.get(
        Uri.parse("https://seropos.app/connector/api/user/loggedin"),
        headers: {
          'Authorization': sharedPreferences.getString("Authorization")??""
        });
    var d = json.decode(Response.body.toString());
    if(mounted){
      setState(() {
        //fetching details of loggedin user
        _name = d["data"]["first_name"];
        //fetching bussiness location
        sharedPreferences.setInt("bid",d["data"]["business_id"]);
        print("BIDDDDDDDDD:"+sharedPreferences.getInt("bid").toString());
      });}
    //fetching enabled_modules from api
    var Response1 = await http.get(
        Uri.parse("https://seropos.app/connector/api/business-details"),
        headers: {
          'Authorization': sharedPreferences.getString("Authorization")??""
        });
    var r1=json.decode(Response1.body);
    var types_of_service=r1["data"]["enabled_modules"];
    print(types_of_service);
    //fetching types of service enabled from api
    for(var v in types_of_service)
      {
        if(v=="types_of_service")
          {
            flag=1;
            break;
          }
      }
    if(flag==1) {
      var Response2 = await http.get(
          Uri.parse("https://seropos.app/connector/api/types-of-service"),
          headers: {
            'Authorization': sharedPreferences.getString("Authorization") ?? ""
          });
      var r2=json.decode(Response2.body);
      for(var x in r2["data"])
        {
          types_of_service_id.add(x["id"]);
          types_of_service_name.add(x["name"]);
        }
      print(types_of_service_name);
    }
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
  var cid="0";
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
  //more option(clear,table,void and resume)
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
            margin: EdgeInsets.only(right: 6,bottom: 15,top: 10,left: 6),
            child: CircleAvatar(
              backgroundColor:Colors.transparent,
                backgroundImage: AssetImage("images/icon-b-s.png")
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
      backgroundColor: Color(0xfff5f5f5),
      body:  _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),)):Padding(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child: SingleChildScrollView(
          child: Center(
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
                Container(
                  width:MediaQuery.of(context).size.width < 650 ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width/2.3,
                  child: Material(
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
                                        MediaQuery.of(context).size.width < 650 ?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PersonalDetails())):
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PersonalDetailsTab()))
                                        ;
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
                                cid=suggestion.cid;
                                id=suggestion.id;
                                print("ID IS:$id");
                                print("NAME :${suggestion._name}");
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
                ),
                SizedBox(
                  height: 40,
                ),
                Text('Select Mode',style: GoogleFonts.ptSans(fontSize: 22),),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width:MediaQuery.of(context).size.width < 650 ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width/2.3,
                  height: MediaQuery.of(context).size.height/3,
                  child: ListView.builder(
                      itemCount: types_of_service_id.length,
                      itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10,bottom: 10),
                      height: MediaQuery.of(context).size.height/12,
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
                            if(types_of_service_id[index]==1){
                            SharedPreferences shared=await SharedPreferences.getInstance();
                            shared.setInt("types_of_service_id",1);
                            if(shared.getString("customer_name")=="")
                            {
                              shared.setString("customer_name", "Walk-In Customer");
                              shared.setString("customer_id","1");
                              shared.setInt("types_of_service_id",1);
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectTable()));
                          }
                            else if(types_of_service_id[index]==2){
                              SharedPreferences shared=await SharedPreferences.getInstance();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => CategoryScreen()));
                              shared.setInt("types_of_service_id",2);
                              if(shared.getString("customer_name")=="")
                              {
                                shared.setString("customer_name", "Walk-In Customer");
                                shared.setString("customer_id","1");
                              }
                              shared.setInt("index", 1);
                            }
                            else if(types_of_service_id[index]==3)
                              {
                               dev();
                              }
                            else{}
                            },
                          child: Text(types_of_service_name[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSans(fontSize: 18)),
                        ),
                      ),
                    );
                  } ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dev() async {
    print(id);
    SharedPreferences shared=await SharedPreferences.getInstance();
    if(id!="0") {
      shared.setInt("types_of_service_id",3);
      setState(() {
        _isloading=true;
      });
      print(id);
      shared.setInt("types_of_service_id", 3);
      var response = await http.get(
          Uri.parse(
              "https://seropos.app/connector/api/contactapi?contact_id=$cid"),
          headers: {
            'Authorization': shared.getString(
                "Authorization") ?? ""
          });
      print(json.decode(response.body));
      final d = json.decode(response.body)["data"][0];
      print(d);
      var fname = d["first_name"];
      var mname = d["middle_name"];
      var lname = d["last_name"];
      var email_id = d["email"];
      var phone = d["mobile"];
      var city = d["city"];
      var state = d["state"];
      var country = d["country"];
      var address = d["address_line_1"] ??
          d["address_line_2"];
      var dob = d["dob"];
      if (address == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    edit_customer(id: id,
                        fname: fname,
                        mname: mname,
                        lname: lname,
                        email_id: email_id,
                        phone: phone,
                        city: city,
                        state: state,
                        country: country,
                        dob: dob)));
        setState(() {
          _isloading = false;
        });
      }
      else {
        SharedPreferences share = await SharedPreferences
            .getInstance();
        share.setInt("index", 1);
      }

      setState(() {
        _isloading=false;
      });
    }
  }
}
class Customer
{
  final String _name;
  final String _phone;
  final String cid;
  final String id;
  Customer.fromJson(Map<String,dynamic> json):
        this._name=json["first_name"]??json["name"],
        this._phone=json["mobile"],
        this.cid=json["contact_id"].toString(),
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
        Uri.parse("https://seropos.app/connector/api/contactapi/?per_page=-1"),
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


