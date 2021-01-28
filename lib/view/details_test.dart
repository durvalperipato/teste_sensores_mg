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
            /* RaisedButton(
              child: Text('Inserir Produto'),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewProduct())),
            ), */
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
          vertical: 80,
          horizontal: 30,
        ),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black,
                        blurRadius: 2,
                        spreadRadius: 2,
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
                              children: [
                                title('Amostra'),
                                textFormField(
                                    amostraController, TextInputType.text),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
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
                                    produtoController.text = value;
                                    setState(() {
                                      product = products
                                          .elementAt(products.indexOf(value));
                                    });
                                  },
                                  value: product,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
                              children: [
                                title('Local'),
                                textFormField(
                                    localController, TextInputType.text),
                              ],
                            ),
                          ),
                        ],
                      ),
                      space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
                              children: [
                                title('Data'),
                                textFormField(
                                    dataController, TextInputType.number),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
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
                                    sensibilidadeMaximaController.text = '';
                                    sensibilidadeMinimaController.text = '';
                                    value == 'Min'
                                        ? sensibilidadeMinimaController.text =
                                            'X'
                                        : sensibilidadeMaximaController.text =
                                            'X';
                                    setState(() {
                                      sensibility = sensibilitys.elementAt(
                                          sensibilitys.indexOf(value));
                                    });
                                  },
                                  value: sensibility,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
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
                                    tensao127Controller.text = '';
                                    tensao220Controller.text = '';
                                    value == '127'
                                        ? tensao127Controller.text = 'X'
                                        : tensao220Controller.text = 'X';
                                    setState(() {
                                      voltage = voltages
                                          .elementAt(voltages.indexOf(value));
                                    });
                                  },
                                  value: voltage,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
                              children: [
                                title('T. Inicial'),
                                textFormField(temperaturaInicialController,
                                    TextInputType.number),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            child: Column(
                              children: [
                                title('U. Inicial'),
                                textFormField(umidadeInicialController,
                                    TextInputType.number),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 120,
                          )
                        ],
                      ),
                      space,
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: RaisedButton(
                  onPressed: () async {
                    _keyForm.currentState.save();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TestSensor(size: MediaQuery.of(context).size)));
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
    );
  }
}
