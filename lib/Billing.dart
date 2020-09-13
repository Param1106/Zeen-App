import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  List items = []; // add stuff to this list to display dynamically
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
                return Text("Loading.....");
              else {
                List<DropdownMenuItem> currencyItems = [];
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  DocumentSnapshot snap = snapshot.data.documents[i];
                  currencyItems.add(
                    DropdownMenuItem(
                      child: Text(
                        snap.data["v_name"],
                        style: TextStyle(color: Color(0xff11b719)),
                      ),
                      value:
                          "${snap.data["v_name"]}", //change the v_name to v_price after m0dification in firebase
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
          height: 15.0,
        ),
        ListView.builder(
            // this generates widgets dynamically
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('${items[index]} #$index');
            }),
        RaisedButton(
          onPressed: () {
            _showAddTaskDialog();
          },
        ),
      ],
    );
  }

  void _showAddTaskDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Input Quantity"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your task here",
                      labelText: "Task Name"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      child: Text("Add"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }
}
