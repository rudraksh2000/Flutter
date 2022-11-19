// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import './screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, snapshot) {
        return MaterialApp(
          title: 'FlutterChat',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return ChatScreen();
              }
              return AuthScreen();
            },
          ),
        );
      },
    );
  }
}
