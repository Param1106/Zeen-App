import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TotalBar extends StatefulWidget {
  final double bill;

  TotalBar({this.bill});

  @override
  _TotalBarState createState() => _TotalBarState();
}

class _TotalBarState extends State<TotalBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Bill:', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),),
            Container(
                child: Row(
                  children: [
                    Text('${widget.bill}', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10.0,),
                    FlatButton(child: Text('Done'), onPressed: (){}, color: Colors.green,)
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
