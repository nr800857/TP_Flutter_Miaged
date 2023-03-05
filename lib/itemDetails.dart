import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'article.dart';
import 'globals.dart' as globals;

class ItemDetailsPage extends StatefulWidget {
  final String id;

  const ItemDetailsPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<ItemDetailsPage> createState() => _ItemDetailsPageState(id);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  Article article = Article('', '', '', 0, '', '', '', '');
  List<Article> articles = [];
  String itemID = '';

  Future<Article> getArticle(String id) async {
    Article a = Article('', '', '', 0, '', '', '', '');
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    await items.doc(id).get().then((doc) {
      a = Article(
        doc['nom'],
        doc['marque'],
        doc['image'],
        doc['prix'],
        doc['taille'],
        doc["type"],
        id,
        doc["userID"]
      );
    });

    return a;
  }

  _ItemDetailsPageState(String id) {
    getArticle(id).then((val) => setState(() {
          article = val;
        }));
  }
  @override
  Widget build(BuildContext context) {
    final addCartButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 181, 224, 183),
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: () async {
          FirebaseFirestore.instance.collection('carts').doc(globals.cartID).update({"items": FieldValue.arrayUnion([article.id])});
          setState(() {
            globals.shoppingBag.add(article);
          });
          Navigator.pop(context);
        },
        child: const Text('Ajouter au panier'),
      ),
    );
    
    final removeCartButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 224, 181, 181),
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: () async {
          FirebaseFirestore.instance.collection('carts').doc(globals.cartID).update({"items": FieldValue.arrayRemove([article.id])});
          setState(() {
            globals.shoppingBag.removeWhere((item) => item.id == article.id);
          });
          Navigator.pop(context);
        },
        child: const Text('Retirer du panier'),
      ),
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
      body: ListView(
        children: [
          Image.network(
            article.image,
            height: 500,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0, top: 10.0),
            child : Text(
              article.nom,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0),
            child : Text(
              '${article.marque} - ${article.taille}',
              style: TextStyle(
                color: Colors.green[900],
                fontSize: 25,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0),
            child : Text(
              article.prix.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),)
          ),
          const SizedBox(height: 24.0),
          if (globals.shoppingBag.any((item) => item.id == article.id))
            removeCartButton
          else
            addCartButton,
        ],
      ),
    );
  }
}
