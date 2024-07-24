class SingleBannerModel {
  final String imageUrl;
  final String title;

  SingleBannerModel({required this.imageUrl,required this.title});

  factory SingleBannerModel.fromJson(Map<String, dynamic> json) {
    return SingleBannerModel(
      title: json['title'],
      imageUrl: json['image_url'] ?? json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title':title,
      'image_url': imageUrl,
    };
  }
}
