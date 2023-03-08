import 'package:flutter/material.dart';
import 'package:krystal_test_app/view/widgets/snack_bar.dart';

import '../model/blog_post_model.dart';
import '../services/database/local_database.dart';
import '../view/utilities/colors.dart';

class BookmarkedPostProvider extends ChangeNotifier {
  List<BlogPostModel> postList = [];
  DateTime date = DateTime.now();
  bool bookmarkStatus = false;

  // To check if a post is in bookmarks, then add it to bookmarks if it's not and do otherwise if it is in it already
  // Also displays a snack bar appropriately based on the instance
  Future<void> addAPostToBookMarks(BlogPostModel post) async {
    if (await doesPostExist(post.id)) {
      await DatabaseHelper.insert(post);
      ShowSnackBar.showSnackBar(
          message: 'Post has been added to bookmarks', color: blueGrey);
      doesPostExist(post.id);
    } else {
      ShowSnackBar.showSnackBar(
          message: 'Post already in bookmarks', color: red);
    }
  }

  // To get the list of all blogpost in bookmarks
  Future<void> getListOfPost() async {
    postList = [];
    List<Map<String, dynamic>> posts = await DatabaseHelper.query();
    postList.addAll(posts.map((data) => BlogPostModel.fromJson(data)).toList());
    notifyListeners();
  }

  // To check if a post exist in bookmarks
  Future<bool> doesPostExist(id) async {
    bool exist = await DatabaseHelper.doesPostExist(id);
    bookmarkStatus = exist;
    notifyListeners();
    return exist;
  }

  // delete post from bookmarks
  Future<void> deletePost(id) async {
    await DatabaseHelper.delete(id);
    getListOfPost();
  }
}
