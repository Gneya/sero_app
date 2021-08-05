import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
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
  var cart=FlutterCart();
   ValueNotifier<int> _counter = ValueNotifier<int>(0);
  int _tabSelectedIndex = 0;
  var _tabPopStack = false;
  String? total="0";
  // late TabController _tabController;
  // @override
  // void initState() {
  //   super.initState();
  // }

   _setIndex(index) {
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
        print(_tabSelectedIndex);
      });}
  }
  fetch(int index) async {
    SharedPreferences shared=await SharedPreferences.getInstance();
    setState(() {
      total = cart.getCartItemCount().toString();
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
            TabItem(_tab4, MoreOptions())
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
                 //future: fetch(),
                 builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                   return Text(cart.getCartItemCount().toString()??"",style: TextStyle(color: Colors.white));
              }),
                // ValueListenableBuilder<int>(
                //   valueListenable: _counter,
                //   builder: (BuildContext context, value, Widget? child) {
                //     return Text(value.toString());
                //   },
                // ),
                child:Icon(Icons.shopping_cart),),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.open_in_browser_outlined,),
              title: Text(''),
            ),
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
    this.popStack=false,
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
    print('selectedIndex=${widget.selectedIndex}, popStack=${widget.popStack}');

    _popStackIfRequired(context);

    return Stack(
      children: List.generate(widget.tabs.length, _buildTab),
    );
  }

  Widget _buildTab(int index) {
    return Offstage(
      offstage: widget.selectedIndex != index,
      child: Opacity(
        opacity: widget.selectedIndex == index ? 1.0 : 0.0,
        child: Navigator(
          key: widget.tabs[index].key,
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => widget.tabs[index].tab,
          ),
        ),
      ),
    );
  }
}