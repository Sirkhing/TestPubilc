import 'dart:convert';
import 'dart:math';

import 'package:cart/controller/cartcontroller.dart';
import 'package:cart/controller/usercontroller.dart';
import 'package:cart/model/user.dart';
import 'package:cart/screen/cartpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/dummy.dart';
import '../model/product.dart';
import '../widget/Auth/allOder.dart';
import '../widget/Auth/dreawer.dart';
import '../widget/Auth/itemlist.dart';
import '../widget/Auth/widgetforuse.dart';
import 'order.dart';

class homepage extends StatefulWidget {
  final Result userData;

  homepage({super.key, required this.userData});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final ProductController producttroller = Get.find<ProductController>();
  final Cartcontroller cartcontroller = Get.find<Cartcontroller>();
  final MemberController mem = Get.find<MemberController>();
  final Result userData = Get.find<Result>();
  final Product product = Get.find<Product>();

  int generateRandomInt(int length) {
    final random = Random.secure();
    final values = List<int>.generate(
        length, (i) => random.nextInt(10)); // Generating digits between 0 and 9
    final randomInt = int.parse(values.join());
    return randomInt;
  }
bool isLoading= false;
  List<int> cartIndices = [];
  int _currentIndex = 0;
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Cart';
      case 2:
        return 'Oder';
      default:
        return 'My App';
    }
  }



  String generateRandomString(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  @override
  Widget build(BuildContext context) {
    bool showFAB = _currentIndex == 0 && widget.userData.status == 'admin';
    return Scaffold(

      appBar: AppBar(

        actions: [
          IconButton(
            onPressed: () {
             Get.to(allOder(userData: userData,));
            },
            icon: Icon(Icons.safety_check),
          ),
        ],
        title: Text(_getAppBarTitle()),
backgroundColor:_currentIndex == 0 ?  Colors.red :Colors.pinkAccent,
      ),

      body:IndexedStack(
      index: _currentIndex,
      children: [
        FutureBuilder<void>(
          future: producttroller.fetchProducts(), // Replace with your actual data loading function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display the LoadingWidget while waiting for the future to complete
              return LoadingWidget();
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              // Future completed successfully, you can access the result here
              return ItemListWidget(
                cartIndices: List.generate(
                  producttroller.cartItems.length,
                      (index) => index,
                ),
                userData: widget.userData,
              );
            }
          },
        ), FutureBuilder<void>(
          future: cartcontroller.fetchUserCart(widget.userData.resultId), // Replace with your actual data loading function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display the LoadingWidget while waiting for the future to complete
              return LoadingWidget();
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              // Future completed successfully, you can access the result here
              return CartPage(
                widget.userData,
                cartIndices,


              );
            }
          },
        ), // Pass the correct indices here
      ],
    ),
     floatingActionButton: showFAB ? FloatingActionButton(

        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController productnameController =
                  TextEditingController();
              final TextEditingController descriptionController =
                  TextEditingController();
              final TextEditingController imageController =
                  TextEditingController();
              final TextEditingController priceController =
                  TextEditingController();
              final TextEditingController quantityController =
                  TextEditingController();
              final TextEditingController pickerController =
              TextEditingController();

              return AlertDialog(
                title: Text('Add New Product'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: productnameController,
                        decoration: InputDecoration(labelText: 'Product Name'),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(labelText: 'Image URL'),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final productName = productnameController.text;
                      final description = descriptionController.text;
                      final imageUrl = imageController.text;
                      final quantity =
                          int.tryParse(quantityController.text) ?? 0;
                      final price =
                          double.tryParse(priceController.text) ?? 0.0;
                      final pick = 0;

                      if (productName.isNotEmpty &&
                          description.isNotEmpty &&
                          imageUrl.isNotEmpty &&
                          quantity > 0 &&
                          price > 0) {
                        final int newId = producttroller.cartItems
                            .length; // Get the current number of products as the new ID
                        final newProduct = Product(
                          id: newId,
                          name: productName,
                          description: description,
                          price: price,
                          imageUrl: imageUrl,
                          date: DateTime.now().toIso8601String(),
                          quantity: quantity,
                          index: pick,
                        );

                        print(newProduct.index);
                        print(newProduct.id);

                        setState(() {
                          isLoading = true;
                        });

                        isLoading ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoadingWidget();
                          },
                        ) :null;
                        // Call the addNewProduct function to add the new product
                        await producttroller.addNewProduct(newProduct);
setState(() {
  isLoading = false;
});

                        Navigator.pop(context); // Close the dialog
                        productnameController.clear();
                        descriptionController.clear();
                        imageController.clear();
                        priceController.clear();
                        quantityController.clear();
                      }
                    },
                    child: Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar:  BottomNavigationBar(
        fixedColor: _currentIndex == 0 ? Colors.red : Colors.pinkAccent,
       useLegacyColorScheme: true,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            // Add your navigation logic here
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0 ? Icon(Icons.home,color: Colors.red,) : Icon(Icons.home_outlined,color: Colors.pinkAccent),
            label:  _currentIndex == 0 ? 'Home' : ' ',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1 ? Stack(
              children: [
                Icon(Icons.shopping_cart,color: Colors.pinkAccent,),
              ],
            ) : Icon(Icons.shopping_cart_outlined,color: Colors.red),
            label: _currentIndex == 1 ? 'Cart' : '',

          ),
        ],
      ) ,
      drawer: FutureBuilder<void>(
        future: mem.fetchUserData(widget.userData.resultId), // Replace with your actual data loading function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display the LoadingWidget while waiting for the future to complete
            return LoadingWidget();
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            // Future completed successfully, you can access the result here
            return AppDrawer(
              userData: widget.userData,
            );
          }
        },
      ),
    );
  }
}
