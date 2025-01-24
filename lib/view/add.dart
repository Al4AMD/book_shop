import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libraryproject/view/home.dart';
import 'package:provider/provider.dart';

import './fontprovider.dart';
import './themeprovider.dart';
import 'httpservice.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final HttpService httpService = HttpService();
  final TextEditingController _serialNumber = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _publicationYear = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _cover; // Store the selected profile image path

  bool _nameError = false;
  bool _serialError = false;
  bool _descriptionError = false;
  bool _genreError = false;
  bool _publicationYear = false;
  bool _publisher = false;
  bool _authorError = false;
  bool _priceError = false;
  bool _isLoading = false;

    Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _cover =
            pickedFile.path; // Store the selected image file path
      });
      log("path: ${pickedFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    String selectedFont = context.watch<FontProvider>().selectedFont;

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
                    controller: _serialNumber,
                    hintText: 'Book Serial',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _nameError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _titleController,
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
                    controller: _descriptionController,
                    hintText: 'Description',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _authorError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _genreController,
                    hintText: 'Genre Name',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _authorError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _publicationYear,
                    hintText: 'Publication Year',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                    error: _authorError,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _publisherController,
                    hintText: 'Publisher',
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
      _nameError = _titleController.text.isEmpty;
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
