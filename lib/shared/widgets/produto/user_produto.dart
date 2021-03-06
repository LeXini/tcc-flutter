import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';
import 'package:tcc/shared/widgets/cadastro/cadastro.dart';

class ProdutoUsuario extends StatefulWidget {
  const ProdutoUsuario({Key? key}) : super(key: key);

  @override
  State<ProdutoUsuario> createState() => _ProdutoState();
}

class _ProdutoState extends State<ProdutoUsuario> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Widget buildUser(Product product) => AnimatedCard(
        direction: AnimatedCardDirection.right,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 7.5,
            left: 15,
            right: 15,
            bottom: 7.5,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.tema,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  product.image,
                  width: 120,
                  height: 180,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Dados do Produto\n",
                        style: TextFonts.product,
                        children: [
                          TextSpan(
                            text: '\n${product.name}',
                            style: TextFonts.product,
                          ),
                          TextSpan(
                            text: '\n\nPreço: ${product.preco}',
                            style: TextFonts.product,
                          ),
                          TextSpan(
                            text:
                                '\n\nEstabelecimento: \n${product.estabelecimento}',
                            style: TextFonts.product,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        modalEdit(
                            context,
                            product.id,
                            product.name,
                            product.preco,
                            product.estabelecimento,
                            product.search);
                      },
                      child: Text(
                        "\nEditar dados do produto",
                        style: TextFonts.edit,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        modalRemove(product.id);
                      },
                      child: Text(
                        "Excluir produto",
                        style: TextFonts.remove,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      );

  Stream<List<Product>> readProds() => FirebaseFirestore.instance
      .collection('produtos')
      .where('uid', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroudTema,
      body: StreamBuilder<List<Product>>(
        stream: readProds(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ${snapshot.error}');
          } else if (snapshot.hasData) {
            final products = snapshot.data!;

            return ListView(
              children: products.map(buildUser).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  modalEdit(BuildContext context, id, name, preco, estabelecimento, search) {
    var form = GlobalKey<FormState>();

    final controllerName = TextEditingController(text: name);
    final controllerPreco = TextEditingController(text: preco);
    final controllerEstabelecimento =
        TextEditingController(text: estabelecimento);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.6,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: controllerName,
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: "Nome do Produto",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo não pode ser salvo vazio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    controller: controllerPreco,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Preço (R\$)",
                      hintText: "99,99",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo não pode ser salvo vazio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    controller: controllerEstabelecimento,
                    keyboardType: TextInputType.name,
                    maxLength: 30,
                    decoration: (InputDecoration(hintText: 'Estabelecimento')),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo não pode ser salvo vazio';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Sair"),
            ),
            FlatButton(
              onPressed: () async {
                if (form.currentState!.validate()) {
                  await FirebaseFirestore.instance
                      .collection('produtos')
                      .doc(id)
                      .update({
                    'name': controllerName.text,
                    'search': controllerName.text.toLowerCase(),
                    'preco': controllerPreco.text,
                    'estabelecimento': controllerEstabelecimento.text,
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Text("Editar"),
            ),
          ],
        );
      },
    );
  }

  void modalRemove(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tem certeza que deseja remover o produto?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("NÃO"),
            ),
            FlatButton(
              onPressed: () async {
                print("Excluido");
                await FirebaseFirestore.instance
                    .collection('produtos')
                    .doc(id)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text("SIM"),
            ),
          ],
        );
      },
    );
  }
}
