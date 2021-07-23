import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/bottom_navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_nav_bar/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SelectTable extends StatefulWidget {
  const SelectTable({Key ? key}) : super(key: key);
  @override
  State<SelectTable> createState() => _SelectTableState();
}
class _SelectTableState extends State<SelectTable> {
  bool _isloading = false;
  int _currentIndex = 0;
  List<String> _tablenos = [];
  List<String> _table_status=[];
  List<int> id=[];
  int i=0;
  _SelectTableState() {
    fetchData().then((val) =>
        setState(() {
          _tablenos = val;
        }));
  }
  Future<List<String>> fetchData() async {
    Map data = await getData();
    setState(() {
      _isloading=false;
    });
    List<String> tableno = [];
    for(var i in data['data'])
    {
      tableno.add(i["name"]);
      _table_status.add(i["table_status"]);
      id.add(i["id"]);
      print(id);
    }
    return tableno;
  }
  @override
  void initState() {
    setState(() {
      _isloading=true;
    });
    fetchData();
    super.initState();
  }
  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select table'),
        backgroundColor: Color(0xffffd45f),
      ),
      body: _isloading? Center(
          child: CircularProgressIndicator(color: Color(0xff000066),)):
      GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          i=index;
          return GestureDetector(
            child:Container(
              //height: MediaQuery.of(context).size.height,
              //width:  MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                color:_table_status[i]=="Occupied"?Colors.red:_table_status[i]=="available\t"?Colors.green:Colors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  /*SizedBox(
                    height: 10,
                  ),*/
                  Icon(
                    Icons.table_chart,
                    size: 50,
                    color: Colors.white,
                  ),
                  /*SizedBox(
                    height: 5,
                  ),*/
                  Text(
                    _tablenos[index],
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            onTap: ()async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              if(_table_status[index]=="Occupied")
              {
                print(id[index]);
                Fluttertoast.showToast(
                    msg: "Sorry!....This table is occupied",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.red,
                    timeInSecForIosWeb: 10);
              }
              else {
                sharedPreferences.setString("table_name",_tablenos[index]);
                sharedPreferences.setInt("table_id", id[index]);
                print(sharedPreferences.getInt("table_id"));
                print(_table_status[i]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryScreen()));
              }
            },
          );
        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 25.0,
        mainAxisSpacing: 25.0,
      ),
        itemCount: _tablenos.length ,
      ),
    );
  }
}
Future<Map<String, dynamic>> getData() async {
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  String myUrl = "https://pos.sero.app/connector/api/table";
  http.Response response = await http.get(Uri.parse(myUrl), headers: {
    'Authorization':
    sharedPreferences.getString("Authorization") ?? ''
  });
  return json.decode(response.body);
}