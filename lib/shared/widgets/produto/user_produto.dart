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
  // Widget buildUser(User user) => ListTile(
  //       leading: CircleAvatar(
  //         child: Text(user.name),
  //       ),
  //       title: Text(user.name),
  //       subtitle: Text(user.preco),
  //     );

  Widget buildUser(Product product) => AnimatedCard(
        direction: AnimatedCardDirection.right,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 100,
            right: 100,
            bottom: 0,
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
                  Image.network(product.image),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Dados do Produto\n",
                      style: TextFonts.product,
                      children: [
                        TextSpan(
                          text: product.name,
                          style: TextFonts.product,
                        ),
                        TextSpan(
                          text: '\nPreço: ${product.preco}',
                          style: TextFonts.product,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
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
}
