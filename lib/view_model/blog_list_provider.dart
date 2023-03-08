import 'package:flutter/material.dart';
import 'package:krystal_test_app/model/blog_post_model.dart';
import '../model/comments_model.dart';
import '../services/apis/blog_apis.dart';

class BlogListProvider extends ChangeNotifier {
  List<BlogPostModel>? post;
  List<CommentsModel>? comments;
  bool isLoading = false;
  bool loadingComments = false;

  //To get the list of blog post from the api and and update the UI simultaneously
  Future<void> updateList() async {
    isLoading = true;
    List<BlogPostModel>? list = await BlogApis().getListOfBlogPost();
    if (list != null) {
      post = list;
    }
    isLoading = false;
    notifyListeners();
  }

  //To get the list of comments from the api and and update the UI simultaneously
  Future<void> getCommentsOfAPost(postId) async {
    comments = null;
    loadingComments = true;
    notifyListeners();
    List<CommentsModel>? list = await BlogApis().getABlogComments(postId);
    if (list != null) {
      comments = list;
    }
    loadingComments = false;
    notifyListeners();
  }
}
