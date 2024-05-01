import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/db_helper.dart';

import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: provider.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image(
                                      height: 65,
                                      width: 65,
                                      image: NetworkImage(snapshot
                                          .data![index].image
                                          .toString())),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data![index].productName
                                          .toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(snapshot.data![index].unitTag
                                          .toString() +
                                          ': ' +
                                          snapshot.data![index].productPrice
                                              .toString() +
                                          ' tk'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    dbHelper.deleteItem(snapshot.data![index].id!);
                                    provider.removeCounter();
                                    provider.removeTotalPrice(double.parse(
                                        snapshot.data![index].productPrice
                                            .toString()));
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                Card(
                                  color: Colors.red[200],
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          int quantity = snapshot.data![index]
                                              .quantity!;
                                          int price = snapshot.data![index]
                                              .initialPrice!;
                                          quantity--;
                                          int? newPrice = quantity * price;
                                          if(quantity >= 1){

                                          dbHelper.updateQuantity(CartModel(
                                            id: snapshot.data![index].id,
                                            productId: snapshot.data![index].id.toString(),
                                            productName: snapshot.data![index].productName,
                                            initialPrice: snapshot.data![index].initialPrice,
                                            productPrice: newPrice,
                                            quantity: quantity,
                                            unitTag: snapshot.data![index].unitTag.toString(),
                                            image: snapshot.data![index].image.toString(),
                                          )).then((value) {
                                            newPrice = 0;
                                            quantity = 0;
                                            provider.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        }},
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(snapshot.data![index].quantity
                                          .toString()),
                                      IconButton(
                                        onPressed: () {
                                          int quantity = snapshot.data![index]
                                              .quantity!;
                                          int price = snapshot.data![index]
                                              .initialPrice!;
                                          quantity++;
                                          int? newPrice = quantity * price;

                                          dbHelper.updateQuantity(CartModel(
                                            id: snapshot.data![index].id,
                                            productId: snapshot.data![index].id.toString(),
                                            productName: snapshot.data![index].productName,
                                            initialPrice: snapshot.data![index].initialPrice,
                                            productPrice: newPrice,
                                            quantity: quantity,
                                            unitTag: snapshot.data![index].unitTag.toString(),
                                            image: snapshot.data![index].image.toString(),
                                          )).then((value) {
                                            newPrice = 0;
                                            quantity = 0;
                                            provider.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Visibility(
                  visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                      ? false
                      : true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sub Total '),
                        Text('\$' + value.getTotalPrice().toStringAsFixed(2))
                      ],
                    ),
                  ));
            },
          )
        ],
      ),
    );
  }
}
