import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String imageUrl;
  final double price;
  final String name;
  final List<dynamic> category;
  final String dosageRecommande;
  final String effetsSecondairesPotentiels;
  final List<dynamic> ingredients;
  final String id;

  Product({
    required this.imageUrl,
    required this.price,
    required this.name,
    required this.category,
    required this.dosageRecommande,
    required this.effetsSecondairesPotentiels,
    required this.ingredients,
    required this.id,
  });

  // Factory constructor to create a Product instance from a DocumentSnapshot
  factory Product.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // convert the data to Map
    return Product(
      imageUrl: data.containsKey('image_url') ? data['image_url'] : "",
      price: data.containsKey('price') ? data['price'] : 0.0,
      name: data.containsKey('nom') ? data['nom'] : "",
      category: data.containsKey('categories') ? List<dynamic>.from(data['categories']) : [],
      dosageRecommande: data.containsKey('dosage_recommandé') ? data['dosage_recommandé'] : "",
      effetsSecondairesPotentiels: data.containsKey('effets_secondaires_potentiels') ? data['effets_secondaires_potentiels'] : "",
      ingredients: data.containsKey('ingrédients') ? List<dynamic>.from(data['ingrédients']) : [],
      id: doc.id,
    );
  }
}

class ProductShopping{
  final Product product;
  final int quantity;

  ProductShopping(this.product, this.quantity);

}

class ProductData{
  final String productid;
  final int quantity;

  ProductData(this.productid, this.quantity);

}