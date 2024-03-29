import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_test_app/view/utilities/colors.dart';
import 'package:krystal_test_app/view/utilities/styles.dart';
import '../../services/apis/blog_apis.dart';
import 'blog_post_details_screen.dart';
import 'blog_search_delegate.dart';

FutureProvider futureListProvider =
    FutureProvider((ref) => BlogApis().getListOfBlogPost());

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(futureListProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueGrey,
        title: const Text('Blog Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BlogPostSearchDelegate());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SideDrawer(width: width),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ref.read(futureListProvider);
          build(context, ref);
        },
        color: Colors.blueGrey,
        child: future.when(
          data: (blogPosts) => ListView.builder(
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
                        builder: (context) =>
                            BlogPostDetail(post: blogPosts[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          error: (e, stack) => ListView(
            children: [
              SizedBox(
                height: height - 100,
                child: Center(
                  child: Column(
                    children: [
                      Text('$e'),
                      Icon(
                        Icons.error,
                        size: 80,
                        color: red.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: blueGrey.shade300,
              radius: 60,
              child: const Icon(
                Icons.person_outline_rounded,
                color: white,
                size: 80,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const BookmarkedBlogPostScreen(),
                //   ),
                // );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: blueGrey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: blueGrey.shade100),
                ),
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Bookmarks"),
                    Icon(Icons.star),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
