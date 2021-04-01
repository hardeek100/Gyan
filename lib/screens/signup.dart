import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final name = TextEditingController();

  final password1 = TextEditingController();

  final password2 = TextEditingController();

  final email = TextEditingController();

  final age = TextEditingController();

  String language, country;

  var languages = [
    "Nepali",
    "English",
    "Vietnamese",
    "Hindi",
    "French",
    "Deutsch",
    "Chinese",
  ];

  var countries = [
    "Nepal",
    "USA",
    "UK",
    "Germany",
    "India",
    "Vietnam",
    "China",
    "Jamaica"
  ];

  @override
  Widget build(BuildContext context) {
    Future<void> addUser(String uid) {
      return users.doc(uid).set({
        'name': name.text,
        'language': language,
        'country': country,
        'age': int.parse(age.text),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User added"),
          backgroundColor: Colors.lightBlue[300],
        ));
      }).catchError((e) => print("Failed to add user.$e"));
    }

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            TextField(
                controller: name,
                obscureText: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: "Name")),
            TextField(
                controller: age,
                obscureText: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(),
                    labelText: "Age")),
            TextField(
                controller: email,
                obscureText: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: "Email")),
            TextField(
                controller: password1,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    border: OutlineInputBorder(),
                    labelText: "Password")),
            TextField(
                controller: password2,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    border: OutlineInputBorder(),
                    labelText: "Verify Password")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Select your country   "),
                DropdownButton<String>(
                  value: country,
                  items: countries.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Select your language   "),
                DropdownButton<String>(
                  value: language,
                  items: languages.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      language = value;
                    });

                    print("Language " + language);
                  },
                ),
              ],
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  if (password2.text == password1.text) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password1.text);

                      addUser(userCredential.user.uid.toString());

                      Navigator.pushReplacementNamed(context, '/');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "weak-password") {
                        password2.text = password1.text = "";
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Weak password Try again "),
                          backgroundColor: Colors.lightBlue[300],
                        ));
                      } else if (e.code == "email-already-in-use") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Email Already in use"),
                          backgroundColor: Colors.lightBlue[300],
                        ));
                      }
                    } catch (e) {
                      print("ERROR" + e);
                    }
                  } else {
                    password2.text = password1.text = "";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Password do not match. Please try again. "),
                      backgroundColor: Colors.lightBlue[300],
                    ));
                  }
                },
                icon: Icon(Icons.create),
                label: Text("Create Account"))
          ],
        ),
      ),
    ));
  }
}
