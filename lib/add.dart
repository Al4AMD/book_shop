import 'package:flutter/material.dart';
import 'package:libraryproject/main.dart';
import 'package:provider/provider.dart';
import 'httpservice.dart';
import 'fontprovider.dart';
import 'themeprovider.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final HttpService httpService = HttpService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _nameError = false;
  bool _authorError = false;
  bool _priceError = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme mode (light or dark)
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

    // Define color values based on theme
    Color backgroundColor = isDark ? Color(0xFF062C65) : Color(0xFFE7B4B4);
    Color textFieldBackgroundColor =
        isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5);
    Color cardBackgroundColor = isDark ? Color(0xFFC0C0C0) : Color(0xFFFFFFFF);
    Color buttonBackgroundColor =
        isDark ? Color(0xFF062C65) : Color(0xFFE7B4B4);
    Color textColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);
    Color hintTextColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF000000);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Add New Book',
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
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Book Name',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _nameError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _authorController,
                    hintText: 'Author Name',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _authorError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _priceController,
                    hintText: 'Price',
                    keyboardType: TextInputType.number,
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _priceError,
                  ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _addBook,
                              child: Text(
                                'Add Book',
                                style: TextStyle(
                                  fontFamily: selectedFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonBackgroundColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required Color backgroundColor,
    required Color hintTextColor,
    required bool error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(color: hintTextColor),
              hintText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
        ),
        if (error)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'This field is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _addBook() async {
    setState(() {
      _nameError = _nameController.text.isEmpty;
      _authorError = _authorController.text.isEmpty;
      _priceError = _priceController.text.isEmpty;
    });

    if (!_nameError && !_authorError && !_priceError) {
      final bookDetails = {
        'title': _nameController.text.trim(),
        'author': _authorController.text.trim(),
        'price': _priceController.text.trim(),
      };

      setState(() => _isLoading = true);

      try {
        await httpService.createBook(bookDetails);
        // Navigator.pop(context, true); // Indicate book was added successfully
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MyHomePage()),
            (Route<dynamic> route) => false);
      } catch (error) {
        setState(() => _isLoading = false);
        _showErrorDialog('Failed to add book: $error');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
