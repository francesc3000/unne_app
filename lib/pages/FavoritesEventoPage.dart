import 'package:flutter/widgets.dart';

class FavoritesEventoPage extends StatelessWidget {
  FavoritesEventoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Text("Favoritos");
  }
}