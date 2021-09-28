//Add customer
import 'dart:convert';
import 'package:csc_picker/csc_picker.dart';
import 'package:dio/dio.dart';
import 'package:enhanced_drop_down/enhanced_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_nav_bar/selectable.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sero_app/selecttable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key ? key}) : super(key: key);
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  bool value = false;
  bool value1 = false;
  String _mySelection="";
  final _formKey = GlobalKey<FormState>();
  List data = [];
  DateTime selectedDate = DateTime.now();
  bool value3 = false;
  var countryValue;
  var stateValue;
  var cityValue;
  TextEditingController fname=new TextEditingController();
  TextEditingController mname=new TextEditingController();
  TextEditingController lname=new TextEditingController();
  TextEditingController email=new TextEditingController();
  TextEditingController phone_number=new TextEditingController();
  TextEditingController address=new TextEditingController();
  List<int> id=[];
  List<String> name=[];
  TextEditingController group=new TextEditingController();
  late customer _customer;
  var _isloading=false;
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  Map input={};
  _sendData() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isloading=true;
      });
      SharedPreferences shared=await SharedPreferences.getInstance();
      var response = await http.post(
          Uri.parse("https://seropos.app/connector/api/contactapi"), body: input,
          headers: {
            'Authorization': shared.getString("Authorization")??""
          }
      );
      _customer = customer.fromJson(json.decode(response.body));
      if (_customer.error != "null") {
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(
            msg: _customer.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.red,
            timeInSecForIosWeb: 10);
      }
      else {
        setState(() {
          _isloading = false;
          print(_customer.id);
        });
        Fluttertoast.showToast(
            msg: "Customer added Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.green,
            timeInSecForIosWeb: 10);
        shared.setString("customer_name", _customer.name);
        shared.setString("customer_id", _customer.id);
        setState(() {
          _isloading = false;
        });
        Navigator.pop(context);
      }
    }
  }
  Future<void> getSWData() async {
    setState(() {
      _isloading=true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var dio=Dio();
    dio.options.headers["Authorization"]=sharedPreferences.getString("Authorization");
    var r=await dio.get("https://seropos.app/connector/api/customer-groups");
    print(r.data);
    for(var v in r.data["data"])
    {
      print(v["name"]);
      id.add(v["id"]);
      name.add(v["name"]);
    }
    setState(() {
      _isloading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getSWData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(

          leading: Icon(Icons.menu,),
          title: Center(child: Text("ADD CUSTOMER",style: TextStyle(fontSize: 18),)),
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
        body: _isloading?Center(
            child: CircularProgressIndicator(color: Color(0xff000066),)):Form(
            key: _formKey,
            child:Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "First Name",
                              style: TextStyle(
                                fontFamily: 'AirbnbCerealMedium',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty){
                                return "This field cannot be empty";}
                              return null;
                            },
                            controller: fname,
                            decoration: InputDecoration(
                              hintText: "First Name",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Middle Name",
                              style: TextStyle(
                                fontFamily: 'AirbnbCerealMedium',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: mname,
                            decoration: InputDecoration(
                              hintText: "Middle Name",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Last Name",
                              style: TextStyle(
                                fontFamily: 'AirbnbCerealMedium',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: lname,
                            decoration: InputDecoration(
                              hintText: "Last Name",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    ConstContainer(
                      textcontroller:email,
                      hintText: 'abc@gmail.com',
                      text: 'Email id',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Contact Number(required)",
                              style: TextStyle(
                                fontFamily: 'AirbnbCerealMedium',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value)
                            {
                              if(value!.isEmpty){
                                return "This field cannot be empty";}
                              return null;
                            },
                            controller: phone_number,
                            decoration: InputDecoration(
                              hintText: "Mobile Number",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child:
                        Column(children:[
                          Align(
                            alignment: Alignment.topLeft,
                            child:Text("Country , state and City",style: TextStyle(
                              fontFamily: 'AirbnbCerealMedium',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),),),
                          SizedBox(
                            height: 10,
                          ),
                          CSCPicker(
                            showStates: true,
                            showCities: true,
                            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                            flagState: CountryFlag.DISABLE,

                            ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                            dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                border:
                                Border.all(color: Colors.grey.shade300, width: 1)),

                            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.shade300,
                                border:
                                Border.all(color: Colors.grey.shade300, width: 1)),

                            ///Default Country
                            defaultCountry: DefaultCountry.India,

                            ///selected item style [OPTIONAL PARAMETER]
                            selectedItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                            dropdownHeadingStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),

                            ///DropdownDialog Item style [OPTIONAL PARAMETER]
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),

                            ///Dialog box radius [OPTIONAL PARAMETER]
                            dropdownDialogRadius: 10.0,

                            ///Search bar radius [OPTIONAL PARAMETER]
                            searchBarRadius: 10.0,

                            ///triggers once country selected in dropdown
                            onCountryChanged: (value) {
                              setState(() {
                                ///store value in country variable
                                countryValue = value;
                              });
                            },

                            ///triggers once state selected in dropdown
                            onStateChanged: (value) {
                              setState(() {
                                ///store value in state variable
                                stateValue = value;
                              });
                            },

                            ///triggers once city selected in dropdown
                            onCityChanged: (value) {
                              setState(() {
                                ///store value in city variable
                                cityValue = value;
                              });
                            },
                          ),])),
                    ConstContainer(
                        textcontroller:address,
                        text: 'Home address',
                        hintText:
                        'Flat number, apartment name, locality, city, pin code'),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:
                      Text(
                        "Customer group",
                        style: TextStyle(
                          fontFamily: 'AirbnbCerealMedium',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: EnhancedDropDown.withData(
                        dropdownLabelTitle: "",
                        dataSource: name,
                        defaultOptionText: "Customer group",
                        valueReturned: (chosen) {
                          print(chosen);
                          for(int i=0;i<name.length;i++)
                          {
                            if(name[i]==chosen)
                            {
                              print(name[i]);
                              group.text=id[i].toString();
                              print(id[i]);
                              break;
                            }
                          }
                        },

                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date of birth',
                        style: TextStyle(
                          fontFamily: 'AirbnbCerealMedium',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'AirbnbCerealBook'),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          SizedBox(
                            width: 60,
                            child: RaisedButton(
                              onPressed: () => _selectDate(context), // Refer step 3
                              child: Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  side: BorderSide(color: Color(0xFFfad586), width: 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 180,
                      height: 50,
                      child: CupertinoButton(
                        onPressed:(){
                          input={
                            "type": "customer",
                            "first_name": fname.text,
                            "middle_name": mname.text,
                            "last_name": lname.text,
                            "mobile": phone_number.text,
                            "address_line_1": address.text,
                            "city": cityValue??'',
                            "state": stateValue??'',
                            "country": countryValue??'',
                            "customer_group_id": group.text,
                            "dob": selectedDate.toString(),
                            "email": email.text??""};
                          _sendData();
                        },


                        child: Center(child: Text('DONE',style: TextStyle(fontWeight: FontWeight.bold),)),
                        color: Color(0xFFFFD45F),
                      ),
                    )
                  ],
                ),
              ),
            ))
    );
  }
}

class ConstContainer extends StatelessWidget {
  ConstContainer({required this.text, required this.hintText, required this.textcontroller});
  final String text;
  final String hintText;
  TextEditingController textcontroller=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'AirbnbCerealMedium',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: textcontroller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class DropdownScreen extends StatefulWidget {
  State createState() => DropdownScreenState();
}

class DropdownScreenState extends State<DropdownScreen> {
  late Item selectedUser;
  List<Item> users = <Item>[
    const Item(
        'Android',
        Icon(
          Icons.android,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Flutter',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'ReactNative',
        Icon(
          Icons.format_indent_decrease,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'iOS',
        Icon(
          Icons.mobile_screen_share,
          color: const Color(0xFF167F67),
        )),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Center(child: Image.asset("images/logo.png",height: MediaQuery.of(context).size.height/22,width: MediaQuery.of(context).size.width/3,)),
          backgroundColor: Color(0xffffd45f),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications,color: Colors.grey.shade700,)),
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
        body: Center(
          child: DropdownButton<Item>(
            hint: Text("Select item"),
            value: selectedUser,
            onChanged: (Item? Value) {
              setState(() {
                selectedUser = Value!;
              });
            },
            items: users.map((Item user) {
              return DropdownMenuItem<Item>(
                value: user,
                child: Row(
                  children: <Widget>[
                    user.icon,
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
class customer
{
  final String error;
  final String id;
  final String name;
  customer.fromJson(Map<String,dynamic> Json):
        this.error=Json["error"].toString(),
        this.name=Json["data"]["name"],
        this.id=Json["data"]["id"].toString();
}



