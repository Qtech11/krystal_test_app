import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krystal_test_app/services/database/local_database.dart';
import 'package:krystal_test_app/view/screens/home_screen.dart';
import 'package:krystal_test_app/view/widgets/snack_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDB();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      scaffoldMessengerKey: messengerKey,
    );
  }
}

// ChangeNotifierProvider<BlogListProvider>(
// create: (_) => BlogListProvider()),
// ChangeNotifierProvider<BookmarkedPostProvider>(
// create: (_) => BookmarkedPostProvider()),
