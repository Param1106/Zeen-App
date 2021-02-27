import 'package:enactusdraft2/auth.dart';
import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ViewSales extends StatefulWidget {
  @override
  _ViewSalesState createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  double cellWidth;
  List<Vegetable> veggies;
  List<Vegetable> filteredAfterSearch;
  TextEditingController searchBarController = TextEditingController();

  @override
  void initState() {
    getVeggies();
    super.initState();
    
    searchBarController.addListener(search);
  }

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
                  Builder(
                    builder: (context) {
                      if (veggies != null) {
                        var rows = getBestSellers();
                          return DataTable(
                            columnSpacing: 0,
                            dataRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected))
                                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                              return Colors.white;  // Use the default value.
                            }),
                            headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected))
                                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                              return Colors.white;  // Use the default value.
                            }),
                            columns: [
                              DataColumn(label: Container(width: cellWidth, child: Card(elevation: 0, child: Text('Vegetable')))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('Sold')))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('Original Stock'),))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('%')))),
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
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.green),
              ),
              controller: searchBarController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: Builder(
                      builder: (context) {
                        if (filteredAfterSearch != null) {
                          return DataTable(
                            dataRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected))
                                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                              return Colors.white;  // Use the default value.
                            }),
                            headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected))
                                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                              return Colors.white;  // Use the default value.
                            }),
                            columnSpacing: 0,
                            columns: [
                              DataColumn(label: Container(width: cellWidth, child: Card(elevation: 0, child: Text('Vegetable')))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('Sold')))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('Original Stock'),))),
                              DataColumn(label: Container(width: cellWidth, alignment: Alignment.center, child: Card(elevation: 0, child: Text('%')))),
                            ],
                            rows: filteredAfterSearch.map((e) => getSingleRow(e)).toList(),
                          );
                        }
                        return CircularProgressIndicator();
                      }),
            )
          )
        ],
      ),
    );
  }

  Future<void> getVeggies() async {
    List<Vegetable> temp = [];
    Auth r = Auth();
    String market = r.currentUser.market;
    var firestore = Firestore.instance;
    QuerySnapshot docs = await firestore.collection('markets').document(market).collection('vegetables_test').getDocuments();
    docs.documents.forEach((e) {
      Vegetable item = Vegetable(uid: e.documentID, name: e.data['v_name'], price: e.data['v_price'].toDouble(), ogQty: e.data['og_stock'].toDouble(), qty: e.data['stock'].toDouble());
      temp.add(item);
    });
    setState(() {
      veggies = temp;
      filteredAfterSearch =temp;
    });
  }

  List<DataRow> getBestSellers() {
    List<DataRow> rows = [];
    veggies.sort((a, b) => (b.ogStock - b.qty).compareTo(a.ogStock - a.qty));
    int num = min(5, (veggies.length*0.05).ceil());
    for(int i=0; i < num; i++) {
      double diff = veggies[i].ogStock - veggies[i].qty;
      var row = DataRow(cells: [
        DataCell(Container(
          width: cellWidth,
          child: Card(
            elevation: 0,
            child: Text(veggies[i].name),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          alignment: Alignment.center,
          child: Card(
            elevation: 0,
            child: Text((diff).toString()),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          alignment: Alignment.center,
          child: Card(
            elevation: 0,
            child: Text(veggies[i].ogStock.toString()),
          ),
        )),
        DataCell(Container(
          width: cellWidth,
          alignment: Alignment.center,
          child: Card(
            elevation: 0,
            child: Text(((diff/veggies[i].ogStock)*100).toString()+'%'),
          ),
        ))
      ]);
      rows.add(row);
    }
    return rows;
  }

  DataRow getSingleRow(Vegetable v) {
    double diff = v.ogStock - v.qty;
    return DataRow(cells: [
      DataCell(Container(
        width: cellWidth,
        child: Card(
          elevation: 0,
          child: Text(v.name),
        ),
      )),
      DataCell(Container(
        width: cellWidth,
        alignment: Alignment.center,
        child: Card(
          elevation: 0,
          child: Text((diff).toString()),
        ),
      )),
      DataCell(Container(
        width: cellWidth,
        alignment: Alignment.center,
        child: Card(
          elevation: 0,
          child: Text(v.ogStock.toString()),
        ),
      )),
      DataCell(Container(
        width: cellWidth,
        alignment: Alignment.center,
        child: Card(
          elevation: 0,
          child: Text(((diff/v.ogStock)*100).toString()+'%'),
        ),
      ))
    ]);
  }

  search() {
    if (searchBarController.text != '') {
      setState(() {
        filteredAfterSearch = veggies.where((element) => element.name.toLowerCase().startsWith(searchBarController.text.toLowerCase())).toList();
      });
    }
    else
      setState(() {
        filteredAfterSearch = veggies;
      });
  }
}
