import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:krystal_test_app/view/utilities/colors.dart';
import 'package:krystal_test_app/view/utilities/styles.dart';
import 'package:provider/provider.dart';
import '../../model/blog_post_model.dart';
import '../../view_model/bookmarked_post_provider.dart';
import 'blog_post_details_screen.dart';

class BookmarkedBlogPostScreen extends StatefulWidget {
  const BookmarkedBlogPostScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkedBlogPostScreen> createState() =>
      _BookmarkedBlogPostScreenState();
}

class _BookmarkedBlogPostScreenState extends State<BookmarkedBlogPostScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkedPostProvider>().getListOfPost();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BlogPostModel> blogPosts =
        context.watch<BookmarkedPostProvider>().postList;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueGrey,
        title: const Text("Bookmarks"),
      ),
      body: blogPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 120,
                    color: blueGrey.shade100,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "You have no post in your Bookmarks",
                    style: textStyle1.copyWith(color: blueGrey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: blogPosts.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: blueGrey.shade100),
                  ),
                  padding: const EdgeInsets.all(3),
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "Title: ${blogPosts[index].title}",
                        style: titleStyle,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By: User ${blogPosts[index].userId}',
                          style: textStyle,
                        ),
                        Text(
                          'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: textStyle,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogPostDetail(
                            post: blogPosts[index],
                            isBookmark: true,
                          ),
                        ),
                      );
                    },
                    onLongPress: () async {
                      bool shouldDelete = false;
                      await showDialog(
                        context: context,
                        barrierDismissible:
                            false, // dialog is dismissible with a tap on the barrier
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirmation',
                              style: titleStyle,
                            ),
                            content: const Text(
                              'Are you sure you want remove this post from bookmarks?',
                              style: textStyle1,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'No',
                                  style: textStyle1,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Yes',
                                  style: textStyle1,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  shouldDelete = true;
                                },
                              ),
                            ],
                          );
                        },
                      ).whenComplete(() => shouldDelete
                          ? context
                              .read<BookmarkedPostProvider>()
                              .deletePost(blogPosts[index].id)
                          : null);
                    },
                  ),
                );
              },
            ),
    );
  }
}
