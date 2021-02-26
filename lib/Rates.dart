import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          TextField(
            controller: searchBarController,
          ),
          Divider(),
          Container(
            height: MediaQuery.of(context).size.height - 150,
            child: Builder(
              builder: (context) {
                if (veggies != null) {
                  return ListView.builder(
                      itemCount: filteredAfterSearch.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(filteredAfterSearch[i].name),
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
      setState(() {
        filteredAfterSearch = veggies.where((element) => element.name.toLowerCase().startsWith(searchBarController.text.toLowerCase())).toList();
      });
    }
    else
      setState(() {
        filteredAfterSearch = veggies;
      });
  }

  Future<void> setRate(String uid) async {
    var firestore = Firestore.instance;
    Auth r = Auth();
    String market = r.currentUser.market;
    DocumentSnapshot doc = await firestore.collection('markets').document(market).collection('vegetables_test').document(uid).get();
    showDialog(
        context: _key.currentContext,
        builder: null, /// complete
    );
  }
}
