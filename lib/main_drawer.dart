import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(

                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Color(0xffffd45f),
                margin: EdgeInsets.only(top: 25,bottom: 10),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 50,bottom: 20,top: 20),
                        // width: 80,
                        // height: 80,
                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            // color:Colors.white,
                            // image: DecorationImage(
                            //     image: AssetImage("images/logo.png"),
                            //     fit: BoxFit.fill
                            ),
                        child:Center(
                          child:Image.asset("images/logo.png",height: MediaQuery.of(context).size.height/15,)
                        ),
                      ),
                      SizedBox(width: 10,),
                      //  Text("Online Beej",style: TextStyle(fontSize: 22,color: Colors.white),),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: (){
                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        //     bu ilder: (BuildContext context) => HomePage()), (
                        //     Route<dynamic> route) => false);
                      },
                      leading: Icon(Icons.summarize_outlined,color:Colors.amber,),
                      title: Text('DSR(Daily Sale Report)',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                      selectedTileColor: Colors.blue,
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (BuildContext context){
                      //         return FlamesListPage();
                      //       },
                      //     ),
                      //   );
                      },
                      leading: Icon(Icons.add_box_outlined,color:Colors.amber,),
                      title: Text("Add/Edit Printer",
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context){
                        //       return GasListPage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.app_registration_outlined,color:Colors.amber,),
                      title: Text('Open/Close Register',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                        //Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context){
                        //       return SmokeListPage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.edit_outlined,color:Colors.amber,),
                      title: Text('Add/Edit Product',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context){
                        //       return SoundListPage();
                        //     },
                        //   ),
                        //);
                      },
                      leading: Icon(Icons.local_printshop_outlined,color:Colors.amber,),
                      title: Text('Reprint Bill',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context){
                        //       return TemperatureListPage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.view_list_outlined,color:Colors.amber,),
                      title: Text('View Bookings',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      onTap: (){
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context){
                        //       return DistanceListPage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.kitchen,color:Colors.amber,),
                      title: Text('KDS Screen (Kitchen Display Screen)',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                    ListTile(
                      // onTap: (){
                      //   showDialog(context: context, builder: (context) => ExitConfirmationDialog());
                      // },
                      leading: Icon(Icons.exit_to_app,color:Colors.amber,),
                      title: Text('Logout',
                        style: TextStyle(
                            fontSize: 16,color: Colors.black54),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Divider(thickness: 1,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}