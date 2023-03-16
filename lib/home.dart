import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miaged/article.dart';
import 'package:miaged/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';
import 'profile.dart';
import 'shoppingbag.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  const HomePage({super.key}); 

@override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  String itemDetailsIndex = '';

  @override
  void initState() {
    super.initState();
    _chargerDonneesLocales();
  }

  void _chargerDonneesLocales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      globals.userID = prefs.getString('userID') ?? '';
      globals.cartID = prefs.getString('cartID') ?? '';
      String shoppingBagString = prefs.getString('shoppingBag') ?? '';
      if (shoppingBagString != '') {
        Iterable iterable = jsonDecode(shoppingBagString);
        globals.shoppingBag = List<Article>.from(iterable.map((x) => Article.fromJson(x)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
    const Item(),
    const ShoppingBag(),
    const Profile(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      child: pages[_selectedIndex],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('MIAGED'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Pannier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
    
  }
}