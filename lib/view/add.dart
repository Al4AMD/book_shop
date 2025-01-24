import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libraryproject/apis/book_Api/bookApis.dart';
import 'package:libraryproject/models/book/bookModel.dart';
import 'package:libraryproject/services/utils/utilApis.dart';
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
  bool _publicationYearError = false;
  bool _publisher = false;
  bool _authorError = false;
  bool _priceError = false;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _cover = pickedFile.path; // Store the selected image file path
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                    GestureDetector(
                      onTap: _pickImage, // Open gallery when tapped
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _cover != null
                            ? FileImage(
                                File(_cover!)) // Use the picked image
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                        child: _cover == null
                            ? Icon(Icons.camera_alt, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
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
    final id = await UtilsService.getUserId();
    Book book = Book(
      userId: id,
      serialNumber: _serialNumber.value.text.trim(),
      title: _titleController.value.text.trim(),
      cover: File(_cover!),
      description: _descriptionController.value.text.trim(),
      author: _authorController.value.text.trim(),
      genre: _genreController.value.text.trim(),
      publisher: _publisherController.value.text.trim(),
      price: double.parse(_priceController.value.text.trim()),
      publicationYear: int.parse(_publicationYear.value.text.trim()),
    );
    BookService api = BookService();
    final res = await api.createBook(book: book);
    _showDialog(
        context: context,
        message: res,
        res: res == "Success" ? true : false);
  }

  void _showDialog(
      {required BuildContext context,
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    });
  }
}
