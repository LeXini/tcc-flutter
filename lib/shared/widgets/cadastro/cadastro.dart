import 'dart:io';

import 'package:animated_card/animated_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/shared/theme/app_colors.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  XFile? image;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  UploadImage() async {
    XFile? file = image;
    if (file != null) {
      await upload(file.path);
    } else {
      print("\nEle foi nulo");
    }
  }

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.formato),
                ),
                hintText: "Nome",
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.formato),
                ),
                hintText: "Preço",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              onPressed: getImage,
              icon: Icon(Icons.upload, size: 22),
              label: Text("Escolha uma imagem"),
            ),
            const SizedBox(
              height: 100.0,
            ),
            FloatingActionButton.extended(
              backgroundColor: AppColors.tema,
              foregroundColor: AppColors.fontbuttom,
              onPressed: UploadImage,
              icon: Icon(Icons.add),
              label: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
