import 'dart:ffi';

import 'package:enactusdraft2/vegetable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDropDown extends StatefulWidget {
  final onTap;

  CustomDropDown({this.onTap});
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height - 50,
      child: StreamBuilder(
        stream: Firestore.instance.collection('v_challengers').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Text('Loading...');
          else
            return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot vDoc = snapshot.data.documents[index];
                  Vegetable v = Vegetable(uid: vDoc.documentID, name: vDoc.data['v_name'], price: vDoc.data['v_price']);
                  return InkWell(
                    onTap: () {
                      widget.onTap(v);
                      Navigator.of(context).pop(v);
                    },
                    child: Container(
                      child: Text('${v.name}'),
                    ),
                  );
                }
            );
        },
      ),
    );
  }
}
