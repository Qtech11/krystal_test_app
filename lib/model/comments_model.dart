import 'dart:convert';

class CommentsModel {
  CommentsModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  int postId;
  int id;
  String name;
  String email;
  String body;

  factory CommentsModel.fromRawJson(String str) => CommentsModel.fromJson(json.decode(str));

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
    postId: json["postId"],
    id: json["id"],
    name: json["name"],
    email: json["email"],
    body: json["body"],
  );
}
