import 'dart:io';

import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/shared/theme/app_colors.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;
  double? latitude;
  double? longitude;
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

  Future createProduto(Product product) async {
    final prod = FirebaseFirestore.instance.collection('produtos').doc();
    product.id = prod.id;

    final json = product.toJson();

    await prod.set(json);
  }

  @override
  Widget build(BuildContext context) {
    var form = GlobalKey<FormState>();

    return AnimatedCard(
      direction: AnimatedCardDirection.right,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: form,
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo não pode ser salvo vazio';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Nome",
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    controller: controllerPreco,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo não pode ser salvo vazio';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Preço",
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
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
                      if (form.currentState!.validate()) {
                        await UploadImage();
                        await getPosition();
                        final product = Product(
                          uid: user.uid,
                          name: controllerName.text,
                          preco: controllerPreco.text,
                          image: url,
                          latitude: latitude,
                          longitude: longitude,
                        );
                        createProduto(product);
                        modalConfirm();
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void modalConfirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Produto adicionado com sucesso'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ]);
      },
    );
  }

  getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }
}

class Product {
  String id;
  final String uid;
  final String name;
  final String preco;
  final String image;
  final double? latitude;
  final double? longitude;

  Product({
    this.id = '',
    required this.uid,
    required this.name,
    required this.preco,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'name': name,
        'preco': preco,
        'image': image,
        'latitude': latitude,
        'longitude': longitude,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        uid: json['uid'],
        name: json['name'],
        preco: json['preco'],
        image: json['image'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
