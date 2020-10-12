import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/cutom_dropdown.dart';
import 'package:enactusdraft2/success_page.dart';
import 'package:enactusdraft2/total_bottom_bar.dart';
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
  double total;
  Vegetable selected;
  List<Vegetable> selectedItems  = [];
  Future<List<DropdownMenuItem<Vegetable>>> items;

  @override
  void initState() {
    super.initState();
  }

  void addToBill() async {
    Vegetable v = await showDialog(
      barrierDismissible: false,
        context: Scaffold.of(context).context,
        builder: (context) {
          return AlertDialog(content: CustomDropDown(),);
        });
    if( v != null) {
      var res = await _showAddTaskDialog(v.name);
      print(res != null);
      if (res != null) {
        v.qty = double.parse(res);
        v.total = v.qty* v.price;
        setState(() {
          selectedItems.add(v);
          double sum = 0.0;
          selectedItems.forEach((element) {
            sum += element.total;
          });
          total = sum;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Choose Vegetables :'),
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
          ],
        ),
          SizedBox(
            height: 5.0,
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Vegetable')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Edit')),
            ],
            rows: selectedItems.map(
                    (e) => DataRow(cells: [
                      DataCell(Text('${e.name}')),
                      DataCell(Text('${e.qty}')),
                      DataCell(Text('${e.total}')),
                      DataCell(Icon(Icons.edit, color: Colors.green,), onTap: () => editOrderItem(selectedItems.indexOf(e))),
                    ],)
            ).toList(),
          ),

        ],
      ),
      bottomNavigationBar: TotalBar(bill: total, onTap: placeOrder,),
    );
  }

  Future<String> _showAddTaskDialog(String title) async {
    TextEditingController _cont = TextEditingController();

    var res = await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("$title"),
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
    return res == null? null: res.toString();
  }

  void editOrderItem(int index) async {
    Vegetable v = await showDialog(
      barrierDismissible: false,
        context: Scaffold.of(context).context,
        builder: (context) {
          return AlertDialog(content: CustomDropDown(),);
        });
    var res = await _showAddTaskDialog(v.name);
    v.qty = double.parse(res);
    v.total = v.qty * v.price;
    setState(() {
      selectedItems[index] = v;
      double sum = 0.0;
      selectedItems.forEach((element) {
        sum += element.total;
      });
      total = sum;
    });
  }

  Future<bool> updateStock() async {
    bool success = true;
    Map<String, double> newQtys = {};
    await Future.forEach(selectedItems, (element) async {
      if(success) {
        DocumentSnapshot doc = await Firestore.instance.collection('markets').document('v_challengers').collection('vegetables').document(element.uid).get();
        double currQty = doc.data['stock'] == null ? 0.0 : doc.data['stock'].toDouble();
        if (currQty != 0.0) {
          double newQty = currQty - element.qty;
          if(newQty >= 0.0) {
            newQtys[element.uid] = newQty;
          }
          else {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('${element.name} Not enough Stock', style: TextStyle(fontSize: 20),), duration: Duration(seconds: 2),));
            success = false;
          }
        }
        else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('${element.name} Out of Stock', style: TextStyle(fontSize: 20),), duration: Duration(seconds: 2),));
          success = false;
        }
      }
    });
    if(success) {
      Future.forEach(newQtys.entries, (element) async {
        await Firestore.instance.collection('markets').document('v_challengers').collection('vegetables').document(element.key).updateData({'stock': element.value});
      });
    }
    return success;
  }

  void placeOrder() async {
    bool res = await updateStock();
    if(res){
      List<Map> order = selectedItems.map((e) => {'item': e.name, 'price': e.price, 'quantity': e.qty}).toList();
      QuerySnapshot docs = await Firestore.instance.collection('markets').document('v_challengers').collection('bills').getDocuments();
      String id = (docs.documents.length+1).toString();
      id = id.length < 6 ? '0'*(6-id.length)+id : id;
      await Firestore.instance.collection('markets').document('v_challengers').collection('bills').document(id).setData({'bill': order});
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage(billID: id,)));
      setState(() {
        selectedItems = [];
        total = 0.0;
      });
    }
    else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Order could not be placed', style: TextStyle(fontSize: 20),), duration: Duration(seconds: 2),));
    }
  }
}
