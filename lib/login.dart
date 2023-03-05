import 'package:flutter/material.dart';
import 'package:miaged/forgotPassword.dart';
import 'package:miaged/signup.dart';
import 'globals.dart' as globals;
import 'article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    const title = Text(
      'MIAGED',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 42.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    );

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

    final loginButton = Padding(
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
                          doc['userID'],));
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
            } else {
              setState(() {
                showError = true;
              });
            }
          });
        },
        child: const Text('Se connecter'),
      ),
    );

    final forgotLabel = TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
      child: const Text(
        'Mot de passe oublié ?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPassword(),
                ),
              );
      },
    );

    final signInButton = TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
      child: const Text(
        'S\'inscrire',
        style: TextStyle(color: Colors.black54, fontSize: 20),
      ),
      onPressed: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            const SizedBox(height: 38.0),
            title,
            const SizedBox(height: 34.0),
            email,
            const SizedBox(height: 8.0),
            password,
            forgotLabel,
            const SizedBox(height: 24.0),
            if (showError)
              const Text(
                'Mot de passe incorrect',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            loginButton,
            signInButton,
          ],
        ),
      ),
    );
  }
}
