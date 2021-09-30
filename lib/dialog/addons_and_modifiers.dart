import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/screens/cart_screen.dart';
import 'package:flutter_nav_bar/screens/productdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class add extends StatefulWidget {
  add({required this.product,});

  String product;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<add> {
  List<dynamic> _cast =[];
  bool _isloading =false;
  List<Modifiers> _modifiers=[];
  var name='';
  final List<String> _selectedModifiers = <String>[];
  final List<String> _selectedModifiersprice = <String>[];
  Iterable<Widget> get actorWidgets sync* {
    for (int actor=0;actor<_modifiers.length;actor++/*final Modifiers actor in _cast*/) {
      yield Padding(
          padding: const EdgeInsets.all(4.0),
          child: FilterChip(
            backgroundColor: Color(0xFFFFD45F),
            //avatar: CircleAvatar(child: Text(actor.initials)),
            label: Text(_modifiers[actor].name),
            checkmarkColor: Colors.blue,
            selectedColor: Colors.yellow,
            selected: _selectedModifiers.contains(_modifiers[actor].name),
            showCheckmark: true,
            onSelected: (bool value) {
              setState(() {
                if (value) {
                  _selectedModifiers.add(_modifiers[actor].name);
                  _selectedModifiersprice.add(_modifiers[actor].sell_price.toString());
                  print(_modifiers[actor].name);
                } else {
                  _selectedModifiers.removeWhere((String name) {
                    return name == _modifiers[actor].name;
                  });
                }
              });
            },
          ));
    }}

  void fetch() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      _isloading=true;
    });
    http.Response response = await http.get(
        Uri.parse(
            "https://seropos.app/connector/api/product?name=$name")
        ,  headers: {
      'Authorization': sharedPreferences.getString("Authorization")??""
    });
    var v = (json.decode(response.body));
    print(v);
    List<dynamic> check = v["data"][0]["modifiers"];
    for(var i in v["data"][0]["modifiers"][0] ){
      _modifiers.add(Modifiers.fromJson(i));
    }
    print(_modifiers[0].name);
    setState(() {
      _isloading=false;
    });
  }
  List<Map<String,dynamic>> list_of_m=[];
  @override
  void initState() {
    // TODO: implement initState

    name = widget.product;
    fetch();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _isloading?Center(child:CircularProgressIndicator(color: Color(0xff000066),))
        : Container(
      //elevation: 16,
        color: Colors.transparent,
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                insetPadding: EdgeInsets.all(20),
                child:Column(
                    children:[
                      Container(margin:EdgeInsets.all(15),child:Center(child: Text("Modifiers",style: TextStyle(fontSize: 20),),),),
                      Wrap(direction: Axis.horizontal,
                          children: actorWidgets.toList()),

                    ])
            ),
              Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  insetPadding: EdgeInsets.all(20),
                  child:Column(
                      children:[
                        Container(margin:EdgeInsets.all(15),child:Center(child: Text("AddOns",style: TextStyle(fontSize: 20),),),),
                        Wrap(direction: Axis.horizontal,
                            children: actorWidgets.toList()),

                      ])
              ),
              FlatButton(onPressed: ()async {
                for(int i=0;i<_selectedModifiers.length;i++){
                  for(int j=0;j<_modifiers.length;j++) {
                    if (_modifiers[j].name == _selectedModifiers[i]) {
                      Map<String,dynamic> product={
                        "product_id":_modifiers[j].pid,
                        "variation_id":_modifiers[j].variation_id,
                        "quantity": 1,
                        "unit_price": _modifiers[j].sell_price,
                        "children_type":"modifier"
                      };
                      list_of_m.add(product);

                    }

                  }

                }
                SharedPreferences prefs =  await SharedPreferences.getInstance();
                prefs.setStringList(widget.product,_selectedModifiers);
                prefs.setStringList(widget.product+"price",_selectedModifiersprice);
                prefs.setString("modifiers",json.encode(list_of_m));
                var mod =json.decode(prefs.getString("modifiers")?? "");
                // list_of_m.addAll(mod);
                print(mod);
                print("BLAHHHHHHHHHHHHHHHHHHHHHHHH");
                print(_selectedModifiers);
                print(widget.product);
                Navigator.pop(context);
              },
                  color: Color(0xFFFFD45F),
                  child: Icon(Icons.arrow_forward))
            ]));
  }
}




class Modifiers {
  final String name;
  final double sell_price;
  final int variation_id;
  final  int pid;
  Modifiers.fromJson(Map<String,dynamic> json):
        this.name=json["name"],
        this.sell_price=double.parse(json["sell_price_inc_tax"]),
        this.pid=json["product_id"],
        this.variation_id=json["product_variation_id"];
}


