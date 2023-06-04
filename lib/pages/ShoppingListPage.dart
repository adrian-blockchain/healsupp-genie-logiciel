import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Product.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
  }

  void confirmAndPlaceOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Place Order'),
          content: Text('Do you want to place your order?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // Delete shopping list from Firestore
                await FirebaseFirestore.instance.collection('userdata').doc(user.uid).update({
                  'shoppingList': FieldValue.delete(),
                });
                Navigator.of(context).pop();
                // Update the UI to reflect the changes in the shopping list
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }


  Future<List<ProductData>> getShoppingList() async {
    List<ProductData> shoppingList = [];
    final doc = await FirebaseFirestore.instance.collection('userdata').doc(user.uid).get();
    if (doc.exists) {
      shoppingList = List<Map<String, dynamic>>.from(doc['shoppingList']).map((item) =>
          ProductData(
              item['productId'],
              item['quantity']
          )
      ).toList();
    } else {
      print('Document does not exist on the database');
    }
    return shoppingList;
  }

  Future<Product> getProductData(String productId) async {
    final doc = await FirebaseFirestore.instance.collection('products').doc(productId).get();
    return doc.exists ? Product.fromDocument(doc) : throw 'Product does not exist on the database';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: FutureBuilder<List<ProductData>>(
        future: getShoppingList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("No pills to shop"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final productData = snapshot.data![index];
                return FutureBuilder<Product>(
                  future: getProductData(productData.productid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("No pills to shop"),
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      final product = snapshot.data!;
                      return ListTile(
                        leading: Image.network(product.imageUrl),
                        title: Text(product.name),
                        subtitle: Text('Unit Price: \$${product.price}\nQuantity: ${productData.quantity}'),
                        trailing: Text('Price : \$${product.price* productData.quantity}'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          confirmAndPlaceOrder();
        },
        child: Icon(Icons.shopping_cart),
        tooltip: 'Order All',
      ),
    );
  }
}
