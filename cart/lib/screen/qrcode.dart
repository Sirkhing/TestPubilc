import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qrcode extends StatelessWidget {
  final double totalPrice;
   qrcode({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: totalPrice.toString(),
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
