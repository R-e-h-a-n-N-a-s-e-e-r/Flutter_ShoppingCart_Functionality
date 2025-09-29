class Cart {
  final int? id;
  final String? productId;
  final String? productName;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  Cart({
    this.id,
    this.productId,
    this.productName,
    this.productPrice,
    this.quantity,
    this.unitTag,
    this.image,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
    : id = res['id'],
      productId = res['productId'],
      productName = res['productName'],
      productPrice = res['productPrice'],
      quantity = res['quantity'],
      unitTag = res['unitTag'],
      image = res['image'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
  }
}
