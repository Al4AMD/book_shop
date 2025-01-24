import 'package:flutter/material.dart';
import 'package:libraryproject/view/home.dart';
import 'package:libraryproject/view/profile.dart';
import 'package:provider/provider.dart';
import 'view/add.dart';
import 'view/favprovider.dart';
import 'view/fontprovider.dart';
import 'view/login.dart';
import 'view/mypurchases.dart';
import 'view/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FontProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        "/home": (context) => MyHomePage(),
        "/addBook": (context) => AddBook(),
        "/mypurchases": (context) => MyPurchases(purchasedBooks: []),
        "/login": (context) => LoginPage(
              // Ensure this is added
              onLogin: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
        "/profile": (context) => ProfilePage(),
        // "/history": (context) => CartHistory()
      },
    );
  }
}
