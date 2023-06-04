import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';

import '../model/Product.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int simpleIntInput = 0;

  List<Icon> getIcons(List<String> iconNames) {
    return iconNames.map((iconName) {
      switch (iconName) {
        case 'fatigue':
          return const Icon(Icons.bedtime, color: CupertinoColors.systemYellow,);
        case 'performance':
          return Icon(Icons.directions_run, color: Colors.greenAccent,);
        case 'stress':
          return Icon(Icons.self_improvement, color: CupertinoColors.activeBlue,);
        case 'beaute':
          return Icon(Icons.face, color: CupertinoColors.systemRed,);
        case 'défense immunitaire':
          return Icon(Icons.shield, color: Colors.blueGrey,);
        case 'force':
          return Icon(Icons.fitness_center, color: Colors.orange,);
        default:
          return Icon(Icons.error_outline); // return a default icon if iconName doesn't match any case
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.network(widget.product.imageUrl, height: MediaQuery.of(context).size.height*0.5,),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: getIcons(widget.product.category.cast<String>()),
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Dosage recommandé:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                widget.product.dosageRecommande,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                softWrap: false,
              ),
              SizedBox(height: 16),
              Text(
                'Effets secondaires potentiels: ${widget.product.effetsSecondairesPotentiels}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Ingrédients: ${widget.product.ingredients.join(', ')}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Quantity:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              QuantityInput(
                value: simpleIntInput,
                onChanged: (value) => setState(() => simpleIntInput = int.parse(value.replaceAll(',', ''))),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Confirmation'),
    content: Text('Do you want to add $simpleIntInput of ${widget.product.name} to your shopping list?'),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
            final User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
            await FirebaseFirestore.instance
                .collection('userdata')
                .doc(user.uid)
                .update({
              'shoppingList': FieldValue.arrayUnion([{
                'productId': widget.product.id,
                'quantity': simpleIntInput
            }])
            });

            setState(() {
              simpleIntInput=0;
            });
            Navigator.of(context).pop();
            }
              }
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                // Handle when user presses the "No" button
                Navigator.of(context).pop();
              },
            )
          ],
        );
          },
      );
        },
          child: Icon(Icons.shopping_cart),
          tooltip: 'Order product',
        ),
    );
  }
}
