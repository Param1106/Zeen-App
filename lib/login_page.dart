import 'package:enactusdraft2/auth.dart';
import 'package:enactusdraft2/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _name = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool authError = false;
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? MediaQuery.of(context).size.height - 50.0 : MediaQuery.of(context).size.width - 50.0,
                  height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? MediaQuery.of(context).size.height - 50.0 : MediaQuery.of(context).size.width - 50.0,
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30.0,),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText:  check && _name.text.isEmpty ? 'Enter valid username' : authError ? 'Wrong username or password' : null,
                  ),
                ),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText:  check && _pass.text.isEmpty ? 'Enter valid password' : authError ? 'Wrong username or password' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        check = true;
                      });
                      var user = AuthItem(
                        name: _name.text,
                        pass: _pass.text,
                      );
                      var auth = Auth();
                      auth.setCurrUser = user;
                      bool valid = await auth.authenticate();
                      if(valid) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()), (route) => false);
                      }
                      else {
                        setState(() {
                          authError = true;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(offset: Offset(0.0, 6.0), blurRadius: 5.0, color: Colors.black26)
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: Text('LOG IN', style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _pass.dispose();
    super.dispose();
  }
}
