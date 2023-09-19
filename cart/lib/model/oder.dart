import 'package:cart/model/shopingcart.dart';
import 'package:cart/model/user.dart';

class odermodel {
  int id;
  String status;
  String date;
  List<shopingcart>? shoppingCart;
  List<Result>? user;

  odermodel({
    required this.id,
    required this.status,
    required this.date,
    required this.shoppingCart,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'date': date,
      'product': shoppingCart?.map((shopingcart) => shopingcart.toJson()).toList(),
      'user': user?.map((Result) => Result.toJson()).toList(),
    };
  }

  factory odermodel.fromJson(Map<String, dynamic> json) {
    List<shopingcart>? shoppingCart;
    List<Result>? user;

    if (json['product'] != null) {
      if (json['product'] is List<dynamic>) {
        shoppingCart = (json['product'] as List<dynamic>)
            .map((item) => shopingcart.fromJson(item))
            .toList();
      } else if (json['product'] is Map<String, dynamic>) {
        shoppingCart = [
          shopingcart.fromJson(json['product'] as Map<String, dynamic>)
        ];
      }
    }

    if (json['user'] != null) {
      if (json['user'] is List<dynamic>) {
        user = (json['user'] as List<dynamic>)
            .map((item) => Result.fromJson(item))
            .toList();
      } else if (json['user'] is Map<String, dynamic>) {
        user = [Result.fromJson(json['user'] as Map<String, dynamic>)];
      }
    }

    return odermodel(
      id: json['id'] ?? 0,
      status: json['status'] ?? " ",
      date: json['date'] ?? " ",
      shoppingCart: shoppingCart,
      user: user,
    );
  }
}