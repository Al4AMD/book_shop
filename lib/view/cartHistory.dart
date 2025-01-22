// import 'package:flutter/material.dart';
// import 'package:libraryproject/apis/cartDetail_Api/cartDetailApis.dart';
// import 'package:libraryproject/models/book/bookModel.dart';
//
// class CartHistory extends StatefulWidget {
//   const CartHistory({super.key});
//
//   @override
//   State<CartHistory> createState() => _CartHistoryState();
// }
//
// class _CartHistoryState extends State<CartHistory> {
//   final api = CartDetailService();
//   List<int> cartIds = [];
//   Map<int, List<Book>> cartDetails = {};
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchHistory();
//   }
//
//   Future<void> fetchHistory() async {
//     cartIds = await api.getUserCarts();
//     for (var item in cartIds) {
//       final res = await api.getCartDetails(item);
//       cartDetails[item] = res;
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Purchase History",
//           style: TextStyle(
//               color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w800),
//         ),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               height: double.infinity,
//               width: double.infinity,
//               color: Colors.grey.shade200,
//               child: ListView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 children: [
//                   ListView.builder(
//                     itemCount: cartIds.length,
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Padding(padding: EdgeInsets.all(8),
//                       child: Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade300,
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: ListView.builder(
//                           itemCount: cartDetails.values.elementAt(index).length,
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index2) {
//                             return Padding(padding: EdgeInsets.all(6),
//                             child: ,
//                             );
//                           },
//                         )
//                       ),
//                       );
//                     }
//                   )
//                 ]
//               )),
//     );
//   }
// }
