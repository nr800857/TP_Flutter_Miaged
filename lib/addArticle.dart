import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});
  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  bool showError = false;

  String dropdownvalue = 'T-shirt';
  var items = [
    'T-shirt',
    'Hauts',
    'Chemises',
    'Sweat',
    'Pull',
    'Veste',
    'Pantalon',
    'Short',
    'Jean',
    'Robe',
    'Jupe',
    'Accessoire',
    'Chaussures',
    'Bottes',
    'Baskets',
  ];

  @override
  Widget build(BuildContext context) {
    final nomController = TextEditingController();
    final marqueController = TextEditingController();
    final prixController = TextEditingController();
    final tailleController = TextEditingController();

    final nom = TextFormField(
      controller: nomController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nom',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final marque = TextFormField(
      autofocus: false,
      controller: marqueController,
      decoration: InputDecoration(
        hintText: 'Marque',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final prix = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: prixController,
      decoration: InputDecoration(
        hintText: 'Prix',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final taille = TextFormField(
      controller: tailleController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Taille',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final type = DropdownButtonFormField(
      isExpanded: true,
      value: dropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        dropdownvalue = newValue!;
        
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: 'Type',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final validateButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
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
          if (nomController.text.isEmpty ||
              marqueController.text.isEmpty ||
              prixController.text.isEmpty ||
              tailleController.text.isEmpty) {
            setState(() {
              showError = true;
            });
          } else {
            await FirebaseFirestore.instance.collection('items').add({
              'nom': nomController.text,
              'marque': marqueController.text,
              'prix': double.parse(prixController.text),
              'taille': tailleController.text,
              'type': dropdownvalue,
              'image':
                  "https://img01.ztat.net/article/spp-media-p1/7245f51f17d3451a99b26a7a7978177f/68680456af3b460991d1bc81dbbf9da7.jpg?imwidth=1800&filter=packshot&imquality=high",
              'userID': globals.userID,
            });
            Navigator.pop(context);
          }
        },
        child: const Text('Valider'),
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
            )),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            const SizedBox(height: 25.0),
            const Text('Ajouter un article',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15.0),
            nom,
            const SizedBox(height: 10.0),
            marque,
            const SizedBox(height: 10.0),
            taille,
            const SizedBox(height: 10.0),
            type,
            const SizedBox(height: 10.0),
            prix,
            const SizedBox(height: 10.0),
            if (showError)
              const Text(
                'Valeurs manquantes',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40.0),
            validateButton,
          ],
        ));
  }
}
