import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krystal_test_app/services/apis/end_points.dart';
import '../../model/blog_post_model.dart';
import '../../model/comments_model.dart';
import '../../view/utilities/colors.dart';
import '../../view/widgets/snack_bar.dart';

class BlogApis {
  Future<dynamic> getListOfBlogPost() async {
    try {
      http.Response response = await http.get(
        Uri.parse(EndPoints().getListOfBlogPostEndPoint),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return List<BlogPostModel>.from(
            result.map((x) => BlogPostModel.fromJson(x)));
      } else {
        throw 'Error loading data';
      }
    } catch (e) {
      throw 'Error loading data. Check your internet connection';
    }
  }

  Future<dynamic> getABlogComments(dynamic postId) async {
    try {
      http.Response response = await http.get(
        Uri.parse(EndPoints().getCommentsOfAPostEndPoint(postId)),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return List<CommentsModel>.from(
            result.map((x) => CommentsModel.fromJson(x)));
      } else {
        ShowSnackBar.showSnackBar(
          message: 'Error loading data',
          color: red,
        );
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(
        message: 'Error loading data. Check your internet connection',
        color: red,
      );
    }
  }

  Future<List<BlogPostModel>> searchBlogPost() async {
    List<BlogPostModel> post = [];
    try {
      http.Response response = await http.get(
        Uri.parse(EndPoints().getListOfBlogPostEndPoint),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);
        post = List<BlogPostModel>.from(
            result.map((x) => BlogPostModel.fromJson(x)));
        return post;
      } else {
        ShowSnackBar.showSnackBar(
          message: 'Error loading data',
          color: red,
        );
        return post;
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(
        message: 'Error loading data. Check your internet connection',
        color: red,
      );
      return post;
    }
  }
}
