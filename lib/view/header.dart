import 'package:flutter/material.dart';
import '../data/header_json.dart';

List<Widget> children = [];
double heightContainer = 25;
enum Keyboard { NUMBER, TEXT }

TextField containerTextField(
        TextEditingController controller, Keyboard textInput) =>
    TextField(
      textAlign: TextAlign.center,
      controller: controller,
      keyboardType: Keyboard.NUMBER == textInput
          ? TextInputType.number
          : TextInputType.text,
    );

Container containerTitles(Widget child) => Container(
      color: Colors.grey,
      child: child,
    );

Container containerSubtitles(Widget child) => Container(
      color: Colors.grey[300],
      child: child,
    );

Row titlesAndFlex(String line, bool textField) {
  children = List.generate(
    table[line]['titles'].length,
    (index) => Expanded(
      flex: table[line]['titles'][index].elementAt(0),
      child: Container(
        height: heightContainer,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Center(
          child: textField
              ? containerTextField(
                  table[line]['controllers'][index].elementAt(0), Keyboard.TEXT)
              : Text(
                  table[line]['titles'][index].elementAt(1),
                ),
        ),
      ),
    ),
  );
  return drawRow(children);
}

Row subtitlesAndFlex(String line, bool textField) {
  children = List.generate(
    table[line]['subtitles'].length,
    (index) => Expanded(
      flex: table[line]['subtitles'][index].elementAt(0),
      child: Row(
        children: subtitleText(line, index, textField),
      ),
    ),
  );
  return drawRow(children);
}

List<Widget> subtitleText(String line, int index, bool textField) {
  List<Widget> children = [];
  String secondKey = textField ? 'controllers' : 'subtitles';
  int initialValue = textField ? 0 : 1;
  for (int elementAt = initialValue;
      elementAt < table[line][secondKey][index].length;
      elementAt++) {
    children.add(
      Expanded(
        child: Container(
          height: heightContainer,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Center(
              child: textField
                  ? containerTextField(
                      table[line][secondKey][index].elementAt(elementAt),
                      Keyboard.NUMBER)
                  : Text(
                      table[line][secondKey][index].elementAt(elementAt),
                    )),
        ),
      ),
    );
  }

  return children;
}

List<Widget> drawTable() {
  List<Widget> children = [];
  table.forEach((key, value) {
    if (table[key]['subtitles'] != null) {
      children.add(
        containerTitles(
          titlesAndFlex(key, false),
        ),
      );
      children.add(
        containerSubtitles(
          subtitlesAndFlex(key, false),
        ),
      );
      children.add(
        subtitlesAndFlex(key, true),
      );
    } else {
      children.add(
        containerTitles(
          titlesAndFlex(key, false),
        ),
      );
      children.add(
        titlesAndFlex(key, true),
      );
    }
  });
  return children;
}

Row drawRow(List<Widget> children) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children);

Container header(BuildContext context) => Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Column(
        children: drawTable(),
      ),
    );
