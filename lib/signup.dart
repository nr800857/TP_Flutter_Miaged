import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'article.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool passwordError = false;
  bool emptyError = false;
  bool emailError = false;
  
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordVerifyController = TextEditingController();
    final birthdayController = TextEditingController();
    final addressController = TextEditingController();
    final postCodeController = TextEditingController();
    final cityController = TextEditingController();

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final passwordVerify = TextFormField(
      autofocus: false,
      controller: passwordVerifyController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Confirmation mot de passe',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final birthday = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: birthdayController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Date de naissance',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final address = TextFormField(
      autofocus: false,
      controller: addressController,
      decoration: InputDecoration(
        hintText: 'Adresse',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final postcode = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: postCodeController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Code postal',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    var city = TextFormField(
      autofocus: false,
      controller: cityController,
      decoration: InputDecoration(
        hintText: 'Ville',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

    final signUpButton = Padding(
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
          if (passwordController.text != passwordVerifyController.text &&
              postCodeController.text.length != 4) {
            setState(() {
              passwordError = true;
            });
          } else if (emailController.text == "" ||
              passwordController.text == "" ||
              passwordVerifyController.text == "" ||
              birthdayController.text == "" ||
              addressController.text == "" ||
              postCodeController.text == "" ||
              cityController.text == "") {
            setState(() {
              emptyError = true;
            });
          } else if (!isEmailValid(emailController.text)) {
            setState(() {
              emailError = true;
            });
          } else {
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');
            users.add({
              'email': emailController.text,
              'password': passwordController.text,
              'birthday': birthdayController.text,
              'address': addressController.text,
              'postcode': postCodeController.text,
              'city': cityController.text,
            });

            await FirebaseFirestore.instance
                .collection('users')
                .where("email", isEqualTo: emailController.text)
                .where("password", isEqualTo: passwordController.text)
                .get()
                .then((querySnapshot) async {
              if (querySnapshot.docs.isNotEmpty) {
                globals.isLoggedIn = true;
                globals.userID = querySnapshot.docs[0].reference.id;
                await FirebaseFirestore.instance
                    .collection('carts')
                    .where("userID",
                        isEqualTo: querySnapshot.docs[0].reference.id)
                    .get()
                    .then((querySnapshot) async {
                  if (querySnapshot.docs.isNotEmpty) {
                    globals.cartID = querySnapshot.docs[0].reference.id;
                    for (var element in querySnapshot.docs[0]["items"]) {
                      await FirebaseFirestore.instance
                          .collection('items')
                          .doc(element)
                          .get()
                          .then((doc) {
                        globals.shoppingBag.add(Article(
                            doc['nom'],
                            doc['marque'],
                            doc['image'],
                            doc['prix'],
                            doc['taille'],
                            doc["type"],
                            element,
                            doc['userID']));
                      });
                    }
                  } else {
                    await FirebaseFirestore.instance
                        .collection('carts')
                        .add({"userID": globals.userID, "items": []}).then(
                            (value) => globals.cartID = value.id);
                  }
                });
                Navigator.of(context).pushReplacementNamed(HomePage.tag);
              }
            });
          }
        },
        child: const Text('S\'inscrire'),
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
            const Text('Inscription',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15.0),
            email,
            if (emailError)
              const Text(
                'Email invalide',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.end,
              ),
            const SizedBox(height: 10.0),
            password,
            if (passwordError)
              const Text(
                'Mot de passe invalide',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.end,
              ),
            const SizedBox(height: 10.0),
            passwordVerify,
            const SizedBox(height: 10.0),
            birthday,
            const SizedBox(height: 10.0),
            address,
            const SizedBox(height: 10.0),
            postcode,
            const SizedBox(height: 10.0),
            city,
            if (emptyError)
              const SizedBox(height: 10.0),
              const Text(
                'Valeurs manquantes',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40.0),
            signUpButton,
          ],
        ));
  }
}
