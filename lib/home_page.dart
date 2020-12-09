import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/auth.dart';
import 'package:enactusdraft2/view_bill.dart';
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
  String market;

  String marketName(String str) {
    int i = 2;
    int j = 0;
    String name = "";
    String temp;
    while(i < str.length) {
      j = str.indexOf("_", i);
      if(j == -1) {
        j = str.length;
        temp = str.substring(i, j);
        name += temp[0].toUpperCase() + temp.substring(1);
      }
      else {
        temp = str.substring(i, j);
        name += temp[0].toUpperCase() + temp.substring(1) + " ";
      }
      i = j+1;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    market = marketName(r.currentUser.market);
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
            new ListTile(
              title: new Text('View Bill'),
              leading: const Icon(Icons.style),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ViewBill()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30.0,
            child: Text('Welcome to $market market',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26.0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Billing()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2 - 20.0,
                    height: MediaQuery.of(context).size.width/2 - 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 95.0, color: Colors.green,),
                        Text('Make Orders', style: TextStyle(fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBill()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/2 - 20.0,
                    height: MediaQuery.of(context).size.width/2 - 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.style, size: 95.0, color: Colors.green,),
                        Text('Billing Information', style: TextStyle(fontWeight: FontWeight.w600),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
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
//      }
//      Firestore.instance.collection('markets').document('v_golden_rays')
//          .collection('vegetables').document(name)
//          .setData({'v_name': element.data['v_name'], 'v_price': element.data['v_price'], 'stock': element.data['stock']});
//    });
//  }
}
