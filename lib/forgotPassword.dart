import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool userNotFoundError = false;
  bool showError = false;
  bool showPassword = false;
  String password = "";  


  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    

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
          if(emailController.text != "") {
            await FirebaseFirestore.instance
              .collection('users')
              .where("email", isEqualTo: emailController.text)
              .get()
              .then((querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                userNotFoundError = false;
                showError = false;
                showPassword = true;
                password = querySnapshot.docs[0].data()["password"];
              });
            } else {
              setState(() {
                showError = false;
                showPassword = false;
                userNotFoundError = true;
              });
            }
          });
          }
          else {
            setState(() {
              showError = true;
              showPassword = false;
              userNotFoundError = false;
            });
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
            const Text('Mot de passe oublié',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15.0),
            email,
            if (userNotFoundError)
              const Text(
                'Utilisateur non trouvé',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              if (showError)
              const Text(
                'Veuillez renseigner un email',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              if (showPassword && password != "")
               Text(
                'Votre mot de passe est : $password',
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 40.0),
            validateButton,
          ],
        ));
  }
}
