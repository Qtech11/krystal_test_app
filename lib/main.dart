import 'package:flutter/material.dart';
import 'package:krystal_test_app/services/database/local_database.dart';
import 'package:krystal_test_app/view/screens/home_screen.dart';
import 'package:krystal_test_app/view/widgets/snack_bar.dart';
import 'package:krystal_test_app/view_model/blog_list_provider.dart';
import 'package:krystal_test_app/view_model/bookmarked_post_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogListProvider>(
            create: (_) => BlogListProvider()),
        ChangeNotifierProvider<BookmarkedPostProvider>(
            create: (_) => BookmarkedPostProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        scaffoldMessengerKey: messengerKey,
      ),
    );
  }
}
