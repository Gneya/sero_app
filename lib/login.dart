import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: _authenticate,
                    //Signup
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
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
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      //email
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email')),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 10.0,
                        shadowColor: Colors.grey.shade100,
                        child: TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This Field cannot be Empty';
                            }
                            return null;
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                              icon: new Icon(Icons.email, color: Colors.grey),
                              hintText: 'Enter your email',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0))),
                        ),
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
                          child: Text('Password')),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 10.0,
                        shadowColor: Colors.grey.shade100,
                        child: TextFormField(
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
                              icon: new Icon(Icons.lock, color: Colors.grey),
                              hintText: 'Password',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //login
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    child: MaterialButton(
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: _authenticate,
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      //remember me
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ), //Text
                            SizedBox(width: 10), //SizedBox
                            Checkbox(
                              activeColor: Color(0xFF325288),
                              value: this.value,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.value = value!;
                                });
                              },
                            ),
                          ]),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //forget password
                  GestureDetector(
                    child: Text('Forgot your password?'),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ForgetPassword(title: '',)),
                      // );
                    },
                  )
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


