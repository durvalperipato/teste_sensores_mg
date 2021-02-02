import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lines/data/header_json.dart';
import 'package:lines/view/test_product.dart';
import 'package:lines/widgets/widgets.dart';

class NewTest extends StatefulWidget {
  @override
  _NewTestState createState() => _NewTestState();
}

class _NewTestState extends State<NewTest> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  List<String> products = [];
  List<String> sensibilitys = [];
  List<String> voltages = [];
  List<String> typeOfTest = [];
  String product;
  String sensibility;
  String voltage;

  @override
  void initState() {
    super.initState();
    products.add('MPX');
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
                value: value,
                child: Text(value),
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
            //  sensibility = items.elementAt(items.indexOf(value));
          } else if (value == '127' || value == '220') {
            tensao127Controller.text = '';
            tensao220Controller.text = '';
            value == '127'
                ? tensao127Controller.text = 'X'
                : tensao220Controller.text = 'X';
            //    voltage = items.elementAt(items.indexOf(value));
          } else if (value == '180º' || value == '360º') {
            maxAngleController.text = '';
            value == '180º'
                ? maxAngleController.text = '180'
                : maxAngleController.text = '350';
          } else {
            controller.text = value;
            //     product = items.elementAt(items.indexOf(value));
          }

          setState(() {});
        },
        //value: item,
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
                        child: Column(
                          children: [
                            Container(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                containerTitleAndFormField(
                                  textFormField(
                                    context,
                                    'Nº da Amostra',
                                    amostraController,
                                    TextInputType.text,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    containerTitleAndFormField(
                                      dropDownButtonList('Produto', products,
                                          produtoController, product),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        onPressed: () async {
                                          String result = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
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
                                                    child: Text('Confirmar')),
                                                FlatButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text('Voltar')),
                                              ],
                                            ),
                                          );
                                          if (result != null &&
                                              result.isNotEmpty) {
                                            products.add(result);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                containerTitleAndFormField(
                                  textFormField(
                                    context,
                                    'Local',
                                    localController,
                                    TextInputType.text,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                containerTitleAndFormField(
                                  textFormField(context, 'Data', dataController,
                                      TextInputType.number,
                                      date: true),
                                ),
                                Row(
                                  children: [
                                    containerTitleAndFormField(
                                        dropDownButtonList(
                                            'Sensibilidade',
                                            sensibilitys,
                                            sensibilidadeMaximaController,
                                            sensibility)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.transparent,
                                        onPressed: () => null,
                                      ),
                                    ),
                                  ],
                                ),
                                containerTitleAndFormField(dropDownButtonList(
                                    'Tensão',
                                    voltages,
                                    tensao220Controller,
                                    voltage)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                containerTitleAndFormField(
                                  textFormField(
                                      context,
                                      'Temperatura Inicial',
                                      temperaturaInicialController,
                                      TextInputType.number),
                                ),
                                Row(
                                  children: [
                                    containerTitleAndFormField(
                                      textFormField(
                                          context,
                                          'Umidade Inicial',
                                          umidadeInicialController,
                                          TextInputType.number),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.transparent,
                                        onPressed: () => null,
                                      ),
                                    ),
                                  ],
                                ),
                                containerTitleAndFormField(dropDownButtonList(
                                    'Ângulo',
                                    typeOfTest,
                                    maxAngleController,
                                    voltage)),
                              ],
                            ),
                            RaisedButton(
                              onPressed: () async {
                                _keyForm.currentState.save();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestSensor(
                                            size:
                                                MediaQuery.of(context).size)));
                              },
                              child: Text(
                                'Iniciar Teste',
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
