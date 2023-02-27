import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/login.dart';
import 'user.dart';
import 'globals.dart' as globals;

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = User('', '', '', '', '', '');

  Future<User> getUser() async {
    print(globals.userID);
    User a = User('', '', '', '', '', '');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(globals.userID).get().then((doc) {
      if (doc.exists) {
          a = User(
          doc['email'],
          doc['password'],
          doc['birthday'],
          doc['address'],
          doc['postcode'],
          doc['city'],
        );
      } else {
        print('Document does not exist on the database');
      }
     
    });
    return a;
  }

  _ProfileState() {
    getUser().then((val) => setState(() {
          user = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: user.mail);
    final passwordController = TextEditingController(text: user.password);
    final birthdayController = TextEditingController(text: user.birthday);
    final addressController = TextEditingController(text: user.address);
    final postCodeController = TextEditingController(text: user.postcode);
    final cityController = TextEditingController(text: user.city);

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
        onPressed: () {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users.doc(globals.userID).update({
            'email': emailController.text,
            'password': passwordController.text,
            'birthday': birthdayController.text,
            'address': addressController.text,
            'postcode': postCodeController.text,
            'city': cityController.text,
          });
        },
        child: const Text('Valider'),
      ),
    );

    final logoutButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 224, 181, 181),
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: () {
          globals.isLoggedIn = false;
          globals.userID = "";
          globals.cartID = "";
          globals.shoppingBag = [];
          Navigator.of(context).pushReplacementNamed(LoginPage.tag);
        },
        child: const Text('Se déconnecter'),
      ),
    );
    
    return ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
    children: <Widget>[
      const SizedBox(height: 10.0),
      const Text('Profil', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      const SizedBox(height: 15.0),
      email,
      const SizedBox(height: 10.0),
      password,
      const SizedBox(height: 10.0),
      birthday,
      const SizedBox(height: 10.0),
      address,
      const SizedBox(height: 10.0),
      postcode,
      const SizedBox(height: 10.0),
      city,
      const SizedBox(height: 15.0),
      validateButton,
      const SizedBox(height: 40.0),
      logoutButton,
    ],
  );
    
    
  }
}
