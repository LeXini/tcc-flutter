import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';
import 'package:tcc/shared/widgets/login_button/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: AppColors.tema,
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 120, top: 100),
              child: Center(
                child: Image.asset(
                  AppImages.logo,
                  width: 350,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 60,
                right: 40,
                top: 0,
                bottom: 40,
              ),
              child: Column(
                children: [
                  Text(
                    "Sempre verifique se é permitido tirar fotos dos produtos no local!",
                    style: TextFonts.principal,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: TextButton(
                      onPressed: () {
                        modalRegras();
                      },
                      child: Text(
                        'Leia aqui algumas regras importantes',
                        style: TextFonts.regras,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 30,
                bottom: 10,
              ),
              child: LoginButton(
                onTap: () async {
                  await signInWithGoogle();
                  setState(() {});
                  //sleep(Duration(seconds: 2));
                  Navigator.pushReplacementNamed(context, "/registros");
                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => MeusRegistros())
                  //     );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void modalRegras() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Este aplicativo tem o intuito de ajudar as pessoas a encontrar produtos mais baratos e que assim consigam localizar produtos mais em conta'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Entendi!"),
            ),
          ],
        );
      },
    );
  }
}
