import 'package:flutter/widgets.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Text("Cuenta personal");
  }
}
