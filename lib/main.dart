import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/requested.dart';
import 'screens/addpost.dart';
import 'screens/content.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Icon(Icons.error); 
        }

        if(snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
              title: "MyApp",
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.redAccent,
                accentColor: Colors.deepOrange,
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => SignIn(),
                '/signup': (context) => SignUp(),
                '/home' : (context) => Home(),
                '/requested' : (context) => Requested(),
                '/addpost' : (context) => AddPost(),
                '/content': (context) => Content(),
          
              },
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
