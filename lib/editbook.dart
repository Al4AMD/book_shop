import 'package:flutter/material.dart';
import 'httpservice.dart';
import 'models.dart';
import 'package:provider/provider.dart';
import 'fontprovider.dart';
import 'themeprovider.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  const EditBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _priceController;

  HttpService _httpService = HttpService();

  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _priceController = TextEditingController(text: widget.book.price);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedBookDetails = {
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'price': _priceController.text.trim(),
        'id': widget.book.id,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        await _httpService.updateBook(widget.book.id, updatedBookDetails);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book updated successfully!')),
        );

        // Navigate to the main page after saving changes
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update book: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
          'Edit Book',
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
                    controller: _titleController,
                    hintText: 'Book Title',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _authorController,
                    hintText: 'Author Name',
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _priceController,
                    hintText: 'Price',
                    keyboardType: TextInputType.number,
                    backgroundColor: textFieldBackgroundColor,
                    hintTextColor: hintTextColor,
                  ),
                  const SizedBox(height: 25),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _updateBook,
                              child: Text(
                                'Save Changes',
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
      ],
    );
  }
}
