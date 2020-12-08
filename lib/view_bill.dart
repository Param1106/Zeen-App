import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactusdraft2/auth.dart';
import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewBill extends StatefulWidget {
  @override
  _ViewBillState createState() => _ViewBillState();
}

class _ViewBillState extends State<ViewBill> {
  AuthItem user = Auth().currentUser;
  TextEditingController _controller = TextEditingController();
  String billNumber;
  String market;
  double total;
  List<Vegetable> veggies = [];

  @override
  void initState() {
    market = user.market;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Billing Informaion"),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.0,),
                Text('Enter Bill Number: ', style: TextStyle(fontSize: 16.0),),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 100 - 35.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _controller,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        print(_controller.text);
                        String id = _controller.text;
                        id = id.length < 6 ? '0'*(6-id.length)+id : id;
                        billNumber = id;
                        var res = await deets(billNumber);
                        setState(() {
                          veggies = res;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                          child: Text('VIEW', style: TextStyle(fontSize: 14.0),),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 2.0,),
          SingleChildScrollView(
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (billNumber != null) {
                      return Card(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 250,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Bill Number: ${billNumber ?? ""}',
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: veggies == null ? 0 : veggies.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${veggies[i].name}'),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                              child: Text('Total: ${veggies[i].total}'),
                                            ),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Price: ${veggies[i].price}'),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                child: Text('Quantity:${veggies[i].qty}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Vegetable>> deets(String billNum) async {
    DocumentSnapshot doc = await Firestore.instance.collection('markets').document(market).collection('bills').document(billNum).get();
    List<dynamic> lst = doc.data['bill'];
    double total = doc.data['total'];
    this.total = total;
    List<Vegetable> vegs = [];
    lst.forEach((element) {
      Vegetable item = Vegetable(
        name: element['item'],
        price: element['price'],
        qty: element['quantity'],
      );
      item.total = item.price * item.qty;
      vegs.add(item);
    });
    return vegs;
  }
}
