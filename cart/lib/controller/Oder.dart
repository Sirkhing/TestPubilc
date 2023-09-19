import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/oder.dart';
class Odercontrolle extends GetxController {
  var oder = <odermodel>[].obs;
  List<int> selectedIndices = [];
  List<odermodel> odernotdonelist = [];
  List<int> allorder = [

  ];
  var urll = 'https://typescript-staging.agsdev.workers.dev/Temp';
  // final dummyOrders = List.generate(
  //   5,
  //       (index) => odermodel(
  //     id: index + 1,
  //     status: index == 0 ? 'Not Done' : 'Done',
  //     shoppingCart: [],
  //     user: , date: DateTime.now().toIso8601String()
  //
  //   ),
  // );
  Future<List<odermodel>?> fetchProducts() async {
    final response = await http.post(Uri.parse('$urll/order'));

    try {
      if (response.statusCode == 200) {
        // If the server returned a 200 OK response,
        // then parse the JSON.
        final dynamic responseData = json.decode(response.body);

        if (responseData != null) {
          print(responseData);
          print(responseData.containsKey('result'));
          print(responseData['result']);

          if (responseData.containsKey('result')) {
            final dynamic resultData = responseData['result'];

            if (resultData is List) {
              final List<dynamic> productDataList = resultData;
              List<odermodel> products = [];
print("===============-----------------");
              for (int i = 0; i < productDataList.length; i++) {
                print("===============-----------------");
                dynamic productData = productDataList[i];
                print("===============-----------------");
                odermodel product = odermodel.fromJson(productData);
                print("===============-----------------");
                products.add(product);
              }

              odernotdonelist.assignAll(products);
print(odernotdonelist);
              return products;
            } else {
              // Handle the case where 'result' key contains a map instead of a list.
              print("Invalid response format. 'result' is not a list.");
              return null;
            }
          } else {
            // Handle the case where 'result' key is not found in the response.
            print("No products found");
            return null;
          }
        } else {
          // Handle the case where response body is null.
          print("Response body is null");
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

}