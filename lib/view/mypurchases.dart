import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './fontprovider.dart';
import './models.dart'; // Ensure this file includes the Book model
import './themeprovider.dart';

class MyPurchases extends StatelessWidget {
  final List<Book> purchasedBooks;

  const MyPurchases({Key? key, required this.purchasedBooks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    Color backgroundColor = isDark ? Color(0xFF1B3A4B) : Color(0xFFF5E8C7);
    Color cardBackgroundColor = isDark ? Color(0xFF294C60) : Color(0xFFFFFFFF);
    Color textColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);
    Color accentColor = isDark ? Color(0xFF76C7C0) : Color(0xFFB66D0D);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'My Purchases',
          style: TextStyle(
            fontFamily: selectedFont,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Greeting Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              purchasedBooks.isEmpty
                  ? 'You haven’t purchased any books yet!'
                  : 'Your Purchased Books',
              style: TextStyle(
                fontFamily: selectedFont,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Book List or Empty State
          purchasedBooks.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: accentColor,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Browse our collection and find your next favorite book!',
                          style: TextStyle(
                            fontFamily: selectedFont,
                            fontSize: 18,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to explore or shopping page
                            Navigator.pushNamed(context, "/home");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Explore Books',
                            style: TextStyle(
                              fontFamily: selectedFont,
                              fontSize: 16,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: purchasedBooks.length,
                    itemBuilder: (context, index) {
                      final book = purchasedBooks[index];
                      return Card(
                        color: cardBackgroundColor,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: accentColor,
                            child: Icon(
                              Icons.check_circle,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                          title: Text(
                            book.title,
                            style: TextStyle(
                              fontFamily: selectedFont,
                              fontSize: 18,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            book.author,
                            style: TextStyle(
                              fontFamily: selectedFont,
                              fontSize: 16,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          trailing: Icon(
                            Icons.bookmark_added,
                            color: accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
