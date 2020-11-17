import 'package:enactusdraft2/login_page.dart';
import 'package:flutter/material.dart';

//pages
import './Rates.dart';
import './Billing.dart';
import './enactus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),   //MyHomePage(),
    );
  }
}
