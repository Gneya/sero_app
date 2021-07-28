import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/HomeScreen.dart';
import 'package:flutter_nav_bar/main.dart';
import '';
class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key ? key, required this.title}) : super(key: key);

  final String title;

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  bool value = false;
  TextStyle style = TextStyle(fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFD45F),
        body: Center(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //logo
                      Image.asset(
                        'images/x.png',
                        height: 130.0,
                        width: 180.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      //welcome back
                      Text(
                        'Forgot Password?',
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
                              alignment: Alignment.center,
                              child: Text('Enter your registered email address',style:TextStyle(fontSize:18),)),
                          SizedBox(
                            height: 40,
                          ),
                         TextFormField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  prefixIcon: new Icon(Icons.email, color: Colors.grey,),
                                  labelText: "Enter email",
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 3.0))),
                            ),
                        ],
                      ),
                      //password
                      SizedBox(
                        height: 30,
                      ),
                      //signup
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          },
                          child: Text("Submit",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text('Resend',style:TextStyle(fontSize:15,color: Colors.indigo)),
                      ),
                    ]
                ),
              ),
            ),
          ),
        )
    );
  }
}


