import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isSelected;


  QuestionTile({
    required this.imageUrl,
    required this.name,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 3)
              : Border.all(color: Colors.transparent, width: 0),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [

            Positioned(
              left: 10,
              bottom: 10,
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

          ],
        ),

    );
  }
}