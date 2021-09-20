import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({Key? key}) : super(key: key);

  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  List<int> id=[];
  List<Map<String,dynamic>> list=[];
  List<dynamic> list_of_products=[];
  Map<String,dynamic> map={};
  List<int> total_list=[];
  List<double> price=[];
  List<String> _name=[];
  bool _isloading = false;
  Future<void> _resume() async {
    SharedPreferences shared=await SharedPreferences.getInstance();
    setState(() {
      _isloading = true;
    });
    http.Response response = await http.get(
        Uri.parse(
            "https://seropos.app/connector/api/sell?per_page=-1")
        ,  headers: {
      'Authorization': shared.getString("Authorization")??""
    });
    var v = (json.decode(response.body));
    for(var i in v["data"])
    {
      if(i["is_suspend"]==1)
      {
        int count=0;
        id.add(i["id"]);
        double sum=0;
        List<double> price_of_indiviual=[];
        List<String> price_of_indiviual_with_tax=[];
        List<int> pid=[];
        List<String> vid=[];
        List<int> tax=[];
        List<int> quantity=[];
        List<String> note=[];
        for(var c in i["sell_lines"])
        {
          count++;
          tax.add(c["tax_id"]??0);
          price_of_indiviual_with_tax.add(c["unit_price_inc_tax"]??0);
          quantity.add(c["quantity"]??1);
          note.add(c["sell_line_note"]??"");
          price_of_indiviual.add(double.parse(c["unit_price"].toString()));
          sum+=double.parse(c["unit_price"]);
          pid.add(c["product_id"]??0);
          vid.add(c["variation_id"].toString()??'');
        }
        total_list.add(count);
        var cid=i["contact_id"];
        http.Response response = await http.get(
            Uri.parse(
                "https://seropos.app/connector/api/contactapi/$cid")
            ,  headers: {
          'Authorization': shared.getString("Authorization")??""
        });
        _name.add(json.decode(response.body)["data"][0]["name"].toString());
        price.add(sum);
        print(pid);
        map={
          "order_id":i["id"],
          "table_id":i["res_table_id"],
          "invoice_no":i["invoice_no"],
          "cus_name":json.decode(response.body)["data"][0]["name"].toString(),
          "pid":pid,
          "vid":vid,
          "total_price":sum,
          "tax_id":tax,
          "quantity":quantity,
          "note":note,
          "price_of_indiviual":price_of_indiviual,
          "price_of_indiviual_with_tax":price_of_indiviual_with_tax,
          "count":count
        };
        list.add(map);
        print(list);
        // print(map);
      }
    }
    setState(() {
      _isloading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _resume();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isloading ? Center(child:CircularProgressIndicator(color: Color(0xff000066),)): Dialog(
        insetPadding: EdgeInsets.only(left: 20,right: 20,top: 0),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child:
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('HOLD SALES',
                        style: GoogleFonts.ptSans(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    height:500,
                    child: ListView.builder
                      (
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index)
                      {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0,bottom: 15),
                          child: Container(
                              padding: EdgeInsets.only(top:20),
                              height: MediaQuery.of(context).size.height/3.5,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(
                                      1.0,
                                      1.0,
                                    ), //Offset
                                    blurRadius: 6.0,
                                    spreadRadius: 1.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ),],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        //     Icon(Icons.edit),
                                        //     Text('Something'),
                                        //   ],
                                        // ),
                                        Text(list[index]["invoice_no"].toString()),
                                        // Text('Date'),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person),
                                            Text(_name[index]),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.category_outlined),
                                            Text('Total Items: '+list[index]["count"].toString()),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.money_outlined),
                                            Text('Total Amount: '+double.parse(list[index]["total_price"].toString()).toStringAsFixed(2)),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        // Text('Table: '),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Edit Sale'),
                                              Icon(Icons.arrow_forward_outlined),
                                            ],
                                          ),
                                          onTap: () async {
                                            SharedPreferences shared=await SharedPreferences.getInstance();
                                            shared.setString("order_id", list[index]["order_id"].toString());
                                            print(shared.getString("order_id"));
                                            shared.setInt("table_id", list[index]["table_id"]);
                                            shared.setString("invoice_no", list[index]["invoice_no"]);
                                            print( list[index]["invoice_no"]);
                                            var cart=FlutterCart();
                                            cart.deleteAllCart();
                                            for(int i=0;i<list[index]["pid"].length;i++) {
                                              Map m={
                                                "pid":list[index]["pid"][i],
                                                "tax_id":list[index]["tax_id"][i],
                                                "price_inc_tax":list[index]["price_of_indiviual_with_tax"][i],
                                                "note":list[index]["note"][i]??""
                                              };
                                              list_of_products.add(m);
                                              http.Response response = await http.get(
                                                  Uri.parse(
                                                      "https://seropos.app/connector/api/product/${list[index]["pid"][i]}")
                                                  ,  headers: {
                                                'Authorization': shared.getString("Authorization")??""
                                              });
                                              var v = (json.decode(response.body)["data"][0]["name"]);
                                              print(v);
                                              cart.addToCart(
                                                  productId: list[index]["pid"][i],
                                                  unitPrice: list[index]["price_of_indiviual"][i],
                                                  quantity: list[index]["quantity"][i],
                                                  productName: v
                                              );
                                            }
                                            shared.setString("products", json.encode(list_of_products));
                                            print("LIST OF PRODUCTS");
                                            print(list_of_products);
                                            shared.setStringList("variation",list[index]["vid"]);
                                            shared.setString("total", cart.getCartItemCount().toString());
                                            shared.setString("customer_name",list[index]["cus_name"]);
                                            print(shared.getString("customer_name"));
                                            Fluttertoast.showToast(
                                                msg: "Order is moved to cart",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                textColor: Colors.green,
                                                timeInSecForIosWeb: 4);
                                            if( MediaQuery.of(context).size.width < 1100 &&
                                                MediaQuery.of(context).size.width >= 650){
                                              shared.setInt("index", 1);
                                            }
                                            else{
                                              shared.setInt("index", 2);
                                            }


                                            Navigator.pop(context);
                                          },
                                        ),
                                        Container(
                                          color: Color(0xfffd6360),
                                          child: GestureDetector(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                                Icon(Icons.delete,
                                                  color: Colors.white,),
                                              ],
                                            ),
                                            onTap: () async {
                                              print("ON TAP");
                                              BlurryDialog  alert = BlurryDialog();
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: new Text("Are you sure you want to delete the order?"),
                                                    // content: new Text("Are you sure you want to delete the order?",),
                                                    actions: <Widget>[
                                                      new FlatButton(
                                                        child: new Text("Continue"),
                                                        onPressed: () async {
                                                          print("Continue");

                                                          Map<String,dynamic> api={
                                                            "sell":list[index]["order_id"]
                                                          };
                                                          var dio=Dio();
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
                                                          dio.options.headers["Authorization"]=shared.getString("Authorization");
                                                          var r=await dio.delete("https://seropos.app/connector/api/sell/${list[index]["order_id"]}",data: json.encode(api));
                                                          print(r);
                                                          print(list[index]["order_id"]);
                                                          // http.Response response = await http.delete(
                                                          //     Uri.parse(
                                                          //         "https://seropos.app/connector/api/sell/quis")
                                                          //     ,  headers: {
                                                          //   'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjMwYjE2MGVhNGUzMzA4ZTNiMjhhZGNlYWEwNjllZTA2NjI5Y2M4ZjMxMWFjZjUwMDFjZmZkMTE1ZDZlNTliZGI5NmJlZmQ3ZGYzYjRhNWNhIn0.eyJhdWQiOiIzIiwianRpIjoiMzBiMTYwZWE0ZTMzMDhlM2IyOGFkY2VhYTA2OWVlMDY2MjljYzhmMzExYWNmNTAwMWNmZmQxMTVkNmU1OWJkYjk2YmVmZDdkZjNiNGE1Y2EiLCJpYXQiOjE2MjU4OTY4MDcsIm5iZiI6MTYyNTg5NjgwNywiZXhwIjoxNjU3NDMyODA3LCJzdWIiOiI4Iiwic2NvcGVzIjpbXX0.OJ9XTCy8i5-f17ZPWNpqdT6QMsDgSZUsSY9KFEb-2O6HehbHt1lteJGlLfxJ2IkXF7e9ZZmydHzb587kqhBc_GP4hxj6PdVpoX_GE05H0MGOUHfH59YgSIQaU1cGORBIK2B4Y1j4wyAmo0O1i5WAMQndkKxA03UFGdipiobet64hAvCIEu5CipJM7XPWogo2gLUoWob9STnwYQuOgeTLKfMsMG4bOeaoVISy3ypALDJxZHi85Q9DZgO_zbBp9MMOvhYm9S1vPzoKCaGSx2zNtmOtCmHtUAxCZbu0TR2VDN7RpLdMKgPF8eLJglUhCur3BQnXZfYWlVWdG-T3PCKMvJvoE6rZcVXy2mVJUk3fWgldcOAhPRmQtUS563BR0hWQDJOL3RsRAjeesMhRouCtfmQBcW83bRindIiykYV1HrjdJBQNb3yuFFJqs9u7kgVFgZmwzsbd512t9Vfe1Cq_DhXbJM2GhIoFg72fKbGImu7UnYONUGB3taMmQn4qCXoMFnDl7glDLU9ib5pbd0matbhgkydHqThk5RZOPWje9W93j9RvwqwYL1OkcV9VXWcxYk0wwKRMqNtx74GLOUtIh8XJDK3LtDpRwLKer4dDPxcQHNgwkEH7iJt40bd9j27Mcyech-BZDCZHRSZbwhT7GnNeu2IluqVq3V0hCW3VsB8"
                                                          // },
                                                          // body:json.encode(<String,int>{
                                                          //   "sell":list[index]["order_id"]
                                                          // }));
                                                          var v = r.toString();
                                                          print(v);
                                                          shared.setStringList("variation", []);
                                                          var cart = FlutterCart();
                                                          cart.deleteAllCart();
                                                          Fluttertoast.showToast(
                                                              msg: "Order is deleted",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.BOTTOM,
                                                              textColor: Colors.green,
                                                              timeInSecForIosWeb: 4);
                                                          setState(() {
                                                            list.removeAt(index);
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    color: Color(0xFFFFD45F),
                                  ),
                                ],
                              )

                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
// class product{
//   int order_id;
//   List<int> pid;
//   List<int> price_of_indivual;
//   double total_price;
//   String name;
//   product.fromJson(Map<String,dynamic> json):
//         this.name=json["name"],
//         this.order_id=json["id"],
//         this.pid=json[]
// }

class BlurryDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          title: new Text("Are you sure you want to delete the order?"),
          // content: new Text("Are you sure you want to delete the order?",),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                print("Continue");

              },
            ),
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
    //     BlurryDialog  alert = BlurryDialog();
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
}


