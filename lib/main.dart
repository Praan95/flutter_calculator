import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hello World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

enum Priority { same, high, low }

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  double? firstNum = null;
  double? secNum = null;
  double result = 0.0;
  String displayText = "0";
  String inputReader = "";
  String currentOperator = "";
  String mathExpression = "";

  secOpPriority(op1, op2) {
    if ((op1 == '+' || op1 == '-') && (op2 == 'x' || op2 == '/')) {
      return Priority.high;
    } else if ((op1 == 'x' || op1 == '/') && (op2 == '+' || op2 == '-')) {
      return Priority.low;
    } else if ((op1 == '+' || op1 == '-') && (op2 == '+' || op2 == '-')) {
      return Priority.same;
    } else if ((op1 == 'x' || op1 == '/') && (op2 == 'x' || op2 == '/')) {
      return Priority.same;
    }
  }

  double evaluateExpression(mathExpression) {
    mathExpression = mathExpression.replaceAll('x', '*');
    Parser p = Parser();
    try {
      Expression exp = p.parse(mathExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval;
    } catch (error) {
      print(error);
      return 0;
    }
  }

  onOperatorPress(String op) {
    if (inputReader != "") {
      if (firstNum == null) {
        // if first number is null.
        firstNum = double.parse(
            inputReader); // convert input reader to double and assign that value to firstNum.
        currentOperator = op; // set currentOperator to the operator we press.
        inputReader = ""; // Make inputReader empty.
      } else if (secNum == null &&
          secOpPriority(currentOperator, op) == Priority.same) {
        //  7+3x ==> 7+3x2 ==> 7+6
        secNum = inputReader != "" ? double.parse(inputReader) : 0.0;
        inputReader = "";
        var part1 = "";
        var part2 = "";
        if (mathExpression != '') {
          for (int i = mathExpression.length - 2; i >= 0; i--) {
            var char = mathExpression[i];
            if (char == '+' || char == 'x' || char == '/' || char == '-') {
              part1 = mathExpression.substring(0, i + 1); // 7+
              part2 = mathExpression.substring(i + 1); //3x
              break;
            }
          }
          result = evaluateExpression(part2 + secNum.toString());
          displayText = result.toString();
          mathExpression = part1 + result.toString() + op; // 7+6
          secNum = null;
          currentOperator = op;
        } else {
          result = evaluateExpression(
              firstNum.toString() + currentOperator + secNum.toString());
          displayText = result.toString();
          firstNum = result;
          secNum = null;
          currentOperator = op;
        }
      } else if (secNum == null &&
          secOpPriority(currentOperator, op) == Priority.high) {
        secNum = inputReader != ""
            ? double.parse(inputReader)
            : 0.0; // convert input reader to double and assign that value to secNum.
        inputReader = "";
        mathExpression = firstNum.toString() +
            currentOperator +
            secNum.toString() +
            op; // 7+3x
        secNum = null;
        currentOperator = op;
      } else if (secNum == null &&
          secOpPriority(currentOperator, op) == Priority.low) {
        secNum = inputReader != "" ? double.parse(inputReader) : 0.0;
        inputReader = "";
        if (mathExpression != '') {
          mathExpression = mathExpression + secNum.toString(); // "7+3x2"  +
          result = evaluateExpression(mathExpression);
          displayText = result.toString();
          firstNum = result; // 13.....
          secNum = null;
          currentOperator = op;
          mathExpression = '';
        } else {
          result = evaluateExpression(
              firstNum.toString() + currentOperator + secNum.toString());
          displayText = result.toString();
          firstNum = result;
          secNum = null;
          currentOperator = op;
        }
      }
    } else {
      currentOperator = op;
    }
  }

  onEqualPress() {
    if (currentOperator != "") {
      secNum = inputReader != "" ? double.parse(inputReader) : 0.0;
      if (mathExpression != '') {
        if (inputReader == "") {
          // no second number
          mathExpression = mathExpression.substring(
              0, mathExpression.length - 1); // 10 +    =
        } else {
          mathExpression = mathExpression + secNum.toString();
        }
        result = evaluateExpression(mathExpression);
        displayText = result.toString();
        firstNum = result;
        secNum = null;
        currentOperator = '';
        mathExpression = '';
      } else if (inputReader != "") {
        result = evaluateExpression(
            firstNum.toString() + currentOperator + secNum.toString());
        displayText = result.toString();
        firstNum = result;
        secNum = null;
        currentOperator = "";
      }
      inputReader = "";
    }
  }

  // calculate(double? num1, double? num2) {
  //   // if (currentOperator == '+') {
  //   //   return num1! + num2!;
  //   // } else if (currentOperator == '-') {
  //   //   return num1! - num2!;
  //   // } else if (currentOperator == 'x') {
  //   //   return num1! * num2!;
  //   // } else if (currentOperator == '/') {
  //   //   return num1! / num2!;
  //   // }
  //   return evaluateExpression(num1!.toString() + currentOperator + num2!.toString());
  // }

  onPercentagePress() {
    if (firstNum == null && inputReader != '') {
      firstNum = double.parse(inputReader);
      result = firstNum! / 100;
    } else {
      result = result / 100;
    }
    displayText = result.toString();
    firstNum = result;
    inputReader = "";
    currentOperator = '/';
  }

  Widget calcButton(
      String btntxt, Color btncolor, Color txtcolor, Function() onTap,
      {width = 70.0,
      height = 70.0,
      alignment = Alignment.center,
      leftPadding = 0.0}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            alignment: alignment,
            foregroundColor: Colors.white,
            splashFactory: InkRipple.splashFactory,
            backgroundColor: btncolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            padding: EdgeInsets.only(left: leftPadding)),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 30,
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            displayText,
                            softWrap: true,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 70),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('AC', Colors.grey, Colors.black, () {
                        setState(() {
                          firstNum = null;
                          secNum = null;
                          result = 0.0;
                          displayText = "0";
                          inputReader = "";
                          currentOperator = "";
                          mathExpression = "";
                        });
                      }),
                      calcButton('+/-', Colors.grey, Colors.black, () {
                        setState(() {
                          if (inputReader.startsWith('-')) {
                            //-56
                            inputReader = inputReader.substring(1); //56
                          } else {
                            // 56
                            inputReader = '-' + inputReader; //-56
                          }
                          displayText = inputReader;
                        });
                      }),
                      calcButton('%', Colors.grey, Colors.black, () {
                        setState(() {
                          onPercentagePress();
                        });
                      }),
                      calcButton('/', Colors.amber.shade700, Colors.white, () {
                        setState(() {
                          onOperatorPress('/');
                        });
                      }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('7', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '7';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('8', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '8';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('9', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '9';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('x', Colors.amber.shade700, Colors.white, () {
                        setState(() {
                          onOperatorPress('x');
                        });
                      }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('4', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '4';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('5', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '5';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('6', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '6';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('-', Colors.amber.shade700, Colors.white, () {
                        setState(() {
                          onOperatorPress('-');
                        });
                      }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('1', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '1';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('2', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '2';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('3', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '3';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('+', Colors.amber.shade700, Colors.white, () {
                        setState(() {
                          onOperatorPress('+');
                        });
                      }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('0', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '0';
                          displayText = inputReader;
                        });
                      },
                          width: 155.0,
                          height: 70.0,
                          alignment: Alignment.centerLeft,
                          leftPadding: 30.0),
                      calcButton('.', const Color.fromARGB(255, 81, 80, 80),
                          Colors.white, () {
                        setState(() {
                          inputReader = inputReader + '.';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('=', Colors.amber.shade700, Colors.white, () {
                        setState(() {
                          onEqualPress();
                        });
                      }),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                ])));
  }
}
