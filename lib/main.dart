import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_example.dart';
import 'firebase_options.dart';
import 'intro/intro_page.dart';

import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}





class MyApp extends StatelessWidget {
   MyApp({super.key});



  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


   Future<void> init() async {
     // Request notification permission
     NotificationSettings settings = await _messaging.requestPermission(
         alert: true,
         announcement: true,
         badge: true,
         sound: true,
         carPlay: true,
         criticalAlert: true);

     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
       // Get device token
       String? token = await _messaging.getToken();
       if (token != null) {
         // Store token in Firestore (replace 'userId' with the actual user ID)
         print('this is token: $token   ');
       }
     }
   }

  @override
  Widget build(BuildContext context) {
     init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: // IntroPage()

      //heloo
      FirestoreExample(),
    );
  }
}

