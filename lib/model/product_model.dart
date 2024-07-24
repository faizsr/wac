class ProductModel {
  final String sku;
  final String productName;
  final String productImage;
  final int productRating;
  final String actualPrice;
  final String offerPrice;
  final String discount;

  ProductModel({
    required this.sku,
    required this.productName,
    required this.productImage,
    required this.productRating,
    required this.actualPrice,
    required this.offerPrice,
    required this.discount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      sku: json['sku'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      productRating: json['product_rating'] ?? 0,
      actualPrice: json['actual_price'] ?? '',
      offerPrice: json['offer_price'] ?? '',
      discount: json['discount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'product_name': productName,
      'product_image': productImage,
      'product_rating': productRating,
      'actual_price': actualPrice,
      'offer_price': offerPrice,
      'discount': discount,
    };
  }
}
