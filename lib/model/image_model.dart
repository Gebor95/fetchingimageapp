class ImageData {
  final String myTitle, myUrl;

  ImageData({required this.myTitle, required this.myUrl});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(myTitle: json["title"], myUrl: json["url"]);
  }
}
