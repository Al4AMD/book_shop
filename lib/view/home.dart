import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:libraryproject/apis/book_Api/bookApis.dart';
import 'package:libraryproject/apis/cart_Api/cartApis.dart';
import 'package:libraryproject/view/bookCard.dart';
import 'package:libraryproject/view/cart.dart';

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
  List<String> genres = [];
  Map<String, List<Book>> booksByGenre = {};
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
    genres = books.map((book) => book.genre).toSet().toList();
    booksByGenre = {
      for (var genre in genres)
        genre: books.where((book) => book.genre == genre).toList(),
    };
    log("book by genre: ${booksByGenre} ${booksByGenre.length}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20)),
              Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/profile'),
                      icon: Icon(Icons.person)),
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
                      Image.network(
                        'http://172.20.10.3:3000/api/v1/ui/empty.png',
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'All Books',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 450,
                        child: ListView.builder(
                            itemCount: books.length,
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: false,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 12, top: 6, bottom: 6, right: 12),
                                child: GestureDetector(
                                    onTap: () => setState(() {
                                          if (!cart.contains(books[index])) {
                                            cart.add(books[index]);
                                          }
                                        }),
                                    child: BookCard(book: books[index])),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          itemCount: booksByGenre.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      booksByGenre.keys.elementAt(index),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 450,
                                  child: ListView.builder(
                                      itemCount: booksByGenre.values
                                          .elementAt(index)
                                          .length,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: false,
                                      itemBuilder: (context, index2) {
                                        final book = booksByGenre.values
                                            .elementAt(index)[index2];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              top: 6,
                                              bottom: 6,
                                              right: 12),
                                          child: GestureDetector(
                                              onTap: () => setState(() {
                                                    if (!cart.contains(book)) {
                                                      cart.add(book);
                                                    }
                                                  }),
                                              child: BookCard(book: book)),
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }),
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
                                        'http://172.20.10.3:3000/api/v1/${cart[index].cover!.path}'),
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
