import 'package:flutter/material.dart';

import '../../model/blog_post_model.dart';
import '../../services/apis/blog_apis.dart';
import '../utilities/colors.dart';
import 'blog_post_details_screen.dart';

class BlogPostSearchDelegate extends SearchDelegate<List<BlogPostModel>> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, []);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<BlogPostModel>>(
      future: searchBlogPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BlogPostModel> suggestions = snapshot.data!
              .where((post) =>
                  post.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: blueGrey.shade100)),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(suggestions[index].title),
                  subtitle: Text('By: User ${suggestions[index].userId}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BlogPostDetail(post: suggestions[index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
