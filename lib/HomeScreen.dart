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
  String hint="Search Customer";
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
    if(mounted){
    setState(() {
      _isloading = true;
    });}
    var cart =FlutterCart();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("total",cart.getCartItemCount().toString());
    var list=sharedPreferences.getStringList("selected")??[];
    sharedPreferences.setString("order_id","");
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
          'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
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
                      setState(() {
                        _isloading=true;
                      });
                      var response = await http.get(
                          Uri.parse("https://pos.sero.app/connector/api/contactapi/$id"),
                          headers: {
                            'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
                          });
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

    late Customer cus;
      var response = await http.get(
          Uri.parse("https://pos.sero.app/connector/api/contactapi/?per_page=-1"),
          headers: {
            'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
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