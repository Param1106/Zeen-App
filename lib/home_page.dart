import 'package:enactusdraft2/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Billing.dart';
import 'Rates.dart';
import 'enactus.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var r = Auth();
    print(r.currentUser.market);
    return Scaffold(
      appBar: AppBar(
        title: Text('ZEEN'),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text('ZEEN'),
              accountEmail: Text('ZEEN.com'),
              currentAccountPicture: new CircleAvatar(),
            ),
            new ListTile(
              title: new Text('Rates'),
              leading: const Icon(Icons.face),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Rates()));
              },
            ),
            new ListTile(
              title: new Text('Billing'),
              leading: const Icon(Icons.face),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Billing()));
              },
            ),
            new ListTile(
              title: new Text('Signup'),
              leading: const Icon(Icons.face),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new SignupPage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
