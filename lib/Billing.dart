import 'package:flutter/material.dart';
import 'user_model.dart';

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

class _MyList2 extends StatelessWidget {
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
        new DropdownButton<String>(
          items: <String>['Potato', 'Fruits', 'C', 'D', 'E', 'F']
              .map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (_) {},
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
          onPressed: () {},
          child: Text('Submit'),
        ),
      ],
    );
  }
}
