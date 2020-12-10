import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/auth.dart';
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
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  double total;
  Vegetable selected;
  List<Vegetable> selectedItems  = [];
  Future<List<DropdownMenuItem<Vegetable>>> items;

  AuthItem currentUser = Auth().currentUser;
  String market;
  _MyList2 lst = _MyList2();
  
  @override
  void initState() {
    market = currentUser.market;
    super.initState();
  }

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


  void addToBill() async {
    Vegetable v = await showDialog(
        barrierDismissible: false,
        context: _key.currentContext,
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

    double cellWidth = (MediaQuery.of(context).size.width/2) - 8.0;

    return Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text(marketName(market)+" Market"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            lst,
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
              showBottomBorder: true,
              columnSpacing: 0.0,
              horizontalMargin: 8.0,
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green),
              columns: [
                DataColumn(label: Container(width: cellWidth, child: Text('Vegetable'))),
                DataColumn(label: Container(width: cellWidth/3, child: Text('Qty'))),
                DataColumn(label: Container(width: cellWidth/3, child: Text('Price'))),
                DataColumn(label: Container(width: cellWidth/3, child: Text('Edit'))),
              ],
              rows: selectedItems.map(
                      (e) => DataRow(cells: [
                    DataCell(
                        Container(
                            width: cellWidth,
                            child: Text('${e.name}')
                        )
                    ),
                    DataCell(
                        Container(
                            width: cellWidth/3,
                            child: Text('${e.qty}')
                        )
                    ),
                    DataCell(
                        Container(
                            width: cellWidth/3,
                            child: Text('${e.total}')
                        )
                    ),
                    DataCell(
                        Container(
                            width: cellWidth/3,
                            child: Icon(Icons.edit, color: Colors.green,)
                        ),
                        onTap: () => editOrderItem(selectedItems.indexOf(e))
                    ),
                  ],)
              ).toList(),
            ),
          ],
        ),
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
        context: _key.currentContext,
        builder: (context) {
          return AlertDialog(content: CustomDropDown(),);
        });
    if (v != null) {
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
  }

  Future<bool> updateStock() async {
    bool success = true;
    Map<String, double> newQtys = {};
    await Future.forEach(selectedItems, (element) async {
      if(success) {
        print(market);
        DocumentSnapshot doc = await Firestore.instance.collection('markets').document(market).collection('vegetables').document(element.uid).get();
        print(element.uid);
        double currQty = doc.data['stock'] == null ? 0.0 : doc.data['stock'].toDouble();
        if (currQty != 0.0) {
          double newQty = currQty - element.qty;
          if(newQty >= 0.0) {
            newQtys[element.uid] = newQty;
          }
          else {
            _key.currentState.showSnackBar(
                SnackBar(content: Text('${element.name} Not enough Stock', style: TextStyle(fontSize: 16),), duration: Duration(seconds: 1),));
            success = false;
          }
        }
        else {
          _key.currentState.showSnackBar(SnackBar(content: Text('${element.name} Out of Stock', style: TextStyle(fontSize: 16),), duration: Duration(seconds: 1),));
          success = false;
        }
      }
    });
    if(success) {
      Future.forEach(newQtys.entries, (element) async {
        await Firestore.instance.collection('markets').document(market).collection('vegetables').document(element.key).updateData({'stock': element.value});
      });
    }
    return success;
  }

  List<Map> formatOrder(List<Vegetable> lst) {
    List<Map> res = [];
    lst.forEach((e) {
      if(e.qty != 0.0) {
        res.add({'item': e.name, 'price': e.price, 'quantity': e.qty});
      }
    });
    return res;
  }

  void placeOrder() async {
    Map result = lst.getData();
    bool res = await updateStock();
    if(res){
      List<Map> order = formatOrder(selectedItems);
      QuerySnapshot docs = await Firestore.instance.collection('markets').document(market).collection('bills').getDocuments();
      String id = (docs.documents.length+1).toString();
      id = id.length < 6 ? '0'*(6-id.length)+id : id;
      await Firestore.instance.collection('markets').document(market).collection('bills').document(id)
          .setData({'bill': order, 'total': total, 'name': result['name'], 'phno': result['phno'], 'flatno': result['flatno'], 'bld': result['bld']});
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage(billID: id,)));
      setState(() {
        selectedItems = [];
        total = 0.0;
      });
    }
    else {
      _key.currentState.showSnackBar(SnackBar(content: Text('Order could not be placed', style: TextStyle(fontSize: 20),), duration: Duration(seconds: 2),));
    }
  }
}

class _MyList2 extends StatefulWidget {

  TextEditingController _name = TextEditingController();
  TextEditingController _phno = TextEditingController();
  TextEditingController _flatno = TextEditingController();
  TextEditingController _bld = TextEditingController();

  Map<String, String> getData() {
    return {
      "name": _name.text,
      "phno": _phno.text,
      "flatno": _flatno.text,
      "bld": _bld.text,
    };
  }

  @override
  __MyList2State createState() => __MyList2State();
}

class __MyList2State extends State<_MyList2> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Customer Name:'),
        TextField(
          controller: widget._name,
          decoration: new InputDecoration(hintText: "input here")
        ),
        Text('Customer Phone Number :'),
        TextField(
          controller: widget._phno,
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(hintText: "input here"),
        ),
        Text('Customer Tower :'),
        TextField(
          controller: widget._bld,
          decoration: new InputDecoration(hintText: "input here"),
        ),
        Text("Customer Flat :"),
        TextField(
          controller: widget._flatno,
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(hintText: "input Here"),
        ),
      ],
    );
  }
}
