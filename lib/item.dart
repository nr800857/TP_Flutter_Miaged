import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/itemDetails.dart';
import 'article.dart';
import 'globals.dart' as globals;

class Item extends StatefulWidget {
  const Item({super.key});
  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> with TickerProviderStateMixin {
  List<Article> articles = [];
  List<Article> articlesCopy = [];
  List<Tab> tabs = [
    const Tab(text: "Tous"),
    const Tab(text: "Hauts & t-shirts"),
    const Tab(text: "Sweats & pulls"),
    const Tab(text: "Pantalons"),
    const Tab(text: "Robes"),
    const Tab(text: "Accessoires"),
    const Tab(text: "Chaussures"),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  Future<List<Article>> getArticles() async {
    List<Article> a = [];
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    await items.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          a.add(Article(doc["nom"], doc["marque"], doc["image"], doc["prix"],
              doc["taille"], doc["type"], doc.reference.id, doc["userID"]));
        }
      }
    });
    return a;
  }

  _ItemState() {
    getArticles().then((val) => setState(() {
          articles = val.where((element) => element.userID != globals.userID).toList();
          articlesCopy = articles;
        }));
  }

  void _FilterItems(int index) {
    setState(() {
      switch (index) {
        case 0:
          articles = articlesCopy;
          break;
        case 1:
          articles = articlesCopy
              .where((element) =>
                  element.type == "T-shirt" ||
                  element.type == "Hauts" ||
                  element.type == "Chemises")
              .toList();
          break;
        case 2:
          articles = articlesCopy
              .where((element) =>
                  element.type == "Sweat" ||
                  element.type == "Pull" ||
                  element.type == "Veste")
              .toList();
          break;
        case 3:
          articles = articlesCopy
              .where((element) =>
                  element.type == "Pantalon" ||
                  element.type == "Short" ||
                  element.type == "Jean")
              .toList();
          break;
        case 4:
          articles = articlesCopy
              .where(
                  (element) => element.type == "Robe" || element.type == "Jupe")
              .toList();
          break;
        case 5:
          articles = articlesCopy
              .where((element) => element.type == "Accessoire")
              .toList();
          break;
        case 6:
          articles = articlesCopy
              .where((element) =>
                  element.type == "Chaussures" ||
                  element.type == "Bottes" ||
                  element.type == "Baskets")
              .toList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (articles.isEmpty) {
      body = const Center(
        child: Text(
         "Aucun article disponible",
        style: TextStyle(fontSize: 20),
        )
      );
    } else {
      body = GridView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailsPage(
                    id: articles[index].id,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    articles[index].image,
                    height: 275,
                    width: 223,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(articles[index].nom,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Text(articles[index].marque),
                Text('Taille ${articles[index].taille}'),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 223 / 350),
        padding: const EdgeInsets.all(10),
        shrinkWrap: false,
      );
    }
    return Scaffold(
      appBar: TabBar(
        onTap: _FilterItems,
        controller: _tabController,
        isScrollable: true,
        tabs: tabs,
      ),
      body: body,
    );
  }
}
