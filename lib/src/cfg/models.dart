class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String pathImage;

  Product(this.id, this.name, this.description, this.price, this.pathImage);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'pathImage': pathImage,
    };
  }
}

class CartItem {
  final int id;
  final String name;
  final int price;
  int quantity;
  final String pathImage;

  CartItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.pathImage});

  get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'pathImage': pathImage,
    };
  }
}

class Stock {
  final int id;
  final String name;
  final String description;
  int quantity;
  final String pathImage;

  Stock(this.id, this.name, this.description, this.quantity, this.pathImage);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'pathImage': pathImage,
    };
  }
}
