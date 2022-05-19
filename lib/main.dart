import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tcc/app_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppFirebase());
}

class AppFirebase extends StatefulWidget {
  @override
  State<AppFirebase> createState() => _AppFirebaseState();
}

class _AppFirebaseState extends State<AppFirebase> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Material(
              child: Center(
                child: Text(
                  "Erro ao inicializar o Firebase",
                  textDirection: TextDirection.ltr,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return AppWidget();
          } else {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
    // theme: ThemeData(
    //   primarySwatch: Colors.blue,
    // ),
    // home: const LoginPage(),
  }
}
