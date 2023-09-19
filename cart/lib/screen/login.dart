
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/Auth/login.dart';

class loginpage extends StatefulWidget {

  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Login")),
          ),
        ),
        body: LoginWidget());
  }
}
