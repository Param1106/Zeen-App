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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
