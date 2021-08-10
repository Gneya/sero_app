import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/utsav/notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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

        leading: Icon(Icons.menu),
        title: Center(child: Text("SELECT TABLE",style: GoogleFonts.ptSans(color: Colors.black,fontSize: 18))),
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
      body: _isloading? Center(
          child: CircularProgressIndicator(color: Color(0xff000066),)):
      GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(18),
        itemBuilder: (BuildContext context, int index) {
          i=index;
          return GestureDetector(
            child:Container(
              //height: MediaQuery.of(context).size.height,
              //width:  MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                color:_table_status[i]=="occupied"?Color(0xfffd6360):_table_status[i]=="available"?Color(0xff00af20):Colors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset("images/row_4.png",height: MediaQuery.of(context).size.height/17,),
                  Text(
                    _tablenos[index],
                    style: GoogleFonts.ptSans(fontSize: 16,color: Colors.white),
                  ),
                ],
              ),
            ),
            onTap: ()async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              if(_table_status[index]=="occupied")
    {
    setState(() {
    _isloading = true;
    });
    http.Response response = await http.get(
    Uri.parse(
    "https://pos.sero.app/connector/api/sell?per_page=-1")
    , headers: {
    'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
    });
    var v = (json.decode(response.body));
    var cart=FlutterCart();
    for(var i in v["data"])
    {
    if(i["is_suspend"]==1 && i["res_table_id"]==id[index]) {
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      print(i["id"]);
      sharedPreferences.setInt("order_id", i["id"]);
    cart.deleteAllCart();
      sharedPreferences.setInt("table_id", id[index]);
    for(var x in i["sell_lines"])
    {
    http.Response response = await http.get(
    Uri.parse(
    "https://pos.sero.app/connector/api/product/${x["product_id"]}")
    , headers: {
    'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
    });
    var list=sharedPreferences.getStringList("variation");
    var v = (json.decode(response.body)["data"][0]["name"]);
    print(v);
    list!.add(x["variation_id"].toString());
    sharedPreferences.setStringList("variation", list);
    cart.addToCart(productId: x["product_id"], unitPrice: double.parse(x["unit_price_inc_tax"]),productName: v);
    }
    sharedPreferences.setString("total", cart.getCartItemCount().toString());
    break;
    }
    }
    setState(() {
    _isloading=false;
    });
    }else{
                // String myUrl = "https://pos.sero.app/connector/api/change-table-status";
                // http.Response response = await http.post(Uri.parse(myUrl), headers: {
                //   'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
                // },body: jsonEncode(<String,dynamic>{
                //   "table_id":3,
                //   "table_status":"occupied"
                // }));
                SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                sharedPreferences.setInt("table_id", id[index]);
                Map<String,dynamic> api={
                  "table_id":id[index],
                  "table_status":"occupied"
                };
                var dio=Dio();
                dio.options.headers["Authorization"]="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8";
                        var r=await dio.post("https://pos.sero.app/connector/api/change-table-status",data: json.encode(api));
                        print(r);
                //print(json.decode(response.body));
                print(id[index]);
                setState(() {
                  _isloading=false;
                });
                sharedPreferences.setInt("index", 1);
              }
            },
          );
        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
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
    'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
  });
  return json.decode(response.body);
}