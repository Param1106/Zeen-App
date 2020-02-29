import 'package:flutter/material.dart';

class Rates extends StatefulWidget {
  @override
  _RatesState createState() => _RatesState();
}

class _RatesState extends State<Rates> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Rates'),
      ),
      body: new _MyList(),
    );
  }
}

class _MyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      RaisedButton(onPressed: () {}, child: Text('Submit')),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
      Text('Enter Rate 1:'),
      TextField(),
    ]);
  }
}
