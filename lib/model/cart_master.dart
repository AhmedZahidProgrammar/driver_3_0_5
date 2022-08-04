import 'dart:convert';

CartMaster cartMasterFromMap(String str) => CartMaster.fromMap(json.decode(str));

String cartMasterToMap(CartMaster data) => json.encode(data.toMap());

class CartMaster {
  CartMaster({
    required this.vendorId,
    required this.cart,
  });

  int vendorId;
  List<Cart> cart;

  factory CartMaster.fromMap(Map<String, dynamic> json) => CartMaster(
    vendorId: json["vendor_id"],
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "vendor_id": vendorId,
    "cart": List<dynamic>.from(cart.map((x) => x.toMap())),
  };
}

class Cart {
  Cart({
    required this.category,
    required this.menu,
    required this.size,
    required this.totalAmount,
    required this.quantity,
    this.menuCategory
  });
  String category;
  List<Menu> menu;
  Size? size;
  MenuCategory? menuCategory;
  double totalAmount;
  int quantity;
  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    category: json["category"],
    totalAmount: json["total_amount"],
    menu: List<Menu>.from(json["menu"].map((x) => Menu.fromMap(x))),
    size: json["size"] == null ? null : Size.fromMap(json["size"]),
    menuCategory: json["menu_category"] == null ? null : MenuCategory.fromMap(json["menu_category"]),
    quantity: json['quantity']
  );

  Map<String, dynamic> toMap() => {
    "category": category,
    "total_amount": totalAmount,
    "menu": List<dynamic>.from(menu.map((x) => x.toMap())),
    "size": size == null ? null : size!.toMap(),
    "menu_category":menuCategory == null ?null:menuCategory!.toMap(),
    'quantity':quantity,
  };
}

class Menu {
  Menu({
    required this.id,
    required this.name,
    required this.image,
    required this.totalAmount,
    required this.addons,
    this.dealsItems

  });

  int id;
  String name;
  String image;
  double totalAmount;
  List<Addon> addons;
  DealsItems? dealsItems;

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name:json['name'],
    image:json['image'],
    totalAmount: json['total_amount'],
    addons: List<Addon>.from(json["addons"].map((x) => Addon.fromMap(x))),
    dealsItems: json["deals_items"] == null ? null : DealsItems.fromMap(json["deals_items"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name":name,
    "image":image,
    "total_amount":totalAmount,
    "addons": List<dynamic>.from(addons.map((x) => x.toMap())),
    "deals_items":dealsItems == null ?null:dealsItems!.toMap(),
  };
}
class DealsItems {
DealsItems({
  required this.name,
  required this.id,
});

final String name;
final int id;

factory DealsItems.fromMap(Map<String, dynamic> json) => DealsItems(
name: json["name"],
id: json["id"],
);

Map<String, dynamic> toMap() => {
  "name": name,
  "id": id,
};
}

class Addon {
  Addon({
    required this.id,
    required this.name,
    required this.price,
  });

  int id;
  String name;
  double price;

  factory Addon.fromMap(Map<String, dynamic> json) => Addon(
    id: json["id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name ,
    "price":price,
  };
}

class Size {
  Size({
    required this.id,
    required this.sizeName,
  });

  int id;
  String sizeName;

  factory Size.fromMap(Map<String, dynamic> json) => Size(
    id: json["id"],
    sizeName: json["size_name"] == null ? null : json["size_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "size_name": sizeName,
  };
}
class MenuCategory {
  MenuCategory({
    required this.name,
    required this.image,
    required this.id,
  });

  String name;
  String image;
  int id;

  factory MenuCategory.fromMap(Map<String, dynamic> json) => MenuCategory(
    name: json["name"],
    image: json["image"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "image": image,
    "id": id,
  };
}

