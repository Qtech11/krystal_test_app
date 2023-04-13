import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_test_app/view_model/blog_list_provider.dart';
import 'package:krystal_test_app/view_model/bookmarked_post_provider.dart';

final blogListProvider = ChangeNotifierProvider((ref) => BlogListProvider());
final bookmarkedPostProvider =
    ChangeNotifierProvider((ref) => BookmarkedPostProvider());
