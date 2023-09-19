import 'package:flutter/material.dart';

import '../widget/Auth/register.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Register Page")),
        ),
      ),
      body: RegisterWidget(),
    );
  }
}
