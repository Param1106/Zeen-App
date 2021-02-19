import 'package:enactusdraft2/auth.dart';
import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewSales extends StatefulWidget {
  @override
  _ViewSalesState createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  double cellWidth;

  @override
  Widget build(BuildContext context) {
    cellWidth = (MediaQuery.of(context).size.width - 38)/4;

    return Scaffold(
      appBar: AppBar(title: Text('Sales Information'),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.green
            ),
            child: Card(
              elevation: 5.0,
              child: Column(
                children: [
                  Text('Best Sellers', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.green,)),
                  FutureBuilder(
                    future: getRows(),
                    builder: (context, asyncMethod) {
                      if(asyncMethod.hasData) {
                        print(asyncMethod.data);
                        var rows = asyncMethod.data;
                        print(rows);
                        return DataTable(
                          columnSpacing: 0,
                          columns: [
                            DataColumn(label: Container(width: cellWidth,child: Card(elevation: 0, child: Text('Vegetable')))),
                            DataColumn(label: Container(width: cellWidth,child: Card(elevation: 0, child: Text('Sold')))),
                            DataColumn(label: Container(width: cellWidth,child: Card(elevation: 0, child: Text('Original Stock'),))),
                            DataColumn(label: Container(width: cellWidth,child: Card(elevation: 0, child: Text('%')))),
                          ],
                          rows: rows,
                        );
                      }
                      return CircularProgressIndicator();
                    })
                ],
              ),
            ),
          ),
          Card(
            child: Expanded(
              child: SingleChildScrollView(
                child: Container(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<DataRow>> getRows() async {
    List<DataRow> rows = [];
    Auth r = Auth();
    String market = r.currentUser.market;
    print(market);
    var firestore = Firestore.instance;
    QuerySnapshot docs = await firestore.collection('markets').document(market).collection('vegetables_test').getDocuments();
    print(docs.documents.length);
    docs.documents.forEach((e) {
      var item = Vegetable(
        uid: e.documentID,
        name: e.data['v_name'],
        price: e.data['v_price'],
        ogQty: e.data['og_stock'],
        qty: e.data['stock']
      ); /// stuck here

      print(item.uid);
      var diff = item.ogStock - item.qty;
      var row = DataRow(cells: [
        DataCell(Container(
          width: cellWidth,
          child: Card(
            elevation: 0,
            child: Text(item.name),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          child: Card(
            elevation: 0,
            child: Text((diff).toString()),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          child: Card(
            elevation: 0,
            child: Text(item.ogStock.toString()),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          child: Card(
            elevation: 0,
            child: Text(((diff/item.ogStock)*100).toString()+'%'),
          ),
        ))
      ]);
      rows.add(row);
    });
    return rows;
  }
}
