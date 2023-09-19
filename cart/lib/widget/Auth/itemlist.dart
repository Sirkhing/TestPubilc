import 'package:cart/controller/cartcontroller.dart';
import 'package:cart/widget/Auth/widgetforuse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dummy.dart';
import '../../controller/usercontroller.dart';
import '../../model/product.dart';
import '../../model/user.dart';
import '../animationback.dart';

class ItemListWidget extends StatefulWidget {
  final List<int> cartIndices;
  final Result userData;

  const ItemListWidget(
      {Key? key, required this.cartIndices, required this.userData})
      : super(key: key);

  @override
  _ItemListWidgetState createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  final ProductController products = Get.find<ProductController>();
  final MemberController userController = Get.find<MemberController>();
  final Cartcontroller cartController = Get.find<Cartcontroller>();
  List userdata = [].obs;
  bool Loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(

          body: products.cartItems.isEmpty
              ? Stack(
                children: [
                  AnimatedBackground(),
                  Center(
                      child: Text('Your store is empty.'),
                    ),
                ],
              )
              : Stack(
                children: [
                  AnimatedBackground(),
                  GetX<ProductController>(
                      builder: (controller) {
                        return GridView.builder(
                          itemCount: products.cartItems.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of items in each row
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: products.cartItems[index].quantity <= 0
                                    ? InkWell(
                                        onTap: () {
                                          print(products.cartItems[index].id);
                                          widget.userData.status == "admin"
                                              ? showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          Text('Product Details'),
                                                          Spacer(),
                                                          IconButton(
                                                            onPressed: () async {
                                                              print(widget
                                                                  .userData.resultId);

                                                              setState(() {
                                                                Loading = true;
                                                              });

                                                              Loading
                                                                  ? showDialog(
                                                                      context: context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return LoadingWidget();
                                                                      },
                                                                    )
                                                                  : null;

                                                              await products
                                                                  .removeFromCart(
                                                                      widget.userData,
                                                                      products.cartItems[
                                                                          index]);
                                                              await cartController
                                                                  .fetchUserCart(widget
                                                                      .userData
                                                                      .resultId);

                                                              setState(() {
                                                                Loading = false;
                                                              });

                                                              Navigator.pop(context);
                                                            },
                                                            icon: Icon(
                                                              Icons.delete_outline,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.network(products
                                                              .cartItems[index]
                                                              .imageUrl),
                                                          SizedBox(height: 8),
                                                          Text(
                                                              'Product Name: ${products.cartItems[index].name}'),
                                                          Text(
                                                              'Product Description: ${products.cartItems[index].description}'),
                                                          Text(
                                                              'Price: \$${products.cartItems[index].price.toStringAsFixed(2)}'),
                                                          Text(
                                                              'Date: ${products.cartItems[index].date.toString()}'),
                                                          Text(
                                                              'Quantity: ${products.cartItems[index].quantity}'),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                      context) {
                                                                    String? productName;
                                                                    double?
                                                                        productPrice;
                                                                    String? imageUrl;
                                                                    String? description;
                                                                    int? quantity;
                                                                    int uid;
                                                                    int picker;

                                                                    // Initialize the variables using the current product data
                                                                    final currentProduct =
                                                                        products.cartItems[
                                                                            index];
                                                                    uid = currentProduct
                                                                        .id;
                                                                    imageUrl =
                                                                        currentProduct
                                                                            .imageUrl;
                                                                    productName =
                                                                        currentProduct
                                                                            .name;
                                                                    productPrice =
                                                                        currentProduct
                                                                            .price;
                                                                    description =
                                                                        currentProduct
                                                                            .description;
                                                                    quantity =
                                                                        currentProduct
                                                                            .quantity;
                                                                    picker =
                                                                        currentProduct
                                                                            .index;

                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Edit Product'),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                          mainAxisSize:
                                                                              MainAxisSize
                                                                                  .max,
                                                                          children: [
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: imageUrl),
                                                                              onChanged:
                                                                                  (value) {
                                                                                imageUrl = products
                                                                                    .cartItems[index]
                                                                                    .imageUrl;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Image URL'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: productName),
                                                                              onChanged:
                                                                                  (value) {
                                                                                productName =
                                                                                    value;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Product Name'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: description),
                                                                              onChanged:
                                                                                  (value) {
                                                                                description =
                                                                                    value;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Description'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: productPrice?.toStringAsFixed(2)),
                                                                              onChanged:
                                                                                  (value) {
                                                                                productPrice =
                                                                                    double.tryParse(value);
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Price'),
                                                                              keyboardType:
                                                                                  TextInputType
                                                                                      .number,
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: quantity.toString()),
                                                                              onChanged:
                                                                                  (value) {
                                                                                quantity =
                                                                                    int.tryParse(value);
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Quantity'),
                                                                              keyboardType:
                                                                                  TextInputType
                                                                                      .number,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (productName != null &&
                                                                                imageUrl !=
                                                                                    null &&
                                                                                productPrice !=
                                                                                    null &&
                                                                                quantity !=
                                                                                    null) {
                                                                              // Call the edit function in products controller
                                                                              final updatedProduct =
                                                                                  Product(
                                                                                id: uid,
                                                                                name:
                                                                                    productName!,
                                                                                price:
                                                                                    productPrice,
                                                                                imageUrl:
                                                                                    imageUrl!,
                                                                                date: DateTime.now()
                                                                                    .toIso8601String(),
                                                                                quantity:
                                                                                    quantity!,
                                                                                description:
                                                                                    description!,
                                                                                index:
                                                                                    picker,
                                                                              );

                                                                              // Pass the correct index to the updateProduct function
                                                                              await products.updaterproduct(
                                                                                  updatedProduct,
                                                                                  products
                                                                                      .cartItems[index]
                                                                                      .id);

                                                                              // Close the dialog or navigate to the previous screen
                                                                              Navigator.pop(
                                                                                  context);
                                                                            } else {
                                                                              print(
                                                                                  "One or more variables are null");
                                                                            }
                                                                          },
                                                                          child: Text(
                                                                              'Edit'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(
                                                                                    context)
                                                                                .pop(); // Close the dialog
                                                                          },
                                                                          child: Text(
                                                                              'Cancel'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text('Edit'),
                                                            ),
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
                                                    );
                                                  },
                                                )
                                              : null;
                                        },
                                        child: Container(
                                          child: Card(
                                            child: SizedBox(
                                              height: 350,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: Get.width,
                                                    height: 80,
                                                    child: Image.network(
                                                      controller
                                                          .cartItems[index].imageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    controller.cartItems[index].name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .cartItems[index].description,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '\$${controller.cartItems[index].price.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      controller.cartItems[index]
                                                                  .quantity >
                                                              0
                                                          ? Text(
                                                              'Quantity: ${controller.cartItems[index].quantity.toString()}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            )
                                                          : Text(
                                                              'Sold Out',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .red, // You can customize the color
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          print(products.cartItems[index].id);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: widget.userData.status == "admin" ? Row(
                                                  children: [
                                                    Text('Product Details'),
                                                    Spacer(),
                                                     IconButton(
                                                      onPressed: () async {
                                                        print(widget.userData.resultId);

                                                        await products.removeFromCart(
                                                            widget.userData,
                                                            products.cartItems[index]);
                                                        setState(() {});
                                                        await cartController
                                                            .fetchUserCart(widget
                                                                .userData.resultId);
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ) : Text("Product Details"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Image.network(products
                                                          .cartItems[index].imageUrl),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'Product Name: ${products.cartItems[index].name}'),
                                                      Text(
                                                          'Product Description: ${products.cartItems[index].description}'),
                                                      Text(
                                                          'Price: \$${products.cartItems[index].price.toStringAsFixed(2)}'),
                                                      Text(
                                                          'Date: ${products.cartItems[index].date.toString()}'),
                                                      Text(
                                                          'Quantity: ${products.cartItems[index].quantity}'),

                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: [

                                                      Text('Select Quantity: '),


                                                      SizedBox(
                                                        width:
                                                        40, // Adjust the width as needed
                                                        child: Card(
                                                          child: Center(
                                                            child: TextFormField(cursorColor: Colors.red,style: TextStyle(color: Colors.red),
                                                              textAlign: TextAlign.center,
                                                              initialValue: products
                                                                  .selectedQuantity
                                                                  .toString(),
                                                              onChanged: (value) {
                                                                products.selectedQuantity =
                                                                    int.tryParse(value) ??
                                                                        1;
                                                              },
                                                              keyboardType:
                                                              TextInputType.number,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Spacer(),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Loading = true;

                                                          Loading
                                                              ? showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                      context) {
                                                                    return LoadingWidget();
                                                                  },
                                                                )
                                                              : null;
                                                          print(
                                                              'Quantity: ${products.cartItems[index].quantity}');

                                                          // Add 1 to the cart item's index (user pick)
                                                          products.cartItems[index]
                                                              .index += 1;
                                                          print(products
                                                              .cartItems[index].index);
                                                          // Update the product's quantity
                                                          // Call the update function in products controller
                                                           products.addToCartUser(
                                                              widget.userData,
                                                              products
                                                                  .cartItems[index]);
                                                          Loading = false;
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Add'),
                                                      ),
                                                      Spacer(),
                                                      widget.userData.status == "admin"
                                                          ? TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext
                                                                      context) {
                                                                    String? productName;
                                                                    double?
                                                                        productPrice;
                                                                    String? imageUrl;
                                                                    String? description;
                                                                    int? quantity;
                                                                    int uid;
                                                                    int picker;

                                                                    // Initialize the variables using the current product data
                                                                    final currentProduct =
                                                                        products.cartItems[
                                                                            index];
                                                                    uid = currentProduct
                                                                        .id;
                                                                    imageUrl =
                                                                        currentProduct
                                                                            .imageUrl;
                                                                    productName =
                                                                        currentProduct
                                                                            .name;
                                                                    productPrice =
                                                                        currentProduct
                                                                            .price;
                                                                    description =
                                                                        currentProduct
                                                                            .description;
                                                                    quantity =
                                                                        currentProduct
                                                                            .quantity;
                                                                    picker =
                                                                        currentProduct
                                                                            .index;

                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Edit Product'),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                          mainAxisSize:
                                                                              MainAxisSize
                                                                                  .max,
                                                                          children: [
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: imageUrl),
                                                                              onChanged:
                                                                                  (value) {
                                                                                imageUrl = products
                                                                                    .cartItems[index]
                                                                                    .imageUrl;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Image URL'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: productName),
                                                                              onChanged:
                                                                                  (value) {
                                                                                productName =
                                                                                    value;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Product Name'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: description),
                                                                              onChanged:
                                                                                  (value) {
                                                                                description =
                                                                                    value;
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Description'),
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: productPrice?.toStringAsFixed(2)),
                                                                              onChanged:
                                                                                  (value) {
                                                                                productPrice =
                                                                                    double.tryParse(value);
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Price'),
                                                                              keyboardType:
                                                                                  TextInputType
                                                                                      .number,
                                                                            ),
                                                                            TextField(
                                                                              controller:
                                                                                  TextEditingController(
                                                                                      text: quantity.toString()),
                                                                              onChanged:
                                                                                  (value) {
                                                                                quantity =
                                                                                    int.tryParse(value);
                                                                              },
                                                                              decoration:
                                                                                  InputDecoration(
                                                                                      labelText: 'Quantity'),
                                                                              keyboardType:
                                                                                  TextInputType
                                                                                      .number,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (productName != null &&
                                                                                imageUrl !=
                                                                                    null &&
                                                                                productPrice !=
                                                                                    null &&
                                                                                quantity !=
                                                                                    null) {
                                                                              // Call the edit function in products controller
                                                                              final updatedProduct =
                                                                                  Product(
                                                                                id: uid,
                                                                                name:
                                                                                    productName!,
                                                                                price:
                                                                                    productPrice,
                                                                                imageUrl:
                                                                                    imageUrl!,
                                                                                date: DateTime.now()
                                                                                    .toIso8601String(),
                                                                                quantity:
                                                                                    quantity!,
                                                                                description:
                                                                                    description!,
                                                                                index:
                                                                                    picker,
                                                                              );
                                                                              Loading =
                                                                                  true;
                                                                              Loading
                                                                                  ? showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return LoadingWidget();
                                                                                      },
                                                                                    )
                                                                                  : null;
                                                                              // Pass the correct index to the updateProduct function
                                                                              await products.updaterproduct(
                                                                                  updatedProduct,
                                                                                  products
                                                                                      .cartItems[index]
                                                                                      .id);
                                                                              Loading =
                                                                                  false;
                                                                              // Close the dialog or navigate to the previous screen
                                                                              Navigator.pop(
                                                                                  context);
                                                                              Navigator.pop(
                                                                                  context);
                                                                              Navigator.pop(
                                                                                  context);
                                                                            } else {
                                                                              print(
                                                                                  "One or more variables are null");
                                                                            }
                                                                          },
                                                                          child: Text(
                                                                              'Edit'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(
                                                                                    context)
                                                                                .pop(); // Close the dialog
                                                                          },
                                                                          child: Text(
                                                                              'Cancel'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text('Edit'),
                                                            )
                                                          : Text(''),
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
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          child: Card(
                                            child: SizedBox(
                                              height: 350,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: Get.width,
                                                    // Adjust the width as needed
                                                    height: 80,
                                                    // Adjust the height as needed (increased to 150)
                                                    child: Image.network(
                                                      controller
                                                          .cartItems[index].imageUrl,
                                                      fit: BoxFit
                                                          .cover, // Use BoxFit to control how the image fits within the constraints
                                                    ),
                                                  ),
                                                  Text(
                                                    controller.cartItems[index].name,
                                                    style: TextStyle(
                                                      fontSize:
                                                          16, // Adjust the font size as needed
                                                      fontWeight: FontWeight
                                                          .bold, // Adjust the font weight as needed
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .cartItems[index].description,
                                                        style: TextStyle(
                                                          fontSize:
                                                              16, // Adjust the font size as needed
                                                          fontWeight: FontWeight
                                                              .bold, // Adjust the font weight as needed
                                                        ),
                                                      ),
                                                      Text(
                                                        '\$${controller.cartItems[index].price.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              14, // Adjust the font size as needed
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   'Quantity: ${controller.cartItems[index].quantity.toString()}',
                                                      //   style: TextStyle(
                                                      //     fontSize:
                                                      //         14, // Adjust the font size as needed
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                          },
                        );
                      },
                    ),
                ],
              ),
        ),
      ],
    );
  }
}
