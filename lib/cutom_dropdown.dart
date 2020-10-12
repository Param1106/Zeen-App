import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDropDown extends StatefulWidget {

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  Vegetable selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height - 50,
      child: StreamBuilder(
        stream: Firestore.instance.collection('markets').document('v_challengers').collection('vegetables').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Text('Loading...');
          else {
            List<Vegetable> sorted = [];
            snapshot.data.documents.forEach((e) {
              sorted.add(Vegetable(uid: e.documentID,
                  name: e.data['v_name'],
                  price: e.data['v_price'].toDouble(),
                qty: e.data['stock'] == null ? 0.0 : e.data['stock'].toDouble(),
              ));
            });
            sorted.sort((a, b) => a.name.compareTo(b.name));
            return ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  Color color = sorted[index].qty == 0.0 ? Colors.blueGrey : Colors.black;
                  return InkWell(
                    onTap: () {
                      if (sorted[index].qty != 0.0) {
                        Navigator.of(context).pop(sorted[index]);
                      }
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${sorted[index].name}', style: TextStyle(color: color),),
                            Text('${sorted[index].qty}', style: TextStyle(color: color),),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
        },
      ),
    );
  }
}
