import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Billing'),
      ),
      body: new _MyList2(),
    );
  }
}

class _MyList2 extends StatefulWidget {
  @override
  __MyList2State createState() => __MyList2State();
}

class __MyList2State extends State<_MyList2> {
  String newVal;
  var selectedCurrency;
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        Text('Customer Name:'),
        TextField(decoration: new InputDecoration(hintText: "input here")),
        Text('Customer Phone Number :'),
        TextField(
          decoration: new InputDecoration(hintText: "input here"),
        ),
        Text('Customer Tower :'),
        TextField(
          decoration: new InputDecoration(hintText: "input here"),
        ),
        Text("Customer Flat :"),
        TextField(
          decoration: new InputDecoration(hintText: "input Here"),
        ),
        Text("Enter Stuff"),
        TextField(
          decoration: new InputDecoration(hintText: "input Here"),
        ),
        Text('Choose Vegetables :'),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("v_challengers").snapshots(),
           builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> currencyItems = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        DocumentSnapshot snap = snapshot.data.documents[i];
                        currencyItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.documentID,
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                            value: "${snap.documentID}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: currencyItems,
                            onChanged: (currencyValue) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected Currency value is $currencyValue',
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                              setState(() {
                                selectedCurrency = currencyValue;
                              });
                            },
                            value: selectedCurrency,
                            isExpanded: false,
                            hint: new Text(
                              "Choose Vegetable Type",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
              SizedBox(
                height: 150.0,
              ),
        ),

       
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Name', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Rate', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Quantity', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Price', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Extra', textAlign: TextAlign.center),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Potato', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('30', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('2', textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('60', textAlign: TextAlign.center),
            ),
            Expanded(
              child:
                  Text('200 change to be given', textAlign: TextAlign.center),
            ),
          ],
        ),
        RaisedButton(
          onPressed: () {
            print('Submit clicked! Dropdown value: $newVal');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
