class shopingcart {
   int id;

   String name;
   double price;
   String imageUrl;
   String date;
String description;
   int count;

  shopingcart({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.date,
required this.description,
    required this.count,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'date': date,
      'count': count,
      'description':description,

    };
  }


  // Create a shopingcart object from a JSON map
  factory shopingcart.fromJson(Map<String, dynamic> json) {
    return shopingcart(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: (json["price"] is num) ? json["price"].toDouble() : 0.0,
      imageUrl: json['imageUrl'] ?? "",
      date: json["date"] ?? "",
      count: json['count'] ?? 0,
        description: json['description'] ?? " "
    );
  }


}
