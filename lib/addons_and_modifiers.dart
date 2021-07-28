import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/productdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';


class add extends StatefulWidget {
  add({required this.modifiers,required this.product,required this.price});
  List<dynamic> modifiers;
  List<dynamic> price;
  String product;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<add> {
   List<dynamic> _cast =[];
  final List<String> _selectedModifiers = <String>[];
   final List<String> _selectedModifiersprice = <String>[];
  Iterable<Widget> get actorWidgets sync* {
    for (int actor=0;actor<_cast.length;actor++/*final Modifiers actor in _cast*/) {
      yield Padding(
          padding: const EdgeInsets.all(4.0),
          child: FilterChip(
            backgroundColor: Color(0xFFFFD45F),
            //avatar: CircleAvatar(child: Text(actor.initials)),
            label: Text(_cast[actor]),
            checkmarkColor: Colors.blue,
            selectedColor: Colors.yellow,
            selected: _selectedModifiers.contains(_cast[actor]),
            showCheckmark: true,
            onSelected: (bool value) {
              setState(() {
                if (value) {
                  _selectedModifiers.add(_cast[actor]);
                  _selectedModifiersprice.add(widget.price[actor]);
                  print(_cast[actor]);
                } else {
                  _selectedModifiers.removeWhere((String name) {
                    return name == _cast[actor];
                  });
                }
              });
            },
          ));
    }}
  @override
  Widget build(BuildContext context) {
    _cast=widget.modifiers;
     return Container(
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
                 SharedPreferences prefs =  await SharedPreferences.getInstance();
                 prefs.setStringList(widget.product,_selectedModifiers);
                 prefs.setStringList(widget.product+"price",_selectedModifiersprice);
                 print("BLAHHHHHHHHHHHHHHHHHHHHHHHH");
                 print(_selectedModifiersprice);
                 print(widget.product);
                 Navigator.pop(context);
                 },
                   color: Color(0xFFFFD45F),
                   child: Icon(Icons.arrow_forward))
      ]));
  }
  }


class Modifiers {
  const Modifiers(this.name);
  final String name;
}