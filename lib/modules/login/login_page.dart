import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc/modules/meus_registros/meus_registros.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/widgets/login_button.dart';

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
      appBar: AppBar(
        title: Text('Login: ' + (user == null ? 'out' : 'in')),
      ),
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
                  print("inicio da clicada");
                  await _googleSignIn.signIn();
                  setState(() {});
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MeusRegistros()));
                  print("fim da clicada");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
