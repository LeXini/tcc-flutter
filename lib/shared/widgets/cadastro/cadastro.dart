import 'dart:io';

import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String ref = '';
  String url = '';
  final controllerName = TextEditingController();
  final controllerPreco = TextEditingController();

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> upload(String path) async {
    File file = File(path);
    try {
      ref = 'images/img-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  UploadImage() async {
    XFile? file = await image;
    if (file != null) {
      await upload(file.path);
      url = await storage.ref(ref).getDownloadURL();
    } else {
      print("\nEle foi nulo");
    }
  }

  Future createProduto(Product user) async {
    final prod = FirebaseFirestore.instance.collection('produtos').doc();
    user.id = prod.id;

    final json = user.toJson();

    await prod.set(json);
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
              controller: controllerName,
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
              controller: controllerPreco,
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
              onPressed: () async {
                await UploadImage();
                final product = Product(
                  name: controllerName.text,
                  preco: controllerPreco.text,
                  image: url,
                );
                createProduto(product);
              },
              icon: Icon(Icons.add),
              label: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  String id;
  final String name;
  final String preco;
  final String image;

  Product({
    this.id = '',
    required this.name,
    required this.preco,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'preco': preco,
        'image': image,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        preco: json['preco'],
        image: json['image'],
      );
}
