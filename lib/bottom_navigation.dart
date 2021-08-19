import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_nav_bar/HomeScreen.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:flutter_nav_bar/utsav/more_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin{
  final _tabNavigator = GlobalKey<TabNavigatorState>();
  final _tab1 = GlobalKey<NavigatorState>();
  final _tab2 = GlobalKey<NavigatorState>();
  final _tab3 = GlobalKey<NavigatorState>();
  final _tab4 = GlobalKey<NavigatorState>();
  var _tabSelectedIndex = 0;
  var _tabPopStack = false;
  String? total="0";

  Future<void> _setIndex(index) async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setInt("index", index);
    if(index== 0){
      sharedPreferences.setString( "screen", "Home");
    }
    else if(index ==1){
      sharedPreferences.setString("screen", "Category");

    }
    else if(index ==2){
      sharedPreferences.setString("screen", "Cart");

    }
    else{

    }
    if(mounted){
      setState(() {
        _tabPopStack = _tabSelectedIndex == index;
        _tabSelectedIndex = index;
      });}
  }
  var cart=FlutterCart();

  fetch() async {
    _tabPopStack=false;
    SharedPreferences shared=await SharedPreferences.getInstance();
    var i=shared.getInt("index");
    if(i==0)
    {
      setState(() {
        _tabSelectedIndex=0;
        if(shared.getInt("PAY_HOLD")==1)
          {
            _tabPopStack=true;
            shared.setInt("PAY_HOLD", 0);
          }
      });

    }
    else if(i==1){
      setState(() {
        _tabSelectedIndex=1;
      });
    }
    else if(i==2){
      setState(() {
        _tabSelectedIndex=2;
      });
    }
    setState(()  {
      total=shared.getString("total");
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _tabNavigator.currentState!.maybePop(),
      child: Scaffold(
        body: TabNavigator (
          key: _tabNavigator,
          tabs: <TabItem>[
            TabItem(_tab1, HomeScreen(title: '')),
            TabItem(_tab2, CategoryScreen(title: '')),
            TabItem(_tab3, CartScreen()),
            // TabItem(_tab4,MoreOptions())
          ],
          selectedIndex: _tabSelectedIndex,
          popStack: _tabPopStack,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey.shade700,
          currentIndex: _tabSelectedIndex,
          onTap: _setIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined,),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                badgeColor: Colors.red,
                position: BadgePosition.topEnd(top: -20, end: -10),
                badgeContent: FutureBuilder(
                    future: fetch(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return Text(total.toString()??"",style: TextStyle(color: Colors.white));
                    }),
                child:Icon(Icons.shopping_cart),),
              title: Text(''),

            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.open_in_browser_outlined,),
            //   title: Text(''),
            // ),
          ],
        ),
      ),
    );
  }


}

class TabItem {
  final GlobalKey<NavigatorState> key;
  final Widget tab;
  const TabItem(this.key, this.tab);
}

class TabNavigator extends StatefulWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final bool popStack;

  TabNavigator({
    Key ?key,
    required this.tabs,
    required this.selectedIndex,
    this.popStack = false,
  }) : super(key: key);

  @override
  TabNavigatorState createState() => TabNavigatorState();
}

class TabNavigatorState extends State<TabNavigator> {
  ///
  /// Try to pop widget, return true if popped
  ///
  Future<bool> maybePop() {
    return widget.tabs[widget.selectedIndex].key.currentState!.maybePop();
  }

  _popStackIfRequired(BuildContext context) async {
    if (widget.popStack) {
      widget.tabs[widget.selectedIndex].key.currentState!
          .popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('selectedIndex=${widget.selectedIndex}, popStack=${widget.popStack}');

    _popStackIfRequired(context);

    return Stack(
      children: List.generate(widget.tabs.length, _buildTab),
    );
  }

  Widget _buildTab(int index) { {
      return Offstage(
        offstage: widget.selectedIndex != index,
        child: Opacity(
          opacity: widget.selectedIndex == index ? 1.0 : 0.0,
          child: Navigator(
            key: widget.tabs[index].key,
            onGenerateRoute: (settings) =>
                MaterialPageRoute(
                  settings: settings,
                  builder: (_) => widget.tabs[index].tab,
                ),
          ),
        ),
      );
    }
  }
}