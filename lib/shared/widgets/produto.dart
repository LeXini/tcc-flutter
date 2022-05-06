import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';

class Produto extends StatefulWidget {
  const Produto({Key? key}) : super(key: key);

  @override
  State<Produto> createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      direction: AnimatedCardDirection.right,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.tema,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  AppImages.google,
                  width: 60,
                ),
                Text.rich(TextSpan(
                  text: "Dados do Produto\n",
                  style: TextFonts.product,
                  children: [
                    TextSpan(
                      text: "Produto: Teste\n",
                      style: TextFonts.product,
                    ),
                    TextSpan(
                      text: "Preço: 20,00",
                      style: TextFonts.product,
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
