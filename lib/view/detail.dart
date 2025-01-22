import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './fontprovider.dart'; // Import your font provider
import './models.dart'; // Import your book model
import './themeprovider.dart'; // Import your theme provider

class Detail extends StatelessWidget {
  final Book book;

  const Detail({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve theme and font settings
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    // Define colors based on theme
    Color backgroundColor = isDark ? Color(0xFF062C65) : Color(0xFFE7B4B4);
    Color cardBackgroundColor = isDark ? Color(0xFFC0C0C0) : Color(0xFFFFFFFF);
    Color textColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);
    Color buttonBackgroundColor =
        isDark ? Color(0xFF062C65) : Color(0xFFE7B4B4);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          book.title,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: cardBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                      "Title", book.title, selectedFont, Colors.black),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                      "Author", book.author, selectedFont, Colors.black),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                      "Price", book.price, selectedFont, Colors.black),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontFamily: selectedFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, String fontFamily, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 18,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
