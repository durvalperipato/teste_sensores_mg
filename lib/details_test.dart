import 'package:flutter/material.dart';
import 'package:lines/data/header_json.dart';
import 'package:lines/view/test_sensor.dart';

class MediaQuerySize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TestSensor(
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class DetailsSensor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Novo'),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewTest())),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTest extends StatefulWidget {
  @override
  _NewTestState createState() => _NewTestState();
}

class _NewTestState extends State<NewTest> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  List<String> products = [];
  List<String> sensibilitys = [];
  List<String> voltages = [];
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
  }

  Text title(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 20,
        ),
      );

  SizedBox space = SizedBox(
    height: 20,
  );

  Container textFormField(
          TextEditingController controller, TextInputType keyboardType) =>
      Container(
        width: 150,
        child: TextFormField(
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          controller: controller,
          onSaved: (newValue) => controller.text = newValue,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Form(
          key: _keyForm,
          child: ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          title('Amostra'),
                          textFormField(amostraController, TextInputType.text),
                        ],
                      ),
                      Column(
                        children: [
                          title('Produto'),
                          DropdownButton(
                            underline: Container(),
                            items: products
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                product =
                                    products.elementAt(products.indexOf(value));
                              });
                            },
                            value: product,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          title('Local'),
                          textFormField(localController, TextInputType.text),
                        ],
                      ),
                    ],
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          title('Data'),
                          textFormField(dataController, TextInputType.number),
                        ],
                      ),
                      Column(
                        children: [
                          title('Sensibilidade'),
                          DropdownButton(
                            underline: Container(),
                            items: sensibilitys
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              value == 'Min'
                                  ? sensibilidadeMinimaController.text = 'X'
                                  : sensibilidadeMaximaController.text = 'X';
                              setState(() {
                                sensibility = sensibilitys
                                    .elementAt(sensibilitys.indexOf(value));
                              });
                            },
                            value: sensibility,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          title('Tensão'),
                          DropdownButton(
                            underline: Container(),
                            items: voltages
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              value == '127'
                                  ? tensao127Controller.text = 'X'
                                  : tensao220Controller.text = 'X';
                              setState(() {
                                voltage =
                                    voltages.elementAt(voltages.indexOf(value));
                              });
                            },
                            value: voltage,
                          ),
                        ],
                      ),
                    ],
                  ),
                  space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          title('Temperatura Inicial'),
                          textFormField(temperaturaInicialController,
                              TextInputType.number),
                        ],
                      ),
                      Column(
                        children: [
                          title('Umidade Inicial'),
                          textFormField(
                              umidadeInicialController, TextInputType.number),
                        ],
                      ),
                    ],
                  ),
                  space,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
