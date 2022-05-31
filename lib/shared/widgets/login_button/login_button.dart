import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const LoginButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //praticamente mesmo código do botão visto no curso, tentar mudar
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 56,
              width: 130,
              decoration: BoxDecoration(
                color: AppColors.buttom,
                borderRadius: BorderRadius.circular(20),
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.borderButtom),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.google,
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Google",
                          style: TextFonts.google,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
