import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/Oder.dart';
import '../../model/user.dart';
import '../../screen/historyoder.dart';
import '../../screen/odernotdone.dart';
import '../../screen/order.dart';
import 'package:get/get.dart';

class allOder extends StatefulWidget {
  final Result userData;
  const allOder({super.key, required this.userData});

  @override
  State<allOder> createState() => _allOderState();
}

class _allOderState extends State<allOder> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Odercontrolle oder = Get.find<Odercontrolle>();
  @override
  void initState() {
    oder.fetchProducts();

    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(" ODER "),
        bottom: TabBar(
          controller: _tabController, // Use the TabController here
          tabs: [
            Tab(text: 'not done'), // Tab 1
            Tab(text: 'done'),     // Tab 2
            Tab(text: 'history'),     // Tab 2
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Use the TabController here
        children: [
          // Content for the "Order not done" tab
          orderNotDoneContent(),

          // Content for the "Order done" tab
          orderDoneContent(),
          history(),
        ],
      ),
    );
  }

  Widget orderNotDoneContent() {
    // Create and return the content for the "Order not done" tab
    return ordernotdone();
  }

  Widget orderDoneContent() {
    // Create and return the content for the "Order done" tab
    return order();
  }
  Widget history() {
    // Create and return the content for the "Order done" tab
    return allhistory();
  }
}
