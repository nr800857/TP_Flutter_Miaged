import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemDetails.dart';

class ShoppingBag extends StatefulWidget {
  const ShoppingBag({super.key});

  @override
  State<ShoppingBag> createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  
  double getTotal() {
    double total = 0;
    for (var i = 0; i < globals.shoppingBag.length; i++) {
      total += globals.shoppingBag[i].prix;
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    var nbItems = Text("Pannier(${globals.shoppingBag.length})",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

    var cart = ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: globals.shoppingBag.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
              height: 110,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsPage(
                          id: globals.shoppingBag[index].id,
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child: Card(
                      elevation: 10.0,
                      child: ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: 4),
                          leading: Image.network(
                            globals.shoppingBag[index].image,
                            height: 100,
                            width: 75,
                            fit: BoxFit.cover,
                          ),
                          title: Text(globals.shoppingBag[index].nom),
                          subtitle: Text(globals.shoppingBag[index].marque),
                          trailing: Column(children: [
                            Text("${globals.shoppingBag[index].prix}€"),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('carts')
                                    .doc(globals.cartID)
                                    .update({
                                  "items": FieldValue.arrayRemove(
                                      [globals.shoppingBag[index].id])
                                });
                                setState(() async {
                                  globals.shoppingBag.removeAt(index);
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("shoppingBag", jsonEncode(
                                        globals.shoppingBag.map((x) => x.toJson()).toList()));
                                    
                                });
                              },
                            )
                          ])))));
        });

    const empty = Center(
      child: Text(
        "Votre panier est vide",
        style: TextStyle(
          color: Color.fromARGB(255, 118, 118, 118),
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    Widget total = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "${getTotal()}€",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );

    if (globals.shoppingBag.isNotEmpty) {
      return Column(
        children: [
          nbItems,
          Expanded(
            child: cart,
          ),
          total,
        ],
      );
    } else {
      return empty;
    }
  }
}
