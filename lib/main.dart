import 'package:flutter/material.dart';
import 'package:libraryproject/profile.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'editbook.dart';
import 'fav.dart';
import 'httpservice.dart';
import 'mypurchases.dart';
import 'themeprovider.dart';
import 'fontprovider.dart';
import 'detail.dart';
import 'add.dart';
import 'favprovider.dart';
import 'models.dart';
import 'login.dart';

void main() {
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeProvider>().themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        onLogin: () {
          Navigator.pushReplacementNamed(context, "/home");
        },
      ),
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
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HttpService httpService = HttpService();
  List<Book> shoppingitems = [];
  List<Book> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Book> items = await httpService.fetchItems();
      setState(() {
        shoppingitems = items;
        filteredItems = shoppingitems;
      });
    } catch (error) {
      debugPrint('Error fetching items: $error');
      setState(() {
        filteredItems = [];
      });
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = query.isEmpty
          ? shoppingitems
          : shoppingitems
              .where((item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.author.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    Color backgroundColor = isDark ? Color(0xFF062C65) : Color(0xFFE7B4B4);
    Color cardBackgroundColor = isDark ? Color(0xFF494747) : Color(0xFFFFFFFF);
    Color textColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Books List',
          style: TextStyle(
            fontFamily: selectedFont,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
                context, '/profile'), // Navigate to profile page
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/default_profile.png'), // Placeholder image
                radius: 20,
                backgroundColor:
                    Colors.grey, // Background color if image is null
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_rounded, color: textColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Fav()),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: cardBackgroundColor,
              ),
              onChanged: filterItems,
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'No Data!',
                      style: TextStyle(
                        fontFamily: selectedFont,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final currentBook = filteredItems[index];
                      return Card(
                        color: cardBackgroundColor,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          title: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Circular image behind the title
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                    'assets/default_profile.png'), // Replace with actual image
                                backgroundColor: Colors.grey[200],
                              ),
                              Positioned(
                                left: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentBook.title,
                                      style: TextStyle(
                                        fontFamily: selectedFont,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      currentBook.author,
                                      style: TextStyle(
                                        fontFamily: selectedFont,
                                        fontSize: 14,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  context
                                          .watch<FavoriteProvider>()
                                          .isFavorite(currentBook.id)
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  color: textColor,
                                ),
                                onPressed: () {
                                  bool isFav = context
                                      .read<FavoriteProvider>()
                                      .isFavorite(currentBook.id);
                                  if (isFav) {
                                    context
                                        .read<FavoriteProvider>()
                                        .removeFavorite(currentBook.id);
                                  } else {
                                    context
                                        .read<FavoriteProvider>()
                                        .addFavorite(currentBook.id);
                                  }
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: textColor),
                                onPressed: () async {
                                  var updatedData = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditBookScreen(book: currentBook),
                                    ),
                                  ).then((updatedBook) {
                                    if (updatedBook != null) {
                                      // Handle the updated book
                                    }
                                  });

                                  if (updatedData != null) {
                                    await httpService.updateBook(
                                      currentBook.id,
                                      updatedData,
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: textColor),
                                onPressed: () async {
                                  await httpService.deleteBook(currentBook.id);
                                  setState(() {
                                    shoppingitems.removeAt(index);
                                    filterItems(searchController.text);
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(book: currentBook),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/addBook"),
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
        backgroundColor: isDark ? Color(0xFFFFFFFF) : Color(0xFF000000),
      ),
    );
  }
}
