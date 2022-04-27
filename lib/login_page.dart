import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.tema,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: 40,
              color: AppColors.teste,
            ),
          ),
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
            child: LoginButton(onTap: () {}),
          ),
        ],
      ),
    );
  }
}
