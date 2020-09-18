import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/cutom_dropdown.dart';
import 'package:enactusdraft2/vegetable_model.dart';
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
  Vegetable selected;
  List<Vegetable> selectedItems  = [];
  Future<List<DropdownMenuItem<Vegetable>>> items;
//  List items = []; // add stuff to this list to display dynamically

  @override
  void initState() {
    items = getItems();
    super.initState();
  }

  void addToBill() async {
    Vegetable v = await showDialog(
        context: Scaffold.of(context).context,
        builder: (context) {
          return AlertDialog(content: CustomDropDown(),);
        });
    var res = await _showAddTaskDialog();
    v.qty = int.parse(res);
    setState(() {
      selectedItems.add(v);
    });
  }

  Future<List<DropdownMenuItem<Vegetable>>> getItems() async {
    QuerySnapshot docs = await Firestore.instance.collection('v_challengers').getDocuments();
    List<Vegetable> vegetables = [];
    docs.documents.forEach((element) {
      vegetables.add(Vegetable(uid: element.documentID, name: element.data['v_name'], price: element.data['v_price']));
    });
    return vegetables.map((e) => DropdownMenuItem<Vegetable>(child: Text('${e.name}'), value: e,)).toList();
  }

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
      Row(
        children: [
          FlatButton(
            onPressed: () {
              addToBill();
            },
            child: Row(
              children: [
                Text('Select a vegetable'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
//          RaisedButton(
//            child: Text('Choose Qty'),
//            onPressed: () {
//              _showAddTaskDialog();
//            },
//          ),
        ],
      ),
        SizedBox(
          height: 15.0,
        ),
        DataTable(
          columns: [
            DataColumn(label: Text('Vegetable')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Price')),
          ],
          rows: selectedItems.map((e) => DataRow(cells: [DataCell(Text('${e.name}')), DataCell(Text('${e.qty}')), DataCell(Text('${e.price*e.qty}'))])).toList() ,
        ),
      ],
    );
  }

  Future<String> _showAddTaskDialog() async {
    TextEditingController _cont = TextEditingController();

    var res = await showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Input Quantity"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _cont,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Quantity",
                      labelText: "Quantity"),
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
                      onPressed: () {
                        Navigator.of(context).pop(_cont.text);
                      },
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
    return res.toString();
  }
}
