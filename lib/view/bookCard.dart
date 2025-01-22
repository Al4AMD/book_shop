import 'package:flutter/material.dart';
import 'package:libraryproject/models/book/bookModel.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: 210,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.white, blurRadius: 4, spreadRadius: 1),
              BoxShadow(
                  color: Colors.indigo.shade300,
                  blurRadius: 6,
                  spreadRadius: 0.3)
            ]),
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    'http://172.20.10.3:3000/api/v1/${book.cover?.path}',
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  book.publicationYear.toString(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  book.author,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
              height: 1,
              indent: 0,
              endIndent: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      '\$${book.price.floor().toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    )),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.indigo.shade500,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
