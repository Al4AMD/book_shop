import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  // Store the list of favorite book IDs
  List<int> _favoriteBooks = [];

  // Getter for favoriteBooks
  List<int> get favoriteBooks => _favoriteBooks;

  // Check if a book is in favorites
  bool isFavorite(int bookId) {
    return _favoriteBooks.contains(bookId);
  }

  // Add a book to favorites
  void addFavorite(int bookId) {
    if (!_favoriteBooks.contains(bookId)) {
      _favoriteBooks.add(bookId);
      notifyListeners(); // Notify listeners for UI updates
    }
  }

  // Remove a book from favorites
  void removeFavorite(int bookId) {
    if (_favoriteBooks.contains(bookId)) {
      _favoriteBooks.remove(bookId);
      notifyListeners(); // Notify listeners for UI updates
    }
  }
}
