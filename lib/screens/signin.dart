import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: signInBody(context));
  }

  Widget signInBody(BuildContext context) {
    final username = TextEditingController();
    final password = TextEditingController();

    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.redAccent[400]),
        ),
        TextField(
          controller: username,
          obscureText: false,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            hintText: "Email",
            helperText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.security),
            hintText: "password",
            helperText: "password",
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: username.text, password: password.text);
                Navigator.pushReplacementNamed(context, '/home');
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("User not found. Please try again."),
                  ));
                } else if (e.code == 'wrong-password') {
                  password.text = "";
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Incorrect password please try again."),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.code),
                  ));
                }
              }
            },
            child: Text("Login")),
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New here?   "),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text("Create Account"))
            ],
          ),
        ),
      ],
    ));
  }
}
