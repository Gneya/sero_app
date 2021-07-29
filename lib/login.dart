import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nav_bar/forgetpassword.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'dart:convert';
// import 'package:sero_app/forget_password.dart';
import 'package:http/http.dart' as http;
class login extends StatefulWidget {


  @override
  loginState createState() => loginState();
}

class loginState extends State<login> {
  bool value = false;
  late Model _model;
  bool _isloading=false;
  TextStyle style = TextStyle(fontSize: 20.0);
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _authenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map input = {
      "grant_type": "password",
      "client_id": "3",
      "client_secret": "68JlhAmkiaF9vE42LhscvkSDmyqgJantfpvFhXZp",
      "username": email.text,
      "password": password.text,
      "scope": ""
    };
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      var response = await http.post(
          Uri.parse("https://pos.sero.app/oauth/token"), body: input);
      var v= json.decode(response.body);
      print(v);
      //print(m["Authorization"]);
      _model = Model.fromJson(json.decode(response.body.toString()));
      setState(() {
        _isloading = false;
      });
      if (_model.error == null||_model.error == ''){
        Map m= {
          "Authorization": v["access_token"],
        };
        var s=_model.type+" "+m["Authorization"];
        sharedPreferences.setString("Authorization",s);
        print(sharedPreferences.getString("Authorization"));
        if(this.value==true) {
          sharedPreferences.setString("user_id", email.text);
          print(sharedPreferences.getString("user_id"));
        }
        setState(() {
          _isloading=false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
      else {
        Fluttertoast.showToast(
            msg: _model.error??'' + " : " ,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.red,
            timeInSecForIosWeb: 10);
      }
    }
    else
    {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffd45f),
      body: _isloading
          ? Center(
          child: CircularProgressIndicator(color: Color(0xff000066),))
          : Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top:3,left: 40,right: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //logo
                  Image.asset(
                    'images/logo.png',
                    height: 130.0,
                    width: 180.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  //welcome back
                  Text(
                    'Welcome back',
                      style: GoogleFonts.ptSans(color: Color(0xff000000),fontSize: 22)
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      //email
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email',style: GoogleFonts.ptSans(color: Color(0xff000000),fontSize: 16),)),
                      SizedBox(
                        height: 10,
                      ),
                     TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field cannot be Empty';
                            }
                            return null;
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: new Icon(Icons.email, color: Colors.grey),
                              hintText: 'Enter your email',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0))),
                        ),
                    ],
                  ),
                  //password
                  SizedBox(
                    height: 30,
                  ),
                  //passsword
                  Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password',style: GoogleFonts.ptSans(color: Color(0xff000000),fontSize: 16))),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This Field cannot be Empty';
                            }
                            return null;
                          },
                          obscureText: true,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: new Icon(Icons.lock, color: Colors.grey),
                              hintText: 'Password',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0))),
                        ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          height: 14,
                          width: 14,
                          child: Checkbox(
                            activeColor: Color(0xFF325288),
                            value: this.value,

                            onChanged: (bool? value) {
                              setState(() {
                                this.value = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ), //Text//SizedBox
                      ]),
                  SizedBox(height: 25,),
                  //login
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xff1b2d61),
                    child: MaterialButton(
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width/3,
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      onPressed: _authenticate,
                      child: Text("LOG IN",
                          textAlign: TextAlign.center,
                          style:GoogleFonts.ptSans(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20)
                             )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //forget password
                  GestureDetector(
                    child: Text('Forgot your password?',style: GoogleFonts.ptSans(color: Color(0xff26315f),fontSize: 16),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassword(title: '',)),
                      );
                    },
                  ),
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Not yet Registered?",style: GoogleFonts.ptSans(color: Color(0xff97979b),fontSize: 16),),
                        TextButton(
                          onPressed: _authenticate,
                          //Signup
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.ptSans(color: Colors.black,fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class Model
{
  final String? error;
  final String? error_description;
  var type;
  var access_token;
  Model.fromJson(Map<String,dynamic>Json):
        error=Json["error"]??'',
        error_description=Json["error_description"],
        type=Json["token_type"]??'',
        access_token=Json["access_token"];

}


