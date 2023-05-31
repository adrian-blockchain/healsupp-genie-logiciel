import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healsupp/components/PreferenceQuestionPage.dart';
import 'package:healsupp/components/QuestionTile.dart';
import 'package:healsupp/pages/MainPage.dart';

import '../model/Questions.dart';

final List<Question> questions = [
  Question(
    imageUrl:
    'https://cdn1.costatic.com/assets/img/guide_achat/articles/lutter-contre-la-fatigue_1120x740px.jpg',
    category: 'fatigue',
  ),
  Question(
    imageUrl:
    'https://f.hubspotusercontent20.net/hubfs/3967272/Définition-performance-commerciale.jpg',
    category: 'performance',
  ),
  Question(
    imageUrl:
    'https://cdn.futura-sciences.com/sources/images/shutterstock_377904673.jpg',
    category: 'stress',
  ),
  Question(
    imageUrl:
    'https://media.istockphoto.com/id/1074037262/fr/photo/couple-de-beauté.jpg?s=612x612&w=0&k=20&c=3fT9QgNKFxK8ASNm1l9ixcBPu1rx4YaMnHzeZVe_XGQ=',
    category: 'beaute',
  ),
  Question(
    imageUrl:
    'https://www.plantes-et-sante.fr/images/defenses-immunitaires.jpg',
    category: 'défense immunitaires',
  ),
  Question(
    imageUrl:
    'https://test.psychologies.com/var/tests/storage/images/6/9/5/0/10596-3-fre-FR/quelle-est-votre-force-interieure-iStock-614012698.png',
    category: 'force',
  ),
];

class CategoryQuestionPage extends StatefulWidget {
  const CategoryQuestionPage({Key? key}) : super(key: key);

  @override
  State<CategoryQuestionPage> createState() => _CategoryQuestionPageState();
}

class _CategoryQuestionPageState extends State<CategoryQuestionPage> {
  final Set<String> _selectedCategories = Set<String>();

  void handleQuestionTap(Question question) {
    setState(() {
      if (_selectedCategories.contains(question.category)) {
        _selectedCategories.remove(question.category);
      } else {
        _selectedCategories.add(question.category);
      }
    });
  }


  Future<void> updateFavoriteQuestions() async {
    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'favorite': _selectedCategories.toList()});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Que souhaitez vous améliorer ?'),
      ),
      body:GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        itemCount: questions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final question = questions[index];
          return InkWell(
            onTap: () {
              handleQuestionTap(question);
            },
            child: QuestionTile(
              imageUrl: question.imageUrl,
              name: question.category,
              isSelected: _selectedCategories.contains(question.category),
            ),
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await updateFavoriteQuestions();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  MainPage()),
                  (route) => false);
        },
        child: Icon(Icons.done),
      ),
    );
  }

}



