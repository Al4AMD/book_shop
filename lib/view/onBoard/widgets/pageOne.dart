import 'package:flutter/material.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'http://172.20.10.3:3000/api/v1/ui/nietchze.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 100,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16)),
              child: Text(
                'That which does not kill us makes us stronger.\n- Friedrich Nietzsche',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                maxLines: 6,
              ),
            ),
          )
        ],
      ),
    );
  }
}
