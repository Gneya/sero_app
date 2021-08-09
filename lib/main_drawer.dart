

import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  // final String image;
  // final String name;
  // final String email;
  // MainDrawer({this.image,this.name,this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Container(
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
                      leading: Icon(Icons.home,color:Colors.amber,),
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
                      leading: Icon(Icons.local_fire_department_sharp,color:Colors.amber,),
                      title: Text('Flames',
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
                      leading: Icon(Icons.fire_extinguisher,color:Colors.amber,),
                      title: Text('Gas',
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
                      leading: Icon(Icons.smoke_free,color:Colors.amber,),
                      title: Text('Smoke',
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
                      leading: Icon(Icons.surround_sound_outlined,color:Colors.amber,),
                      title: Text('Sound',
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
                      leading: Icon(Icons.thermostat_outlined,color:Colors.amber,),
                      title: Text('Temperature',
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
                      leading: Icon(Icons.multiple_stop,color:Colors.amber,),
                      title: Text('Distance',
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
                        //       return WarningPage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.warning,color:Colors.amber,),
                      title: Text('Warning',
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
                        //       return EditProfilePage();
                        //     },
                        //   ),
                        // );
                      },
                      leading: Icon(Icons.person,color:Colors.amber,),
                      title: Text('Edit Profile',
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