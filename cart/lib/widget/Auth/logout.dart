import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class logout extends StatelessWidget {
  const logout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('You need to log out. Logging out in 5 seconds...'),
        ],
      ),
    );
  }
}
