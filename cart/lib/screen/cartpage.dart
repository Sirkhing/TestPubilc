import 'package:cart/screen/qrcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cartcontroller.dart';
import '../controller/dummy.dart';
import '../model/product.dart';
import '../model/shopingcart.dart';
import '../model/user.dart';
import '../widget/animationback.dart';

class CartPage extends StatefulWidget {
  final List<int> cartIndices;
  final Result user;

  CartPage(this.user, this.cartIndices);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Cartcontroller cartController = Get.find<Cartcontroller>();
  final ProductController proController = Get.find<ProductController>();

  // Track the loading state for each item in the cart
  List<bool> isRemovingItem = [];

  double calculateTotalPrice(List<shopingcart> shoppingCart) {
    double totalPrice = 0.0;

    for (final cartProduct in shoppingCart) {
      totalPrice += cartProduct.price * cartProduct.count;
    }

    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the loading state for each item in the cart to false
    isRemovingItem =
        List.generate(widget.user.shoppingCart.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<shopingcart> shoppingCart = widget.user.shoppingCart;

    return Scaffold(
      body: shoppingCart.isEmpty
          ? Stack(
              children: [
                cartBackground(),
                Center(
                  child: Card(
                      child: SizedBox(
                          height: 50,
                          width: 150,
                          child: Center(child: Text('Your Cart is empty.')))),
                ),
              ],
            )
          : Stack(
              children: [
                cartBackground(),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: shoppingCart.length,

                        itemBuilder: (BuildContext context, int index) {
                          final shopingcart cartItem = shoppingCart[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      child: AlertDialog(
                                        title: Row(
                                          children: [
                                            Text('Product Details'),
                                            Spacer(),
                                          ],
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network(cartItem.imageUrl),
                                            SizedBox(height: 8),
                                            Text(
                                                'Product Name: ${cartItem.name}'),
                                            Text(
                                                'Product Description: ${cartItem.description}'),
                                            Text(
                                                'Price: \$${cartItem.price.toStringAsFixed(2)}'),
                                            Text(
                                                'Date: ${cartItem.date.toString()}'),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              Spacer(),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      SizedBox(
                                          width: 50,
                                          height: 50,
                                          child:
                                              Image.network(cartItem.imageUrl)),
                                      Text("    ${cartItem.name}"),
                                      Spacer(),
                                      isRemovingItem[index]
                                          ? CircularProgressIndicator() // Show loading indicator when removing item
                                          : IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  isRemovingItem[index] = true;
                                                });

                                                await cartController
                                                    .removeToCartUser(
                                                        widget.user, cartItem);

                                                setState(() {
                                                  isRemovingItem[index] = false;
                                                });
                                              },
                                              icon: isRemovingItem[index]
                                                  ? CircularProgressIndicator() // Show loading indicator when removing item
                                                  : Icon(Icons
                                                      .remove_circle_outline),
                                            ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          "\$${cartItem.price.toStringAsFixed(2)}"),
                                      Spacer(),
                                      Text("Count : ${cartItem.count} EA"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    BottomAppBar(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total Price: \$${calculateTotalPrice(shoppingCart).toStringAsFixed(2)}",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => qrcode(
                                  totalPrice:
                                      calculateTotalPrice(shoppingCart)));
                              print("Cart Indices: ${widget.cartIndices}.");
                              print("Cart user: ${widget.user}.");
                              print("Shopping Cart: ${shoppingCart}");
                            },
                            child: Text("Check Out"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
