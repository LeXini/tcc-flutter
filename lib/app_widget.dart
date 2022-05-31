import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/modules/login/login_page.dart';
import 'package:tcc/modules/meus_registros/meus_registros.dart';
import 'package:tcc/shared/theme/app_colors.dart';

class AppWidget extends StatelessWidget {
  AppWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocPro',
      theme: ThemeData(
        primaryColor: AppColors.tema,
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/registros": (context) => MeusRegistros(),
      },
    );
  }
}
