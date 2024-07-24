class BannerModel {
  final String title;
  final String imageUrl;

  BannerModel({required this.title, required this.imageUrl});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image_url': imageUrl,
    };
  }
}
