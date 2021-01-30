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

  SizedBox space = SizedBox();

  Container textFormField(String labelText, TextEditingController controller,
          TextInputType keyboardType,
          {bool date = false}) =>
      Container(
        width: 150,
        height: 80,
        child: date
            ? TextFormField(
                decoration: InputDecoration(
                  labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                controller: controller,
                onTap: () async {
                  DateTime dateTimePicked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2040),
                  );

                  controller.text =
                      dateTimePicked.day.toString().padLeft(2, '0') +
                          '/' +
                          dateTimePicked.month.toString().padLeft(2, '0') +
                          '/' +
                          dateTimePicked.year.toString();
                },
              )
            : TextFormField(
                decoration: InputDecoration(
                  labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: keyboardType,
                controller: controller,
                onSaved: (newValue) => controller.text = newValue.toUpperCase(),
              ),
      );

  Container containerTitleAndFormField(Widget child) => Container(
        height: 100,
        width: 120,
        child: Column(
          children: [
            child,
          ],
        ),
      );

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
            sensibility = items.elementAt(items.indexOf(value));
          } else if (value == '127' || value == '220') {
            tensao127Controller.text = '';
            tensao220Controller.text = '';
            value == '127'
                ? tensao127Controller.text = 'X'
                : tensao220Controller.text = 'X';
            voltage = items.elementAt(items.indexOf(value));
          } else {
            controller.text = value;
            product = items.elementAt(items.indexOf(value));
          }

          setState(() {});
        },
        value: item,
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
                                    'Nº da Amostra',
                                    amostraController,
                                    TextInputType.text,
                                  ),
                                ),
                                containerTitleAndFormField(
                                  dropDownButtonList('Produto', products,
                                      produtoController, product),
                                ),
                                containerTitleAndFormField(
                                  textFormField(
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
                                  textFormField('Data', dataController,
                                      TextInputType.number,
                                      date: true),
                                ),
                                containerTitleAndFormField(dropDownButtonList(
                                    'Sensibilidade',
                                    sensibilitys,
                                    sensibilidadeMaximaController,
                                    sensibility)),
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
                                      'Temperatura Inicial',
                                      temperaturaInicialController,
                                      TextInputType.number),
                                ),
                                containerTitleAndFormField(
                                  textFormField(
                                      'Umidade Inicial',
                                      umidadeInicialController,
                                      TextInputType.number),
                                ),
                                SizedBox(
                                  height: 80,
                                  width: 120,
                                ),
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
