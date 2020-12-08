import 'package:cloud_firestore/cloud_firestore.dart';
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
  var r = Auth();

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Welcome to ${r.currentUser.market} market',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
          ),
        ],
      )
    );
  }

///  Function to duplicate a collection of vegetables
//  void temp() async {
//    QuerySnapshot q = await Firestore.instance.collection('markets')
//        .document(r.currentUser.market).collection('vegetables').getDocuments();
//    Future.forEach(q.documents, (DocumentSnapshot element) {
//      String name = element.data['v_name'];
//      if(element.data['v_name'].toString().contains("/")) {
//        name = name.substring(0, name.indexOf("/"));
//        print(name);
//      }
//      Firestore.instance.collection('markets').document('v_golden_rays')
//          .collection('vegetables').document(name)
//          .setData({'v_name': element.data['v_name'], 'v_price': element.data['v_price'], 'stock': element.data['stock']});
//    });
//  }
}
