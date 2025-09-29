import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cartProvider.dart';
import 'package:shopping_cart/cart_db.dart';
import 'package:shopping_cart/cart_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  dB_Helper? dbHelper = dB_Helper();
  List<String> productName = [
    'Mango',
    'Apple',
    'Orange',
    'Banana',
    'Grapes',
    'Kiwi',
  ];
  List<String> productUnit = ['kg', 'kg', 'kg', 'Dozen', 'kg', 'kg'];

  List<int> productPrice = [10, 20, 30, 40, 50, 60];
  List<String> images = [
    'https://images.unsplash.com/photo-1553279768-865429fa0078?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Mango
    'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YXBwbGV8ZW58MHx8MHx8fDA%3D',
    // Apple
    'https://media.istockphoto.com/id/2124102567/photo/orange-fruit-with-leaf.webp?a=1&b=1&s=612x612&w=0&k=20&c=YUa-SHN1YnyS7wYTx33M59e-FJUUmiFNcWMNO2o4ats=',
    // Orange
    'https://plus.unsplash.com/premium_photo-1724250081102-cab0e5cb314c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YmFuYW5hfGVufDB8fDB8fHww',
    // Banana
    'https://images.unsplash.com/photo-1578829779691-99b60bd8c7be?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGdyYXBlc3xlbnwwfHwwfHx8MA%3D%3D',
    // Grapes
    'https://images.unsplash.com/photo-1585059895524-72359e06133a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8a2l3aXxlbnwwfHwwfHx8MA%3D%3D',
    // Kiwi
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        actions: [
          badges.Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getItemCount().toString(),
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.green),
            badgeAnimation: badges.BadgeAnimation.slide(
              animationDuration: Duration(milliseconds: 400),
            ),
            child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: NetworkImage(images[index].toString()),
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    productUnit[index] +
                                        " " +
                                        r"$" +
                                        productPrice[index].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  dbHelper
                                      ?.insert(
                                        Cart(
                                          productId: index.toString(),
                                          productName: productName[index],
                                          productPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag: productUnit[index],
                                          image: images[index],
                                        ),
                                      )
                                      .then((value) {
                                        cart.setTotalPrice(
                                          double.parse(
                                            productPrice[index].toString(),
                                          ),
                                        );
                                        cart.addItem();
                                      })
                                      .onError((error, stackTrace) {
                                        print(error.toString());
                                      });
                                },
                                child: Container(
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
