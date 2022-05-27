import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc/shared/theme/app_colors.dart';

class TextFonts {
  static final principal = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.fontbuttom,
  );
  static final subtitle = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.tema,
  );
  static final product = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.appBar,
  );
  static final edit = GoogleFonts.lato(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.fontbuttom,
  );
  static final remove = GoogleFonts.lato(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.danger,
  );
  static final regras = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.buttom,
  );
}
