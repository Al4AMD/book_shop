class Book {
  final String title;
  final String author;
  final String price;

  //final String image;
  final int id;
  bool isInCart;

  Book({
    required this.title,
    required this.author,
    required this.price,
    // required this.image,
    required this.id,
    this.isInCart = false,
  });

  factory Book.fromJson(dynamic map) {
    Book book = Book(
      title: map['title'] as String,
      author: map['author'] as String,
      price: map['price'] as String,
      // image: map['image'] as String,
      id: map['id'] as int,
    );
    return book;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'price': price,
        // 'image': image,
        'id': id,
      };
}
