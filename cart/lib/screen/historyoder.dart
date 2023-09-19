import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/Oder.dart';
import 'package:get/get.dart';
class allhistory extends StatelessWidget {
   allhistory({super.key});

  @override
  final Odercontrolle oder = Get.find<Odercontrolle>();
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: oder.allorder.length,
                  itemBuilder: (BuildContext context, int index) {
                    final isSelected = oder.selectedIndices.contains(index);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(

                          title: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network('cartItem.imageUrl'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order of user :"),
                                    Text("Order of name :"),
                                    Text("Date of Order :"),
                                    Text("Price 0.0"),
                                    Text("Count : 0 EA"),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),

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
        ],
      ),
    );
  }
}
