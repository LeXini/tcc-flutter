import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/widgets/produto.dart';

class MeusRegistros extends StatefulWidget {
  const MeusRegistros({Key? key}) : super(key: key);

  @override
  State<MeusRegistros> createState() => _MeusRegistros();
}

class _MeusRegistros extends State<MeusRegistros> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    SizedBox(child: Produto()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
