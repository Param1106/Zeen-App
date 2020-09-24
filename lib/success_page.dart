import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String billID;

  SuccessPage({this.billID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 250.0,),
              Text('Bill Id: $billID', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),)
            ],
          ),
        ),
      ),
    );
  }
}
