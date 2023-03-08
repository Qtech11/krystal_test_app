class BlogPostModel {
  dynamic id;
  dynamic userId;
  String title;
  String body;

  BlogPostModel({
    this.id,
    this.userId,
    required this.title,
    required this.body,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? "",
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
