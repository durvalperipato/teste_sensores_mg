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

  Container containerTitleAndFormField(String titleOfText, Widget child) =>
      Container(
        height: 80,
        width: 120,
        child: Column(
          children: [
            title(titleOfText),
            child,
          ],
        ),
      );

  DropdownButton dropDownButtonList(List<dynamic> items,
          TextEditingController controller, String value) =>
      DropdownButton(
        underline: Container(),
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
          } else if (value == '127' || value == '220') {
            tensao127Controller.text = '';
            tensao220Controller.text = '';
            value == '127'
                ? tensao127Controller.text = 'X'
                : tensao220Controller.text = 'X';
          } else {
            controller.text = value;
          }
          setState(() {
            product = items.elementAt(items.indexOf(value));
          });
        },
        value: value,
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
                flex: 4,
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
                          containerTitleAndFormField(
                            'Amostra',
                            textFormField(
                              amostraController,
                              TextInputType.text,
                            ),
                          ),
                          containerTitleAndFormField(
                            'Produto',
                            dropDownButtonList(
                                products, produtoController, product),
                          ),
                          containerTitleAndFormField(
                            'Local',
                            textFormField(
                              localController,
                              TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          containerTitleAndFormField(
                            'Data',
                            textFormField(dataController, TextInputType.number),
                          ),
                          containerTitleAndFormField(
                              'Sensibilidade',
                              dropDownButtonList(
                                  sensibilitys, null, sensibility)),
                          containerTitleAndFormField('Tensão',
                              dropDownButtonList(voltages, null, voltage)),
                        ],
                      ),
                      space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          containerTitleAndFormField(
                            'T.Inicial',
                            textFormField(temperaturaInicialController,
                                TextInputType.number),
                          ),
                          containerTitleAndFormField(
                            'U.Inicial',
                            textFormField(
                                umidadeInicialController, TextInputType.number),
                          ),
                          SizedBox(
                            height: 80,
                            width: 120,
                          )
                        ],
                      ),
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
