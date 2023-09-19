import 'package:cart/controller/Oder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class order extends StatefulWidget {
  order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  final Odercontrolle oder = Get.find<Odercontrolle>();
  int seleteindex = 0 ;


  void toggleSelection(int index) {
    setState(() {
      if (oder.selectedIndices.contains(index)) {
        oder.selectedIndices.remove(index);
      }
    });
  }

  void verifyOder(int index) {
    setState(() {
      if (oder.selectedIndices.contains(index)) {
        oder.selectedIndices.remove(index);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: oder.selectedIndices.length,
                  itemBuilder: (BuildContext context, int index) {
                    final order = oder.odernotdonelist[index];
                    final isSelected = oder.selectedIndices.contains(index);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0,right: 20),
                                child: CircleAvatar(radius: 35,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 75),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Status: ${order.status}"),
                                    Text("ID: ${order.id}"),
                                    Text("Name: ${order.user?[index].name} ${order.user?[index].lastName}"),
                                    Text("Date: ${order.date}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [

                                  Spacer(),
                                  seleteindex == 1
                                      ? IconButton(
                                    color: isSelected ? Colors.green : null,
                                    onPressed: () {
                                      toggleSelection(index);
                                    },
                                    icon: isSelected
                                        ? Icon(Icons.check_circle)
                                        : Icon(Icons.circle_outlined),
                                  )
                                      : Text(' '),],),
                              )
                            ],
                          ),

                          children: <Widget>[
                            // Sub-orders list
                            ListView.builder(
                              shrinkWrap: true,

                              itemCount: order.shoppingCart?.length,
                              itemBuilder: (BuildContext context, int subIndex) {
                                final subOrder = order.shoppingCart?[subIndex];
                                return Card(
                                  elevation: 2, // Add elevation for a card-like appearance
                                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage("${subOrder?.imageUrl}"),
                                    ),
                                    title: Text("Product ID: ${subOrder?.id}"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Name: ${subOrder?.name}"),
                                        Text("Price: \$${subOrder?.price.toStringAsFixed(2)}"), // Format price as currency
                                        Text("Count: ${subOrder?.count}"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ClipOval(
                  child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: seleteindex == 0 ? MaterialStateProperty.all<Color>(
                      Color(0xFFFFD700)): MaterialStateProperty.all<Color>(
                      Color(0xFFFF002B))
                ),
                onPressed: () {
                  setState(() {
                    if(seleteindex == 0){
                      seleteindex =1;
                    }else{
                      seleteindex = 0;
                    }
                  });

                  // Add your onPressed logic here
                },
                child: seleteindex == 0 ? Text(
                  'Confirm Order',
                  style: TextStyle(
                    color: Colors.black, // Text color
                  ),
                ):Text(
                  'Cancle',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                )
              )),
            ],
          ),
        ],
      ),
    );
  }
}



