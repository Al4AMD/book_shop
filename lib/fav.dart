import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'httpservice.dart';
import 'mypurchases.dart';
import 'themeprovider.dart';
import 'fontprovider.dart';
import 'favprovider.dart';
import 'models.dart';

class Fav extends StatefulWidget {
  const Fav({Key? key}) : super(key: key);

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  final HttpService httpService = HttpService();
  final Map<int, int> _bookCounters = {}; // Map to store counters for each book
  List<Book> _favoriteBooks = []; // Store fetched books
  bool _isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    _fetchFavoriteBooks(); // Fetch books once on initialization
  }

  Future<void> _fetchFavoriteBooks() async {
    List<int> favoriteBookIds = context.read<FavoriteProvider>().favoriteBooks;

    try {
      final books = await httpService.fetchBooksByIds(favoriteBookIds);
      setState(() {
        _favoriteBooks = books;
        for (var book in books) {
          _bookCounters[book.id] ??= 1; // Initialize counters
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error, e.g., show a dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    Color backgroundColor =
        isDark ? const Color(0xFF062C65) : const Color(0xFFE7B4B4);
    Color cardBackgroundColor =
        isDark ? const Color(0xFF494747) : const Color(0xFFFFFFFF);

    Color textColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Favorite Books',
          style: TextStyle(
            fontFamily: selectedFont,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
              ? Center(
                  child: Text(
                    'No Favorites!',
                    style: TextStyle(
                      fontFamily: selectedFont,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 80), // Ensure space for button
                  itemCount: _favoriteBooks.length,
                  itemBuilder: (context, index) {
                    final currentBook = _favoriteBooks[index];
                    return Card(
                      color: cardBackgroundColor,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentBook.title,
                                    style: TextStyle(
                                      fontFamily: selectedFont,
                                      fontSize: 18,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    currentBook.author,
                                    style: TextStyle(
                                      fontFamily: selectedFont,
                                      fontSize: 16,
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_bookCounters[currentBook.id]! > 1) {
                                      setState(() {
                                        _bookCounters[currentBook.id] =
                                            _bookCounters[currentBook.id]! - 1;
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    child: Icon(
                                      Icons.remove,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  child: Text(
                                    _bookCounters[currentBook.id]!.toString(),
                                    style: TextStyle(
                                      fontFamily: selectedFont,
                                      fontSize: 16,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _bookCounters[currentBook.id] =
                                          _bookCounters[currentBook.id]! + 1;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    child: Icon(
                                      Icons.add,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                context
                                    .read<FavoriteProvider>()
                                    .removeFavorite(currentBook.id);
                                setState(() {
                                  _favoriteBooks.removeAt(index);
                                  _bookCounters.remove(currentBook.id);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyPurchases(purchasedBooks: _favoriteBooks),
            ),
          );
        },
        backgroundColor: isDark ? Colors.white : Colors.black,
        label: Text(
          'Confirm',
          style: TextStyle(
            fontFamily: selectedFont,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
