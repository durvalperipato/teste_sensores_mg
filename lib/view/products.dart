import 'package:flutter/material.dart';

List<String> products = [
  'MPX',
  '180º',
  'AMPX',
  'MPX2',
  '180º2',
  'AMPX2',
  'MPX3',
  '180º3',
  'AMPX3'
];

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController newProductController = TextEditingController();
  ScrollController scrollController = ScrollController();

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
          child: Form(
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
                        color: Color.fromRGBO(6, 58, 118, 1),
                      ),
                      child: Image.asset('images/logo_white.png'),
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
                                          if (newProductController.text.length >
                                              0) {
                                            products
                                                .add(newProductController.text);
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
                                thickness: 4,
                                color: Colors.lightBlue,
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
                                            child: Text(
                                              products.elementAt(index),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                                icon: Icon(Icons.edit_outlined),
                                                onPressed: () => null),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: Icon(Icons.delete_outline),
                                              onPressed: () async {
                                                bool result = await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title:
                                                              Text('Excluir?'),
                                                          content: Text(
                                                              'Produto: ' +
                                                                  products
                                                                      .elementAt(
                                                                          index)),
                                                          actions: [
                                                            FlatButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      false),
                                                              child: Text(
                                                                  'Cancelar'),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                products.remove(
                                                                  products
                                                                      .elementAt(
                                                                          index),
                                                                );
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                              child: Text(
                                                                  'Confirmar'),
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
                                thickness: 4,
                                color: Colors.lightBlue,
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
          ),
        ),
      ),
    );
  }
}
