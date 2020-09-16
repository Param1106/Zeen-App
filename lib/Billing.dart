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

  void addToBill(Vegetable vegetable) async {
    setState(() {
      selectedItems.add(vegetable);
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
          Text('Choose a vegetable'),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: Scaffold.of(context).context,
                  builder: (context) {
                    return AlertDialog(content: CustomDropDown(onTap: addToBill,),);
                  });
            },
            child: Row(
              children: [
                Text('Select a vegetable'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          )
        ],
      ),
        SizedBox(
          height: 15.0,
        ),
        ListView.builder(
            // this generates widgets dynamically
            shrinkWrap: true,
            itemCount: selectedItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('${selectedItems[index].name} #$index');
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
