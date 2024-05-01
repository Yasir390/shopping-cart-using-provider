import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String> productImg = [
    'https://media.istockphoto.com/id/2025551509/photo/isolated-lychee-whole-half-and-piece-of-lychee-fruits-with-leaves-isolated-on-white.jpg?s=612x612&w=0&k=20&c=JJQTwkJdLwJ8lpz1q9U2kVlRSLid0InTEi-5qkpCf3c=',
    'https://media.istockphoto.com/id/1211330834/photo/jackfruit-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=jXRd8OOM6OlGdnTxx36Hz9JI0YZ_7V30YugLdGPhdrw=',
    'https://media.istockphoto.com/id/1435602408/photo/close-up-red-mango-fruits.jpg?s=612x612&w=0&k=20&c=TUPbAzolmum0R7REDWa6rWywk0wtJC3bjj1wT8kso3I=',
    'https://media.istockphoto.com/id/1291262112/photo/banana.jpg?s=612x612&w=0&k=20&c=Na8FBcsTuhCRyuWLmbCV1FwOkvWLWFeVfQT-pd6tXk8=',
    'https://media.istockphoto.com/id/1295773461/photo/purple-grape-isolated-on-white-background-clipping-path-full-depth-of-field.jpg?s=612x612&w=0&k=20&c=ilhy5x66lzKX7ki2Hsz9ZTUEDBt3ilL_9ELD3zSPmZk=',
    'https://media.istockphoto.com/id/1439436349/photo/red-apple-isolated-on-white-background-clipping-path-full-depth-of-field.jpg?s=2048x2048&w=is&k=20&c=h0FIN48XtILU6rloPxzPFgoxJ3_LOgj3TrVo9g4cC8k=',
    'https://media.istockphoto.com/id/185284489/photo/orange.jpg?s=612x612&w=0&k=20&c=m4EXknC74i2aYWCbjxbzZ6EtRaJkdSJNtekh4m1PspE='
  ];
  List<String> productName = [
    'Lychee',
    'Jackfruit',
    'Mango',
    'Banana',
    'Grapes',
    'Apple',
    'Orange'
  ];
  List<String> productUnit = [
    '100 Pieces',
    '1 Piece',
    'Kg',
    'Dozen',
    'Kg',
    'Kg',
    'Kg'
  ];
  List<String> productPrice = ['300', '250', '170', '120', '430', '310', '350'];

  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => const CartScreen(),));
            },
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              badgeStyle: const badges.BadgeStyle(
                  shape: badges.BadgeShape.circle, badgeColor: Colors.black),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
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
                                image: NetworkImage(productImg[index])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName[index]),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(productUnit[index] +
                                    ': ' +
                                    productPrice[index] +
                                    ' tk'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            dbHelper!.insert(CartModel(
                              id: index,
                              productId: index.toString(),
                              productName: productName[index].toString(),
                              initialPrice: int.parse(productPrice[index]),
                              productPrice: int.parse(productPrice[index]),
                              quantity: 1,
                              unitTag: productUnit[index].toString(),
                              image: productImg[index].toString(),
                            ))
                                .then((value) {
                              provider.addTotalPrice(
                                  double.parse(productPrice[index]));
                              provider.addCounter();
                              print('product is added to cart');
                            }).onError((error, stackTrace) {
                              print(error.toString());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
