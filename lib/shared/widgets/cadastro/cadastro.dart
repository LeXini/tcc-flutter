import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      direction: AnimatedCardDirection.right,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: "Nome",
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: "Preço",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
