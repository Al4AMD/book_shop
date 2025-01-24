import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:libraryproject/apis/book_Api/bookApis.dart';
import 'package:libraryproject/apis/cart_Api/cartApis.dart';
import 'package:libraryproject/services/utils/utilApis.dart';
import 'package:libraryproject/view/bookCard.dart';
import 'package:libraryproject/view/cart.dart';
import 'package:libraryproject/view/themeprovider.dart';
import 'package:provider/provider.dart';

import '../models/book/bookModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BookService api = BookService();
  final CartService cartApi = CartService();
  List<Book> books = [];
  List<Book> myBooks = [];
  bool isLoading = true;
  List<Book> cart = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final allBooks = await api.getAllBooks();
    for (var item in allBooks) {
      books.add(item);
    }
    final id = await UtilsService.getUserId();
    final userBooks = await api.getUserBooks(id);
    for (var item in userBooks) {
      myBooks.add(item);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('BookStore',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20)),
              Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/profile'),
                      icon: Icon(Icons.person)),
                  IconButton(
                    onPressed: () =>
                        context.read<ThemeProvider>().changeTheme(),
                    icon: Icon(isDark ? Icons.sunny : Icons.dark_mode),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/addBook'),
                    icon: Icon(Icons.add),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 10, right: 10, left: 10, bottom: 0),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'All Books',
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: (books.length / 2)
                            .ceil(), // Ensure we handle an odd number of books
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int firstBookIndex = index *
                              2; // Get the index of the first book in the row
                          int secondBookIndex = firstBookIndex +
                              1; // Get the index of the second book in the row

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First BookCard
                                GestureDetector(
                                  onTap: () => setState(() {
                                    if (!cart.contains(books[firstBookIndex])) {
                                      cart.add(books[firstBookIndex]);
                                    }
                                  }),
                                  child: BookCard(book: books[firstBookIndex]),
                                ),

                                // Second BookCard (if it exists)
                                if (secondBookIndex < books.length)
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      if (!cart
                                          .contains(books[secondBookIndex])) {
                                        cart.add(books[secondBookIndex]);
                                      }
                                    }),
                                    child:
                                        BookCard(book: books[secondBookIndex]),
                                  )
                                else
                                  // Empty Spacer if there's no second book
                                  const Spacer(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'My Books',
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: (myBooks.length / 2)
                            .ceil(), // Ensure we handle an odd number of books
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int firstBookIndex = index *
                              2; // Get the index of the first book in the row
                          int secondBookIndex = firstBookIndex +
                              1; // Get the index of the second book in the row

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First BookCard
                                GestureDetector(
                                  onTap: () => setState(() {
                                    if (!cart
                                        .contains(myBooks[firstBookIndex])) {
                                      cart.add(myBooks[firstBookIndex]);
                                    }
                                  }),
                                  child:
                                      BookCard(book: myBooks[firstBookIndex]),
                                ),

                                // Second BookCard (if it exists)
                                if (secondBookIndex < myBooks.length)
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      if (!cart
                                          .contains(myBooks[secondBookIndex])) {
                                        cart.add(myBooks[secondBookIndex]);
                                      }
                                    }),
                                    child: BookCard(
                                        book: myBooks[secondBookIndex]),
                                  )
                                else
                                  // Empty Spacer if there's no second book
                                  const Spacer(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (cart.isNotEmpty)
                        const SizedBox(
                          height: 150,
                        )
                    ],
                  ),
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListView.builder(
                            itemCount: cart.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(6),
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    cart.removeAt(index);
                                  }),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                        'http://192.168.1.36:3000/api/v1/${cart[index].cover!.path}'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final res = await cartApi.createCard();
                            _showDialog(
                                context: context,
                                message: res['message'],
                                id: res['data']['id'],
                                res: res['result'] == "success" ? true : false);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.indigo, Colors.blue]),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
    );
  }

  void _showDialog(
      {required BuildContext context,
      required int id,
      required String message,
      required bool res}) {
    showDialog(
      context: context,
      barrierDismissible: true, // Prevents closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: res ? Colors.green : Colors.red),
                  child: Center(
                    child: Icon(
                      res ? Icons.verified : Icons.error,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(message,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        );
      },
    );
    if (res)
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CartPage(cartBooks: cart, cartId: id)));
      });
  }
}
