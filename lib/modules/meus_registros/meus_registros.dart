import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/modules/login/login_page.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/widgets/cadastro/cadastro.dart';
import 'package:tcc/shared/widgets/produto/produto.dart';
import 'package:tcc/shared/widgets/produto/user_produto.dart';

class MeusRegistros extends StatefulWidget {
  const MeusRegistros({Key? key}) : super(key: key);

  @override
  State<MeusRegistros> createState() => _MeusRegistros();
}

class _MeusRegistros extends State<MeusRegistros> {
  LoginPage usuario = new LoginPage();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SizedBox(child: Produto()),
    SizedBox(child: Cadastro()),
    SizedBox(child: ProdutoUsuario()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Olá, " + user.displayName!,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
              backgroundColor: AppColors.appBar,
            ),
          )
        ],
        backgroundColor: AppColors.tema,
      ),
      backgroundColor: AppColors.backgroudTema,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Cadastrar Produto',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Meus Cadastros',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.tema,
        onTap: _onItemTapped,
      ),
    );
  }
}
