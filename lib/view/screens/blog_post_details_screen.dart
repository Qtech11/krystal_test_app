import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:krystal_test_app/view/utilities/colors.dart';
import 'package:krystal_test_app/view/utilities/styles.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/blog_post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/providers.dart';

class BlogPostDetail extends ConsumerStatefulWidget {
  final BlogPostModel post;
  final bool isBookmark;

  const BlogPostDetail({
    Key? key,
    required this.post,
    this.isBookmark = false,
  }) : super(key: key);

  @override
  ConsumerState<BlogPostDetail> createState() => _BlogPostDetailState();
}

class _BlogPostDetailState extends ConsumerState<BlogPostDetail> {
  Future<void> onRefresh() async {
    await ref.read(blogListProvider).getCommentsOfAPost(widget.post.id);
  }

  void _sharePost() {
    Share.share(
        'Title: ${widget.post.title}\n\n${widget.post.body} \n\nBy: User${widget.post.userId}');
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(blogListProvider).getCommentsOfAPost(widget.post.id);
      ref.read(bookmarkedPostProvider).doesPostExist(widget.post.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blogComments = ref.watch(blogListProvider).comments;
    bool isLoading = ref.watch(blogListProvider).loadingComments;
    double width = MediaQuery.of(context).size.width;
    bool existInBookMark = ref.watch(bookmarkedPostProvider).bookmarkStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        backgroundColor: blueGrey,
        actions: [
          widget.isBookmark
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    ref
                        .read(bookmarkedPostProvider)
                        .addAPostToBookMarks(widget.post);
                  },
                  icon: !existInBookMark
                      ? const Icon(Icons.star)
                      : const Icon(Icons.star_border),
                )
        ],
      ),
      body: RefreshIndicator(
        color: blueGrey,
        onRefresh: onRefresh,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: 20,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.title, style: titleStyle1),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.post.body,
                    style: textStyle1,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'By: User ${widget.post.userId!}',
                    style: textStyle1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: textStyle1,
                  ),
                  TextButton(
                    onPressed: _sharePost,
                    style: TextButton.styleFrom(backgroundColor: blueGrey),
                    child: const Text(
                      'Share',
                      style: buttonTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Comments ", style: titleStyle1),
                  isLoading
                      ? const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: blueGrey,
                            ),
                          ),
                        )
                      : blogComments != null
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: blogComments.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: blueGrey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: blueGrey.shade100)),
                                  padding: const EdgeInsets.all(6),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.01,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          "Email: ${blogComments[index].email}",
                                          style: titleStyle,
                                        ),
                                      ),
                                      Text(
                                        "Name: ${blogComments[index].name}",
                                        style: titleStyle,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        blogComments[index].body,
                                        style: textStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: Icon(
                                  Icons.error,
                                  size: 100,
                                  color: red.shade300,
                                ),
                              ),
                            ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
