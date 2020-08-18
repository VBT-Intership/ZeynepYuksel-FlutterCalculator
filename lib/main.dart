import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

final Color color = HexColor.fromHex('#6699CC');
final Color aboutColor = HexColor.fromHex('#CCE5FF');

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CALCULATOR',
      theme: ThemeData(primaryColor: color),
      home: MyCalculator(),
    );
  }
}

class MyCalculator extends StatefulWidget {
  @override
  Calculate createState() => Calculate();
}

class Calculate extends State<MyCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 35.0;
  double resultFontSize = 45.0;
  double total = 0;
  String look;
  int opNum, num;
  Map<String, String> operatorsMap = {
    "/": "/",
    "*": "*",
    "−": "-",
    "+": "+",
    "%": "%"
  };
  control() {
    int i;
    int op = 0, number = 0;
    int look = 0;
    for (i = 0; i < equation.length; ++i) {
      look = 0;
      if (operatorsMap.containsValue(equation[i]) == true) {
        op++;
        number++;
        look = 1;
      }
    }
    if (look == 0) number++;
    opNum = op;
    num = number;
  }

  calculate() {
    try {
      Expression exp = (Parser()).parse(operatorsMap.entries.fold(
          equation, (prev, elem) => prev.replaceAll(elem.key, elem.value)));
      double res = double.parse(
          exp.evaluate(EvaluationType.REAL, ContextModel()).toString());
      result = double.parse(res.toString()) == int.parse(res.toStringAsFixed(0))
          ? res.toStringAsFixed(0)
          : res.toStringAsFixed(4);
    } catch (e) {
      result = "Error";
    }
  }

  Future<void> about() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This calculator app is developed by Zeynep Yüksel.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
        if (!operatorsMap
            .containsKey(equation.substring(equation.length - 1))) {
          control();
          if (opNum == num - 1) calculate();
        }
      } else if (buttonText == ".") {
        if (equation.length == 1 ||
            (operatorsMap.containsValue(equation[equation.length - 1]) ==
                false))
          equation = equation + ".";
        else
          equation = equation + "0.";

        if (look == "=") look = "*";
      } else if (buttonText == "=") {
        look = "=";
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        if (expression.length < 3)
          result = "0";
        else {
          if (!operatorsMap
              .containsKey(equation.substring(equation.length - 1))) {
            control();
            if (opNum == num - 1) calculate();
          }
          equation = result;
          result = "";
          look = "=";
        }
      } else if (buttonText == "About") {
        about();
      } else {
        if (look == "=") {
          if (operatorsMap.containsValue(buttonText) == false) {
            look = "/";
            result = "0";
            equation = "";
          }
          look = "/";
        }
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
        if (!operatorsMap
            .containsKey(equation.substring(equation.length - 1))) {
          control();
          if (opNum == num - 1) calculate();
        }
      }
    });
  }

  Widget createButton(String buttonText, Color buttonColor) {
    double size;
    if (buttonText == "About")
      size = 20.0;
    else
      size = 30.0;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.white,
      child: FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid)),
          padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALCULATOR'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 130, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  children: [
                    TableRow(children: [
                      createButton("C", color),
                      createButton("⌫", color),
                      createButton("%", color),
                      createButton("/", color),
                    ]),
                    TableRow(children: [
                      createButton("7", color),
                      createButton("8", color),
                      createButton("9", color),
                      createButton("*", color),
                    ]),
                    TableRow(children: [
                      createButton("4", color),
                      createButton("5", color),
                      createButton("6", color),
                      createButton("-", color),
                    ]),
                    TableRow(children: [
                      createButton("1", color),
                      createButton("2", color),
                      createButton("3", color),
                      createButton("+", color),
                    ]),
                    TableRow(children: [
                      createButton("About", Colors.teal),
                      createButton("0", color),
                      createButton(".", color),
                      createButton("=", color),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
