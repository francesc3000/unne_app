
import 'package:unne_app/pages/MainPage.dart';
import 'package:unne_app/pages/PagesViews.dart';
import 'package:unne_app/pages/EventoPage.dart';
import 'package:unne_app/pages/LogInFacebookPage.dart';
import 'package:unne_app/config/Strings.dart';
import 'package:unne_app/presenter/Presenters.dart';
import 'package:unne_app/presenter/PresentersImpl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

DashboardPresenter _dashboardPresenter;

class DashBoardPage extends StatefulWidget{
  DashBoardPage({Key key, this.drawerList}) : super(key: key);

  final Widget drawerList;

  @override
  _DashBoardPage createState() => new _DashBoardPage(drawerList);

}

class _DashBoardPage extends State<DashBoardPage>
    with SingleTickerProviderStateMixin
    implements DashboardView{

  _DashBoardPage(this.drawerList);

  final Widget drawerList;
  TabBarView tabBarView;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    _tabController.addListener(_handleTabSelection);
    _dashboardPresenter = new DashboardPresenterImpl(this);
  }

  void _handleTabSelection() {
    setState(() {
      //Hacemos aparecer el botón flotante
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabBarView = new TabBarView(
      controller: _tabController,
      children: choices.map((_Choice choice) {
        return new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new ChoiceCard(choice: choice, tabController: _tabController),
        );
      }).toList(),
    );
    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      routes: <String, WidgetBuilder>{
        //'/evento': (BuildContext context) => new EventoComponent(),
        '/login': (BuildContext context) => new LogInFacebookPage(),
      },
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.accountTitle),
            bottom: new TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: choices.map((_Choice choice) {
                return new Tab(
                  text: choice.title,
                  icon: new Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          drawer: drawerList,
          body: tabBarView,
          floatingActionButton: new FloatingButton(_tabController),
        ),
      ),
    );
  }

  @override
  addEvento2List(String eventoId, String name, String description, bool isFavorite) {
    this.tabBarView.children[_tabController.index];
  }

  @override
  removeEventoFromList(String eventoId) {
    // TODO: implement removeEventoFromList
  }

}

class FloatingButton extends StatelessWidget{
  FloatingButton(this.tabController);

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    if(tabController.index==0||tabController.index==2) {
      return new FloatingActionButton(
        tooltip: Strings.add, // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: () {
          switch(tabController.index){
            case 0:
              //Navigator.of(context).pushNamed('/evento');
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new EventoPage();
                  },
                  fullscreenDialog: true
              ));
              break;
            case 2:
              Navigator.of(context).pushNamed('/group');
              break;
          }
        },
      );
    }else
      return new Container();
  }
}

class _Choice {
  const _Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

List<_Choice> choices = <_Choice>[
  new _Choice(title: Strings.myEnrolls, icon: Icons.group_work),
  new _Choice(title: Strings.favoritesTitle, icon: Icons.favorite),
  new _Choice(title: Strings.myGroups, icon: Icons.group),
  new _Choice(title: Strings.friends, icon: Icons.contacts),
];

class ChoiceCard extends StatelessWidget {
  ChoiceCard({ Key key, this.choice, this.tabController }) : super(key: key);

  final _Choice choice;
  final TabController tabController;
  var _background;

  @override
  Widget build(BuildContext context) {
    _background = _determineBackground(context, tabController);
    return new Card(
      color: Colors.white,
      child: new Center(
        child: _background,
      ),
    );
  }

  Widget _determineBackground(BuildContext context, TabController tabController) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;

    switch(tabController.index) {
      /*
      case 2:
        return new Containter();//EventoAnimatedList(presenter: _dashboardPresenter);
        break;
*/
      default:
        return new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        );
    }
  }

}