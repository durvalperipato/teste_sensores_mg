import 'package:flutter/material.dart';
import 'package:lines/controller/products.dart';
import 'package:lines/model/products.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController newProductController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<ProductsModel> products = [];

  @override
  Widget build(BuildContext context) {
    products.sort();

    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: FutureBuilder(
            future: getProducts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                products = snapshot.data;

                return Form(
                  key: _keyForm,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(6, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Color.fromRGBO(2, 19, 125,
                                  1), //Color.fromRGBO(6, 58, 118, 1),
                            ),
                            child: Image.asset('images/logo_white.jpg'),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 15,
                                      bottom: 15,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Produtos',
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Container(
                                          width: 400,
                                          child: TextField(
                                            controller: newProductController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder()),
                                          ),
                                        ),
                                        title: Text(
                                          'Novo Produto',
                                          textAlign: TextAlign.center,
                                        ),
                                        elevation: 6,
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                if (newProductController
                                                        .text.length >
                                                    0) {
                                                  ProductsModel newProduct =
                                                      ProductsModel(
                                                          name: newProductController
                                                              .text
                                                              .toUpperCase());
                                                  insertProduct(newProduct);
                                                  newProductController.clear();
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Adicionar'))
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      'Novo Produto',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    width: 600,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    height: 400,
                                    width: 600,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Text(products
                                                          .elementAt(index)
                                                          .toString()
                                                      //products.elementAt(index),
                                                      ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                      icon: Icon(
                                                          Icons.edit_outlined),
                                                      onPressed: () => null),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                    icon: Icon(
                                                        Icons.delete_outline),
                                                    onPressed: () async {
                                                      bool result =
                                                          await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title: Text(
                                                                            'Excluir?'),
                                                                        content:
                                                                            Text('Produto: ' +
                                                                                products.elementAt(index).toString()),
                                                                        actions: [
                                                                          FlatButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, false),
                                                                            child:
                                                                                Text('Cancelar'),
                                                                          ),
                                                                          FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              deleteProduct(products.elementAt(index));

                                                                              Navigator.pop(context, true);
                                                                            },
                                                                            child:
                                                                                Text('Confirmar'),
                                                                          ),
                                                                        ],
                                                                      ));
                                                      if (result != null) {
                                                        if (result) {
                                                          setState(() {});
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            index != products.length - 1
                                                ? Divider(
                                                    color: Colors.grey,
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 600,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      _keyForm.currentState.save();
                                    },
                                    child: Text(
                                      'Voltar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    elevation: 5,
                                    color: Colors.blueAccent,
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
            },
          ),
        ),
      ),
    );
  }
}
