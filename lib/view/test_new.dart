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
  List<String> angleOfTest = [];
  List<String> typeOfTest = [];
  String product;
  String sensibility;
  String voltage;
  String typeTest;
  String angle;

  @override
  void initState() {
    super.initState();
    sensibilitys.add('Max');
    sensibilitys.add('Med');
    sensibilitys.add('Min');
    voltages.add('127');
    voltages.add('220');
    angleOfTest.add('180º');
    angleOfTest.add('360º');
    typeOfTest.add('Angular');
    typeOfTest.add('Frontal');
    typeOfTest.add('Ambos');
  }

  DropdownButtonFormField dropDownButtonList(String labelText,
          List<dynamic> items, TextEditingController controller, String item) =>
      DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        value: item,
        items: items
            .map(
              (value) => DropdownMenuItem(
                value: value.toString(),
                child: Text(value.toString()),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == 'Min' || value == 'Med' || value == 'Max') {
            sensibilidadeMaximaController.text = '';
            sensibilidadeMediaController.text = '';
            sensibilidadeMinimaController.text = '';
            value == 'Min'
                ? sensibilidadeMinimaController.text = 'X'
                : value == 'Med'
                    ? sensibilidadeMediaController.text = 'X'
                    : sensibilidadeMaximaController.text = 'X';
          } else if (value == '127' || value == '220') {
            tensao127Controller.text = '';
            tensao220Controller.text = '';
            value == '127'
                ? tensao127Controller.text = 'X'
                : tensao220Controller.text = 'X';
          } else if (value == 'Ambos') {
            typeOfTestController.text = 'Duplo';
          } else if (value == '180º' || value == '360º') {
            maxAngleController.text = '';
            value == '180º'
                ? maxAngleController.text = '180'
                : /* typeOfTestController.text != 'Duplo'
                    ? */
                maxAngleController.text = '350';
            //: maxAngleController.text = '180';
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
                                      Expanded(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          textFormField(
                                            context,
                                            'Nº da Amostra',
                                            amostraController,
                                            TextInputType.number,
                                          ),
                                          first: true,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          textFormField(
                                            context,
                                            'RIA',
                                            riaController,
                                            TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Row(
                                          /* mainAxisAlignment:
                                              MainAxisAlignment.center,
                                           */
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: containerTitleAndFormField(
                                                dropDownButtonList(
                                                    'Produto',
                                                    products,
                                                    produtoController,
                                                    product),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
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
                                                        title: Text(
                                                            'Novo Produto'),
                                                        content: TextField(
                                                          controller:
                                                              novoProdutoController,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      novoProdutoController
                                                                          .text),
                                                              child: Text(
                                                                  'Confirmar')),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                              child: Text(
                                                                  'Voltar')),
                                                        ],
                                                      ),
                                                    );
                                                    if (result != null &&
                                                        result.isNotEmpty) {
                                                      insertProduct(ProductsModel(
                                                          name: novoProdutoController
                                                              .text
                                                              .toUpperCase()));
                                                    }
                                                    novoProdutoController.text =
                                                        '';
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                            textFormField(
                                              context,
                                              'Local',
                                              localController,
                                              TextInputType.text,
                                            ),
                                            first: true),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          textFormField(
                                              context,
                                              'Data',
                                              dataController,
                                              TextInputType.number,
                                              date: true),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                            dropDownButtonList(
                                                'Sensibilidade',
                                                sensibilitys,
                                                sensibilidadeMaximaController,
                                                sensibility)),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          dropDownButtonList('Tensão', voltages,
                                              tensao220Controller, voltage),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                            textFormField(
                                                context,
                                                'Temperatura Inicial',
                                                temperaturaInicialController,
                                                TextInputType.number),
                                            first: true),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          textFormField(
                                              context,
                                              'Umidade Inicial',
                                              umidadeInicialController,
                                              TextInputType.number),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          dropDownButtonList(
                                              'Tipo de Teste',
                                              typeOfTest,
                                              typeOfTestController,
                                              typeTest),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: containerTitleAndFormField(
                                          dropDownButtonList(
                                              'Ângulo',
                                              angleOfTest,
                                              maxAngleController,
                                              angle),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        child: containerTitleAndFormField(
                                            textFormField(
                                              context,
                                              'Observação',
                                              observacaoController,
                                              TextInputType.text,
                                            ),
                                            first: true),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: 200,
                                    child: ElevatedButton(
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
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blueAccent),
                                        elevation: MaterialStateProperty.all(5),
                                      ),
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
