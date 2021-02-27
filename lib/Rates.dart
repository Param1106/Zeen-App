import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth.dart';

class Rates extends StatefulWidget {
  @override
  _RatesState createState() => _RatesState();
}

class _RatesState extends State<Rates> {
  TextEditingController searchBarController = TextEditingController();
  List<Vegetable> veggies;
  List<Vegetable> filteredAfterSearch;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    searchBarController.addListener(search);
    getVeggies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text('Rates'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            TextField(
              controller: searchBarController,
            ),
            Divider(thickness: 5.0, color: Colors.green,),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              child: Builder(
                builder: (context) {
                  if (veggies != null) {
                    return ListView.builder(
                        itemCount: filteredAfterSearch.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: filteredAfterSearch[i].name.startsWith(searchBarController.text) ?
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: filteredAfterSearch[i].name.substring(0, searchBarController.text.length), style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: filteredAfterSearch[i].name.substring(searchBarController.text.length))
                                    ],
                                    style: TextStyle(color: Colors.black, fontSize: 18)
                                  )
                                )
                                : Text(filteredAfterSearch[i].name),
                            trailing: Text('Rs.'+filteredAfterSearch[i].price.toString()),
                            onTap: () {
                              setRate(filteredAfterSearch[i].uid);
                            },
                          );
                        });
                  }
                  return CircularProgressIndicator();
              }
              ),
            ),
          ],
        ),
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

  search() {
    if (searchBarController.text != '') {
      var temp = veggies.where((element) => element.name.toLowerCase().startsWith(searchBarController.text.toLowerCase())).toList();
      setState(() {
        filteredAfterSearch = temp + veggies.where((element) => temp.indexOf(element) == -1).toList();
      });
    }
    else
      setState(() {
        filteredAfterSearch = veggies;
      });
  }

  Future<void> setRate(String uid) async {
    var firestore = Firestore.instance;
    TextEditingController newRate = TextEditingController();
    bool _valid = true;
    Auth r = Auth();
    String market = r.currentUser.market;
    var newVal = await showDialog(
        context: _key.currentContext,
        builder: (context) {
          return Dialog(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: newRate,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        errorText: _valid ? null : 'Not a valid rate',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () {
                            newRate.text == '' || num.tryParse(newRate.text) == null ? _valid=false :
                            Navigator.pop(context, num.tryParse(newRate.text));
                          },
                          child: Text('Change')
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                            child: Text('Cancel')
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
    );
    print(newVal ?? 'Cancelled');
    await firestore.collection('markets').document(market).collection('vegetables_test').document(uid).updateData({'v_price': newVal});
    await getVeggies();
  }
}
