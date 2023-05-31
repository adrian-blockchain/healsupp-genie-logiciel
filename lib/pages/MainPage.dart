import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/PersonalPage.dart';
import 'MarketplacePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;
    final List<Widget> _pages = <Widget>[
      PersonalPage(),
      MarketplacePage(),
      ShoppingListPage(),

    ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: 'Profil',

          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: 'Shopping list',

          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}



class ShoppingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('Shopping List Page');
  }
}

