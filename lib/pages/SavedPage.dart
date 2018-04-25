import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unne_app/config/Strings.dart';

class SavedPage extends StatelessWidget {
  SavedPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.projectTitle),
        elevation:
        Theme
            .of(context)
            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new Text("Guardados")
          )
      ),
    );
  }
}
