import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 160),
              child: Center(
                child: Image.asset(
                  AppImages.logo,
                  width: 350,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 450),
              child: LoginButton(
                onTap: () async {
                  await signInWithGoogle();
                  setState(() {});
                  //print("usuario=" + userName);
                  sleep(Duration(seconds: 2));
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
}
