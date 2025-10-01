import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cartProvider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping_cart/cart_db.dart';
import 'package:shopping_cart/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  dB_Helper db = dB_Helper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
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
            child: FutureBuilder<List<Cart>>(
              future: cart.getCartData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Image.network(
                                product.image.toString(),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 15),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name + Delete
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.productName.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            db.deleteItem(product.id!);
                                            cart.removeTotalPrice(
                                              product.productPrice!.toDouble(),
                                            );
                                            cart.removeItem();
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    // Price
                                    Text(
                                      "${product.unitTag}  \$${product.productPrice}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Add to Cart Button
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        child: Container(
                                          width: 120,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Colors.green,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Nothing in the shopping cart'),
                  );
                }
              },
            ),
          ),

          SizedBox(
            height: 60,
            child: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                      ? false
                      : true,
                  child: ReusableWidget(
                    title: 'Total Price',
                    price: value.getTotalPrice().toStringAsFixed(2),
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

class ReusableWidget extends StatelessWidget {
  final String title, price;

  const ReusableWidget({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              r'$' + price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
