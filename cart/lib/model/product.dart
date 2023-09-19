  class ProductRegistration {
    int status;
    List<Product> result; // Change result to be a list of products

    ProductRegistration({
      required this.status,
      required this.result,
    });

    factory ProductRegistration.fromJson(Map<String, dynamic> json) {
      return ProductRegistration(
        status: json["status"],
        result: List<Product>.from(json["result"].map((x) => Product.fromJson(x))),
      );
    }

    Map<String, dynamic> toJson() => {
      "status": status,
      "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
  }

  class Product {
    int id;
    String name;
    String description;
    dynamic price;
    String imageUrl;
    String date;
    int quantity;
    int index; // count of get for - quantity (Stock)

    Product({
      required this.id, // Make sure 'id' is required and not nullable
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.date,
      required this.quantity,
      required this.index,
    });

    factory Product.fromJson(Map<String, dynamic> json) {
      return Product(
        id: json["id"] ?? 0, // Provide a default value (0 in this case) if 'id' is missing or null
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        price: (json["price"] is num) ? json["price"].toDouble() : 0.0,
        imageUrl: json["imageUrl"] ?? "",
        date: json["date"] ?? "",
        quantity: json["quantity"] ?? 0,
        index: json["index"] ?? 0,
      );
    }
    void updateCountWithQuantity(int count) {
      quantity += count;
    }

    Map<String, dynamic> toJson() => {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
      "date": date,
      "quantity": quantity,
      "index": index,
    };
  }



