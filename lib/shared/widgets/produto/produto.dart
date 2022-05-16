import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
        padding: const EdgeInsets.only(
          top: 15,
          left: 10,
          right: 10,
          bottom: 500,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.tema,
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  AppImages.google,
                  width: 60,
                ),
                SizedBox(
                  height: 20.0,
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
