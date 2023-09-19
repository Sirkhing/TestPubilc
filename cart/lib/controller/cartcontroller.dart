import 'dart:convert';

import 'package:cart/controller/usercontroller.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';
import '../model/shopingcart.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

import 'dummy.dart';

class Cartcontroller extends GetxController {
  late final Product prodItems;
  var cartItems = <Product>[].obs;
  final bool delete = false;
  @override
  final MemberController mem = Get.find<MemberController>();
  final ProductController pro = Get.find<ProductController>();
  var urll = 'https://typescript-staging.agsdev.workers.dev/Temp';
  Future<void> fetchUserCart(String userId) async {
    try {
      final url = Uri.parse('$urll/user/$userId/allcart');

      final response = await http.post(url);

      final statusCode = response.statusCode;
      if (statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> cartJsonList = jsonData['shoppingCart'] ?? [];

        List<shopingcart> shoppingCart = cartJsonList.map((cartJson) {
          return shopingcart.fromJson(cartJson);
        }).toList();

        // Now you have the shopping cart data, you can update your user's shopping cart
        // Example: user.shoppingCart = shoppingCart;
        print("Fetched shopping cart successfully");
      } else {
        print('Fetching shopping cart failed');
      }
    } catch (error) {
      print('Error fetching shopping cart: $error');
    }
  }

  //
  // Future<void> sendQuantityBack(Result user, Product product) async {
  //   final cartProduct = user.shoppingCart.firstWhere(
  //         (cartProduct) => cartProduct.id == product.id,
  //     orElse: () => shopingcart( // Provide a default shopingcart instance
  //       id: product.id, name: product.name, price: product.price, imageUrl:product.imageUrl, date:product.date, description: product.description, count: 0,
  //       // Fill in other properties with appropriate default values
  //     ),
  //   );
  //
  //   // Now, you can access the properties of cartProduct without null issues
  //   product.quantity += cartProduct.count;
  //
  //   // Remove the product from the user's shopping cart
  //   user.shoppingCart.removeWhere((cartProduct) => cartProduct.id == product.id);
  //
  //   // Update your UI or state as needed
  //
  //
  //   update(user.shoppingCart);
  //   refresh();
  // }
  Future<double> removeToCartUser(Result user, shopingcart shopproduct) async {
    final url = Uri.parse('$urll/product/${user.resultId}/${shopproduct.id}/cart/delete');
    print(user.resultId);

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final cartProductIndex = user.shoppingCart.indexWhere((item) => item.id == shopproduct.id);
        final cartsProductIndex = pro.cartItems.indexWhere((item) => item.id == shopproduct.id);

        if (cartProductIndex != -1) {
          // Add the count back to the product's quantity
          pro.cartItems[cartsProductIndex].quantity += user.shoppingCart[cartProductIndex].count;

          // Update the quantity of the product in the shopping cart
          user.shoppingCart[cartProductIndex].count += user.shoppingCart[cartProductIndex].count;

          print("============${user.shoppingCart[cartProductIndex].count}============");
        } else {
          // Handle the case where the product was not found in the shopping cart
          print("Product not found in shopping cart with id: ${shopproduct.id}");
        }

        // Remove the product from the shopping cart in the user's profile
        user.shoppingCart.removeWhere((cartProduct) => cartProduct.id == shopproduct.id);

        // Fetch updated products after removal (if needed)
         pro.updaterproduct(pro.cartItems[cartsProductIndex], shopproduct.id);

        // Update the user's profile
        // await mem.updateProfile(user);

        // Update your UI or state as needed
        update(user.shoppingCart);
        refresh();

        // Successfully deleted the product from the shopping cart
        print("Product deleted successfully");
      } else {
        // Handle other status codes if needed
        print("Failed to delete product. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any network or exception errors
      print("Error: $error");
    }

    // Calculate the total price of the items remaining in the shopping cart
    double totalPrice = user.shoppingCart.fold(
      0.0,
          (previousValue, cartProduct) => previousValue + cartProduct.price,
    );

    print("Removed from shopping cart: ${shopproduct.name}");
    print("Total Price: $totalPrice");

    // Save the updated shopping cart data

    return totalPrice;
  }
  Future<void> sendQuantityBack(Result user, Product cartProduct) async {
    // Iterate through the shoppingCart to find the corresponding shopingcart
    for (final cartItem in user.shoppingCart) {
      if (cartItem.id == cartProduct.id) {
        // Add the count from the shopingcart to the cartProduct's count
        cartProduct.quantity += cartItem.count;
        break; // Stop iterating once the corresponding cartItem is found
      }
    }

    // Update your UI or state as needed
    update(user.shoppingCart);
    refresh();
  }

  Future<void> saveShoppingCart(
      Result user, List<shopingcart> shoppingCart) async {
    try {
      final url = Uri.parse('$urll/user/${user.resultId}/cart');
      final List<Map<String, dynamic>> cartItems =
          shoppingCart.map((cartProduct) => cartProduct.toJson()).toList();

      final response = await http.put(
        url,
        body: jsonEncode({"shoppingCart": cartItems}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Shopping cart data saved successfully');
      } else {
        print('Failed to save shopping cart data');
      }
    } catch (error) {
      print('Error during saving shopping cart data: $error');
    }
  }

  // Load shopping cart data from SharedPreferences
  Future<List<shopingcart>> loadShoppingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = prefs.getStringList('shoppingCart') ?? [];
    List<shopingcart> shoppingCart = cartJsonList.map((cartJson) {
      Map<String, dynamic> cartItemJson = json.decode(cartJson);
      return shopingcart.fromJson(cartItemJson);
    }).toList();
    return shoppingCart;
  }
}
