import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_bar/HomeScreen.dart';
import 'package:flutter_nav_bar/Category.dart';
import 'package:flutter_nav_bar/delay.dart';
import 'package:flutter_nav_bar/utsav/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _tabNavigator = GlobalKey<TabNavigatorState>();
  final _tab1 = GlobalKey<NavigatorState>();
  final _tab2 = GlobalKey<NavigatorState>();
  final _tab3 = GlobalKey<NavigatorState>();
  final _tab4 = GlobalKey<NavigatorState>();
  var _tabSelectedIndex = 0;
  var _tabPopStack = false;
    String total="0";
  void _setIndex(index) {
      setState(() {
        _tabPopStack = _tabSelectedIndex == index;
        _tabSelectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
      fetchtotal();
    return WillPopScope(
      onWillPop: () async => !await _tabNavigator.currentState!.maybePop(),
      child: Scaffold(
        body: TabNavigator(
          key: _tabNavigator,
          tabs: <TabItem>[
            TabItem(_tab1, HomeScreen(title: '')),
            TabItem(_tab2, CategoryScreen(title: '')),
            TabItem(_tab3, Delay()),
            TabItem(_tab4, PageWithButton(title: '')),
          ],
          selectedIndex: _tabSelectedIndex,
          popStack: _tabPopStack,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabSelectedIndex,
          onTap: _setIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,color: Colors.amber,),
              title: Text('title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined,color: Colors.amber,),
              title: Text('title'),
            ),
            BottomNavigationBarItem(
              icon: Badge(
              badgeColor: Colors.red,
                position: BadgePosition.topEnd(top: -20, end: -10),
                // badgeContent: FutureBuilder(
                //   future: fetchtotal(),
                // builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                   badgeContent:Text(total,style: TextStyle(color: Colors.white)),
              //}),
                child:Icon(Icons.shopping_cart,color: Colors.amber,),),
              title: Text('title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.open_in_browser_outlined,color: Colors.amber,),
              title: Text('title'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchtotal() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var list=sharedPreferences.getStringList("selected");
    setState(() {
      total=list!.length.toString();
    });
    return sharedPreferences.getStringList("selected")!.length.toString();
  }

}

class PageWithButton extends StatelessWidget {
  final String title;
  final int count;

  const PageWithButton({
    Key ?key,
    required this.title,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text("$title $count"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PageWithButton(title: title, count: count + 1),
            ));
          },
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