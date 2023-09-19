
  import 'package:get/get.dart';
  import 'package:cart/model/shopingcart.dart';

  class MemberRegistration {
    int status;
    Result result;

    MemberRegistration({
      required this.status,
      required this.result,
    });

    factory MemberRegistration.fromJson(Map<String, dynamic> json) => MemberRegistration(
      status: json["status"] ?? "",
      result: Result.fromJson(json["result"] ?? [""]),
    );

    Map<String, dynamic> toJson() => {
      "status": status,
      "result": result.toJson(),
    };

  }
  class Result extends GetxController {
    String id;
    String resultId;
    String username;
    String password;
    String name;
    String lastName;
    String phone;
    String status;
    List<shopingcart> shoppingCart;

    Result({
      required this.id,
      required this.resultId,
      required this.username,
      required this.password,
      required this.name,
      required this.lastName,
      required this.phone,
      required this.status,
      required this.shoppingCart,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["_id"] ?? "",
      resultId: json["id"] ?? "",
      username: json["username"] ?? "",
      password: json["password"] ?? "",
      name: json["name"] ??  "",
      lastName: json["lastName"] ?? "",
      phone: json["phone"] ?? "",
      status: json["status"] ?? "user",

      // shoppingCart: List<shopingcart>.from(json["shoppingCart"].map((x) => x) ?? <shopingcart>[]),
      shoppingCart: json["shoppingCart"] != null
          ? List<shopingcart>.from(json["shoppingCart"].map((x) => shopingcart.fromJson(x)))
          : <shopingcart>[],
    );

    Map<String, dynamic> toJson() => {
      "_id": id,
      "id": resultId,
      "username": username,
      "password": password,
      "name": name,
      "lastName": lastName,
      "phone": phone,
      "status": status,
      "shoppingCart": List<dynamic>.from(shoppingCart.map((x) => x)),
    };
  }
