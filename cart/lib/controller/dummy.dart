import 'dart:convert';
import 'dart:math';

import 'package:cart/controller/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:http/http.dart' as http;
import '../model/product.dart';
import '../model/shopingcart.dart';
import '../model/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'cartcontroller.dart';

class ProductController extends GetxController {
  var cartItems = <Product>[].obs;
  final MemberController mem = Get.find<MemberController>();


  // ProductList productList = ProductList();
  var urll = 'https://typescript-staging.agsdev.workers.dev/Temp';
  int generateRandomInt(int length) {
    final random = Random.secure();
    final values = List<int>.generate(
        length, (i) => random.nextInt(10)); // Generating digits between 0 and 9
    final randomInt = int.parse(values.join());
    return randomInt;
  }

  int selectedQuantity = 1;
  @override
  void onInit() {
    fetchProducts();

    super.onInit();
  }

  Future<List<Product>?> fetchProducts() async {
    final response = await http.post(Uri.parse('$urll/products'));

    try {
      if (response.statusCode == 200) {
        // If the server returned a 200 OK response,
        // then parse the JSON.
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        if (responseData.containsKey('result') &&
            responseData['result'] is List) {
          final List<dynamic> productDataList = responseData['result'];
          List<Product> products = [];

          for (int i = 0; i < productDataList.length; i++) {
            dynamic productData = productDataList[i];
            Product product = Product.fromJson(productData);
            product.index = i; // Set the index for the product
            products.add(product);
          }


          cartItems.assignAll(products);

          return products;
        } else {
          // Handle the case where 'result' key is not found or is not a list in the response.
          print("No products found");
          return null;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load PRODUCTS');
      }
    } catch (error) {
      print("PRODUCT ERROR");
      print("An error occurred: $error");
      return null; // Return null to indicate an error
    }
  }

  Future<void> addNewProduct(Product productData) async {
    try {
      final url = Uri.parse('$urll/addproduct');

      final data = productData.toJson();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final statusCode = response.statusCode;

      if (statusCode == 200) {
        try {
          final CollectionReference productsCollection =
              FirebaseFirestore.instance.collection('products');

          await productsCollection.doc(productData.id.toString()).set({
            'id': productData.id,
            'name': productData.name,
            'description': productData.description,
            'price': productData.price,
            'imageUrl': productData.imageUrl,
            'date': productData.date,
            'quantity': productData.quantity,
            'picker': productData.index,
          });

          print('Product added to Firestore successfully');
        } catch (e) {
          print('Error adding product to Firestore: $e');
        }
        final dynamic jsonResponse = json.decode(response.body);

        print('Response Body: $jsonResponse');

        if (jsonResponse is Map<String, dynamic>) {
          final productRegistration =
              ProductRegistration.fromJson(jsonResponse);
          print('Product Registration: $productRegistration');

          if (productRegistration.result.isNotEmpty) {
            final addedProduct = productRegistration.result[0];

            // Check if a product with the same name already exists in the cart
            final isProductInCart = cartItems.any((cartProduct) =>
                cartProduct.name.toLowerCase() ==
                addedProduct.name.toLowerCase());

            if (!isProductInCart) {
              // Insert the new product at the beginning of the cartItems list
              cartItems.insert(0, addedProduct);

              Get.snackbar(
                'Add Product Successful',
                'Product ${addedProduct.name} has been successfully added!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

              // Trigger a UI update
              update(cartItems);

              // Optionally, scroll to the added product in the UI
            } else {
              // Product with the same name is already in the cart, show a message
              Get.snackbar(
                'Product Already in Cart',
                'Product ${addedProduct.name} is already in your cart.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            }
          } else {
            print('No products were added in the response');
          }
        }
      } else {
        print('Add Product Failed');
        Get.snackbar(
          'Add Product Failed',
          'An error occurred while adding the product. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print('Error during product registration: $error');
    }

    // Fetch updated products
    await fetchProducts();
  }

  Future<void> updaterproduct(Product product, int index) async {
    try {
      final Map<String, dynamic> requestData = {
        "id": product.id,
        "imageUrl": product.imageUrl,
        "name": product.name,
        "date":product.date,
        "description": product.description,
        "price": product.price,
        "quantity": product.quantity,
        "index": product.index
      };

      final String requestBody = jsonEncode(requestData);

      final response = await http.post(
        Uri.parse('$urll/product/${product.id}/update'),
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Check if the 'result' key is present and true
        // Trigger a UI update
        update(cartItems);

        // Optionally, fetch updated products



      } else {
        // Handle other status codes if needed
        Get.snackbar('Error', 'Failed to update product',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      await fetchProducts();
    } catch (error) {
      print(error);
    }
  }


  Future<void> removeFromCart(Result users, Product product) async {
    try {
      final url = Uri.parse('$urll/product/${users.resultId}/${product.id}/delete');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Check if the product exists in the shopping cart
        final cartItemExists = users.shoppingCart.any((item) => item.id == product.id);

        if (cartItemExists) {
          // If the product exists in the shopping cart, remove it from the local cart items and users.shoppingCart
          cartItems.removeWhere((item) => item.id == product.id);
          users.shoppingCart.removeWhere((item) => item.id == product.id);
        }

        // Always delete the product directly
        product.quantity = 0;

        // Trigger a UI update
        update();

        // Fetch updated products after removal (if needed)
        await updaterproduct(product, product.id);
        await fetchProducts();

        print("Removed from cart: ${product.name}");
      } else {
        cartItems.removeWhere((item) => item.id == product.id);
      }
    } catch (error) {
      print("Error removing from cart: $error");
    }
  }
  Future<void> addToCartUser(Result user, Product product) async {

    try {

      final existingProductIndex = user.shoppingCart.indexWhere(
            (cartProduct) => cartProduct.id == product.id,
      );

      if (existingProductIndex != -1) {
        // If the product already exists in the cart, increment the count
        user.shoppingCart[existingProductIndex].count += selectedQuantity;

        // Decrease the product quantity by selectedQuantity
        product.quantity -= selectedQuantity;
      } else {
        // If the product is not in the cart, create a new shopping cart item
        final shoppingCartItem = shopingcart(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          date: DateTime.now().toIso8601String(),
          count: selectedQuantity,
          description: product.description,
        );
        product.index +=1;
        user.shoppingCart.add(shoppingCartItem);

        // Decrease the product quantity by selectedQuantity
        product.quantity -= selectedQuantity;


      }

      final Map<String, dynamic> cartItem = {
        "id": product.id,
        "name": product.name,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "date": DateTime.now().toIso8601String(),
        "description": product.description,
        "count": (existingProductIndex != -1)
            ? user.shoppingCart[existingProductIndex].count
            : selectedQuantity, // Use the updated count
      };

      final url = Uri.parse('$urll/user/${user.resultId}/cart');
      final response = await http.post(url, body: jsonEncode(cartItem));

      final statusCode = response.statusCode;
      if (statusCode == 200) {
        await updaterproduct(product, product.id);
        await fireaddToCartUser(user, product);
        // await mem.updateProfile(user);

        print('Added to Cart Successful');
        // Handle success response here
      } else {
        print('Added to Cart Failed');
        // Handle failure response here

      }
    } catch (error) {
      print('Error during adding to cart HTTP: $error');
      // Handle error here
    }

    update();
  }


  Future<void> fireaddToCartUser(Result user, Product product) async {
    try {
      // Create a reference to the Firestore document for the user
      final userDocRef =
          FirebaseFirestore.instance.collection('member').doc(user.resultId);

      // Retrieve the current shopping cart array from Firestore
      final docSnapshot = await userDocRef.get();
      final List<dynamic> shoppingCart = docSnapshot['shoppingCart'] ?? [];

      // Find the index of the product in the shopping cart
      final existingProductIndex = shoppingCart.indexWhere(
        (cartProduct) => cartProduct['id'] == product.id,
      );

      if (existingProductIndex != -1) {
        // If the product already exists in the cart, increment the count
        shoppingCart[existingProductIndex]['count'] += 1;
      } else {
        // If the product is not in the cart, create a new shopping cart item
        final Map<String, dynamic> cartItem = {
          "id": product.id,
          "name": product.name,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "date": DateTime.now().toIso8601String(),
          "count": 1, // Assuming count is initially 1 when adding to cart
        };


        shoppingCart.add(cartItem);
      }

      // Update the shopping cart array in the Firestore document
      await userDocRef.update({
        'shoppingCart': shoppingCart,
      });
    } catch (error) {
      print('Error during adding to cart: $error');
      // Handle error here
    }

    update();
  }



}
