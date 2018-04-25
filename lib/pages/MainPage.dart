import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unne_app/config/Strings.dart';
import 'package:unne_app/pages/AccountPage.dart';
import 'package:unne_app/pages/EventoPage.dart';
import 'package:unne_app/pages/FavoritesEventoPage.dart';
import 'package:unne_app/pages/HomePage.dart';
import 'package:unne_app/pages/SavedPage.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.green,
  accentColor: Colors.orangeAccent[400],
);

class MainPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.projectTitle,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: PageView(
        children: <Widget>[
          new HomePage(title: Strings.projectTitle),
          new SavedPage(title: Strings.savedTitle),
          //new FavoritesEventoPage(title: Strings.favoritesTitle),
          //new AccountPage(title: Strings.accountTitle),
        ],
      ),
      routes: <String, WidgetBuilder>{
        '/createEvento': (BuildContext context) => new EventoPage(),
        //'/favoritesEvento' : (BuildContext context) => new FavoritesEventoPage(),
      },
    );
  }
}