import 'package:animated_card/animated_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcc/shared/theme/app_colors.dart';
import 'package:tcc/shared/theme/app_images.dart';
import 'package:tcc/shared/theme/app_text_fonts.dart';
import 'package:tcc/shared/widgets/cadastro/cadastro.dart';

class Produto extends StatefulWidget {
  const Produto({Key? key}) : super(key: key);

  @override
  State<Produto> createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;

  String searchText = '';

  Widget buildUser(Product product) => AnimatedCard(
        direction: AnimatedCardDirection.right,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 2.5,
            left: 8,
            bottom: 2.5,
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
                  Image.network(
                    product.image,
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(
                    height: 10.0,
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
                          text: '\nPreço: R\$${product.preco}',
                          style: TextFonts.product,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      modalShow(
                        product.image,
                        product.name,
                        product.preco,
                        product.latitude,
                        product.longitude,
                        product.estabelecimento,
                      );
                    },
                    child: Text(
                      "\nVer dados do Produto",
                      style: TextFonts.edit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Stream<List<Product>> readProds(searchText) => FirebaseFirestore.instance
      .collection('produtos')
      .where(("search"), isGreaterThanOrEqualTo: searchText)
      .where(("search"), isLessThan: (searchText + 'z'))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 4;
    double cardHeight = MediaQuery.of(context).size.height / 5.2;
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Busca',
            ),
            onChanged: (val) {
              setState(() {
                searchText = val.toLowerCase();
              });
            },
          ),
        ),
      ),
      backgroundColor: AppColors.backgroudTema,
      body: StreamBuilder<List<Product>>(
        stream: readProds(searchText),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return GridView.count(
                childAspectRatio: cardWidth / cardHeight,
                crossAxisCount: 2,
                children: users.map(buildUser).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void modalShow(image, nome, preco, latitude, longitude, estabelecimento) {
    final _initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 15,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dados completos do produto\n",
                    style: TextFonts.subtitle,
                  ),
                  Image.network(image),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '\n${nome}',
                          style: TextFonts.principal,
                        ),
                        TextSpan(
                          text: '\n\nPreço: R\$${preco}',
                          style: TextFonts.principal,
                        ),
                        TextSpan(
                          text: '\n\Estabelecimento: ${estabelecimento}',
                          style: TextFonts.principal,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      modalMap(nome, preco, latitude, longitude);
                    },
                    child: Text(
                      "\nLocalização",
                      style: TextFonts.subtitle,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "OK",
                    style: TextFonts.edit,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void modalMap(nome, preco, latitude, longitude) async {
    Set<Marker> _markers = {};
    BitmapDescriptor mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), AppImages.icon);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(latitude, longitude),
          icon: mapMarker,
          infoWindow: InfoWindow(
            title: nome.toString(),
            snippet: preco.toString(),
          ),
        ),
      );
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            width: 500,
            height: 400,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 15,
              ),
              myLocationEnabled: true,
              markers: _markers,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Voltar",
                style: TextFonts.edit,
              ),
            ),
          ],
        );
      },
    );
  }
}
