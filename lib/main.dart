import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/google_books_api.dart';

// Entry point of the Flutter application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Providing dependencies to the widget tree using MultiProvider
      providers: [
        // Registering GoogleBooksApi as a ChangeNotifier for state management
        ChangeNotifierProvider(create: (_) => GoogleBooksApi()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EBook reader Application',
        // Sets the HomeScreen as the initial screen
        home: const HomeScreen(),
      ),
    );
  }
}
