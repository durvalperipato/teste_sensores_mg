import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lines/controller/products.dart';
import 'package:lines/data/header_json.dart';
import 'package:lines/model/products.dart';
import 'package:lines/view/menu.dart';
import 'package:lines/view/test_product.dart';
import 'package:lines/widgets/widgets.dart';

class NewTest extends StatefulWidget {
  @override
  _NewTestState createState() => _NewTestState();
}

class _NewTestState extends State<NewTest> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  List<ProductsModel> products = [];
  List<String> sensibilitys = [];
  List<String> voltages = [];
  List<String> typeOfTest = [];
  String product;
  String sensibility;
  String voltage;

  @override
  void initState() {
    super.initState();
    sensibilitys.add('Max');
    sensibilitys.add('Min');
    voltages.add('127');
    voltages.add('220');
    typeOfTest.add('180º');
    typeOfTest.add('360º');
  }

  DropdownButtonFormField dropDownButtonList(String labelText,
          List<dynamic> items, TextEditingController controller, String item) =>
      DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        items: items
            .map(
              (value) => DropdownMenuItem(
                value: value.toString(),
                child: Text(value.toString()),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == 'Min' || value == 'Max') {
            sensibilidadeMaximaController.text = '';
            sensibilidadeMinimaController.text = '';
            value == 'Min'
                ? sensibilidadeMinimaController.text = 'X'
                : sensibilidadeMaximaController.text = 'X';
          } else if (value == '127' || value == '220') {
            tensao127Controller.text = '';
            tensao220Controller.text = '';
            value == '127'
                ? tensao127Controller.text = 'X'
                : tensao220Controller.text = 'X';
          } else if (value == '180º' || value == '360º') {
            maxAngleController.text = '';
            value == '180º'
                ? maxAngleController.text = '180'
                : maxAngleController.text = '350';
          } else {
            controller.text = value;
          }

          setState(() {});
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                              color: Color.fromRGBO(2, 19, 125, 1),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsSensor(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Detalhes da Amostra',
                                              style: TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      containerTitleAndFormFieldMedSize(
                                        textFormField(
                                          context,
                                          'Nº da Amostra',
                                          amostraController,
                                          TextInputType.number,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          containerTitleAndFormFieldMaxSize(
                                            dropDownButtonList(
                                                'Produto',
                                                products,
                                                produtoController,
                                                product),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                              ),
                                              onPressed: () async {
                                                String result =
                                                    await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text('Novo Produto'),
                                                    content: TextField(
                                                      controller:
                                                          novoProdutoController,
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  novoProdutoController
                                                                      .text),
                                                          child: Text(
                                                              'Confirmar')),
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child:
                                                              Text('Voltar')),
                                                    ],
                                                  ),
                                                );
                                                if (result != null &&
                                                    result.isNotEmpty) {
                                                  insertProduct(ProductsModel(
                                                      name:
                                                          novoProdutoController
                                                              .text
                                                              .toUpperCase()));
                                                }
                                                novoProdutoController.text = '';
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      containerTitleAndFormFieldMedSize(
                                        textFormField(
                                          context,
                                          'Local',
                                          localController,
                                          TextInputType.text,
                                        ),
                                      ),
                                      containerTitleAndFormFieldMedSize(
                                        textFormField(
                                            context,
                                            'Data',
                                            dataController,
                                            TextInputType.number,
                                            date: true),
                                      ),
                                      containerTitleAndFormFieldMinSize(
                                          dropDownButtonList(
                                              'Sensibilidade',
                                              sensibilitys,
                                              sensibilidadeMaximaController,
                                              sensibility)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      containerTitleAndFormFieldMedSize(
                                        textFormField(
                                            context,
                                            'Temperatura Inicial',
                                            temperaturaInicialController,
                                            TextInputType.number),
                                      ),
                                      /*  Row(
                                        children: [ */
                                      containerTitleAndFormFieldMedSize(
                                        textFormField(
                                            context,
                                            'Umidade Inicial',
                                            umidadeInicialController,
                                            TextInputType.number),
                                      ),
                                      /* ], */
                                      /*   ), */
                                      containerTitleAndFormFieldMinSize(
                                        dropDownButtonList('Tensão', voltages,
                                            tensao220Controller, voltage),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      containerTitleAndFormFieldMedSize(
                                        dropDownButtonList('Ângulo', typeOfTest,
                                            maxAngleController, voltage),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          containerTitleAndFormFieldMaxSize(
                                            textFormField(
                                              context,
                                              'Observação',
                                              observacaoController,
                                              TextInputType.text,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: IconButton(
                                              color: Colors.transparent,
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                              ),
                                              onPressed: () => null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: 200,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        _keyForm.currentState.save();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TestSensor(
                                                        size: MediaQuery.of(
                                                                context)
                                                            .size)));
                                      },
                                      child: Text(
                                        'Iniciar Teste',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      elevation: 5,
                                      color: Colors.blueAccent,
                                    ),
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
