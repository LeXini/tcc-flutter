import 'dart:io';

import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';

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
  final controllerEstabelecimento = TextEditingController();
  bool isLoading = false;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<XFile?> setImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.camera);
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
      url =
          "https://firebasestorage.googleapis.com/v0/b/tcc-app-64ca2.appspot.com/o/images%2FSEM-IMAGEM-CADASTRADA-N%C3%83O-REMOVER.png?alt=media&token=7c2fa618-48ef-4bab-9035-8188407d6e5d";
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

    return SingleChildScrollView(
      child: AnimatedCard(
        direction: AnimatedCardDirection.right,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: isLoading
              ? Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Cadastrando produto...",
                        style: TextFonts.principal,
                      )
                    ],
                  ),
                )
              : Column(
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
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: "Nome do Produto",
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
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: "Preço (R\$)",
                              hintText: "99,99",
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            controller: controllerEstabelecimento,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo não pode ser salvo vazio';
                              }
                              return null;
                            },
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: "Nome do Estabelecimento",
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          ElevatedButton.icon(
                            onPressed: modalImage,
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
                                setState(() {
                                  isLoading = true;
                                });
                                modalConfirm();
                                await UploadImage();
                                await getPosition();
                                final product = Product(
                                  uid: user.uid,
                                  name: controllerName.text,
                                  search: controllerName.text.toLowerCase(),
                                  preco: controllerPreco.text,
                                  image: url,
                                  latitude: latitude,
                                  longitude: longitude,
                                  estabelecimento:
                                      controllerEstabelecimento.text,
                                );
                                createProduto(product);
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();
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
      ),
    );
  }

  void modalConfirm() {
    if (isLoading == false) {
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
    } else if (isLoading == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                CircularProgressIndicator(),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Cadastrando produto...",
                  style: TextFonts.principal,
                )
              ],
            ),
          );
        },
      );
    }
  }

  void modalImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
              children: <Widget>[
                Text("Escolha por onde deseja subir a imagem"),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.camera_front, size: 22),
                  label: Text("Galeria"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setImage();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.camera_alt, size: 22),
                  label: Text("Câmera"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Voltar"),
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
  final String search;
  final String preco;
  final String image;
  final double? latitude;
  final double? longitude;
  final String estabelecimento;

  Product({
    this.id = '',
    required this.uid,
    required this.name,
    required this.search,
    required this.preco,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.estabelecimento,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'name': name,
        'search': search,
        'preco': preco,
        'image': image,
        'latitude': latitude,
        'longitude': longitude,
        'estabelecimento': estabelecimento,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        uid: json['uid'],
        name: json['name'],
        search: json['search'],
        preco: json['preco'],
        image: json['image'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        estabelecimento: json['estabelecimento'],
      );
}
