import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healsupp/components/CategoryQuestionPage.dart';
import 'package:healsupp/main.dart';
import 'package:healsupp/pages/home.dart';

import '../model/Questions.dart';
import 'QuestionTile.dart';

final List<Question> questions = [
  Question(
    imageUrl:
    'https://www.vousnousils.fr/wp-content/uploads/2014/06/sportif-haut-niveau.jpg',
    category: 'Sportif',
  ),
  Question(
    imageUrl:
    'https://www.mutualia.fr/sites/default/files/uploads/RTEmagicC_AdobeStock_83229260.jpeg',
    category: 'Senior',
  ),
  Question(
    imageUrl:
    'https://custom-images.strikinglycdn.com/res/hrscywv4p/image/upload/c_limit,fl_lossy,h_9000,w_1200,f_auto,q_auto/3445694/754239_305270.png',
    category: 'Vegan',
  ),
  Question(
    imageUrl:
    'https://images.rtl.fr/~c/770v513/rtl/www/1469997-une-personne-atteinte-d-obesite-illustration.jpg',
    category: 'Sur poids',
  ),
  Question(
    imageUrl:
    'https://ds.static.rtbf.be/article/image/1248x702/d/5/1/a5c0676caf6b0984df1384fcf7ac9e21-1496925506.jpg',
    category: 'Immunité faible',
  ),
  Question(
    imageUrl:
    'https://media.dogfinance.com/files/articles/jeunes-actifs-placer-votre-argent_b.jpg',
    category: 'Actif',
  ),
];

class PreferenceQuestionPage extends StatefulWidget {
  const PreferenceQuestionPage({Key? key}) : super(key: key);

  @override
  State<PreferenceQuestionPage> createState() => _PreferenceQuestionPageState();
}

class _PreferenceQuestionPageState extends State<PreferenceQuestionPage> {
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
        .update({'activity': _selectedCategories.toList()});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu es pluôt '),
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
              MaterialPageRoute(builder: (context) =>  CategoryQuestionPage()),
                  (route) => false);
        },
        child: Icon(Icons.done),
      ),
    );
  }

}



