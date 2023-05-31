import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String name;
  final List<dynamic> category;

  CustomTile({
    required this.imageUrl,
    required this.price,
    required this.name,
    required this.category,
  });

  List<Icon> getIcons(List<String> iconNames) {
    return iconNames.map((iconName) {
      switch (iconName) {
        case 'fatigue':
          return Icon(Icons.bedtime, color: CupertinoColors.systemYellow,);
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Text(
                price,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)



                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 40,
              child: Row(
                children: getIcons(category.cast<String>()), // convert the dynamic list into a list of Strings
              ),
            ),
          ],
        ),
      ),
    );
  }
}