import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/CarsCustom.dart';
import '../components/ProductPage.dart';
import '../model/Product.dart';








class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  Future<List<Product>> _fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    return querySnapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Use a progress indicator for better UX
          }

          final products = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(product: product),
                    ),
                  );
                },
                child: CustomTile(
                  imageUrl: product.imageUrl,
                  price: '\$${product.price}',
                  name: product.name,
                  category: product.category,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

