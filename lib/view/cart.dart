import 'package:flutter/material.dart';
import 'package:libraryproject/models/book/bookModel.dart';

import '../apis/cartDetail_Api/cartDetailApis.dart';

class CartPage extends StatefulWidget {
  final int cartId;
  final List<Book> cartBooks;

  const CartPage({super.key, required this.cartBooks, required this.cartId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 1;
  late Map<int, int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = {
      for (int i = 0; i < widget.cartBooks.length; i++) i: 1,
    };
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    totalPrice = 0;
    for (int i = 0; i < widget.cartBooks.length; i++) {
      totalPrice += widget.cartBooks[i].price * quantities[i]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade100,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ListView(
              children: [
                ListView.builder(
                  itemCount: widget.cartBooks.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final book = widget.cartBooks[index];
                    return Container(
                      width: double.infinity,
                      height: 140,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  'http://172.20.10.3:3000/api/v1/${book.cover!.path}',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${book.title}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    book.author,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    book.publicationYear.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Price: \$${book.price.floor().toString()}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantities[index] =
                                          (quantities[index]! + 1);
                                      _updateTotalPrice();
                                    });
                                  },
                                  icon: Icon(Icons.add)),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(14)),
                                child: Center(
                                  child: Text(quantities[index].toString()),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (quantities[index]! > 1) {
                                        quantities[index] =
                                            (quantities[index]! - 1);
                                      }
                                      _updateTotalPrice();
                                    });
                                  },
                                  icon: Icon(Icons.minimize)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 0.1,
                            blurRadius: 8)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$${totalPrice.floor().toString()}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    List<int> bookIds =
                        await CartDetailService().getBookIds(widget.cartBooks);
                    final quantity = quantities.values.toList();
                    final response = await CartDetailService()
                        .createCartDetail(bookIds, widget.cartId, quantity);
                    _showDialog(
                        context: context,
                        message: response,
                        res: response == "Success" ? true : false);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.indigo, Colors.blue]),
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(
                      child: Text(
                        'Buy',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
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
    if (res)
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      });
  }
}
