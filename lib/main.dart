import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String displayText = '0';
  String inputReader = '';
  String currentOperator = '';
  double? firstnum;
  double? secnum = null;
  double? result = null;

  Widget calcButton(
    String buttonText,
    Color textColor,
    Color btnColor,
    Function() onTap,
  ) {
    return SizedBox(
        width: 71,
        height: 71,
        child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                splashFactory: InkRipple.splashFactory,
                backgroundColor: btnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 17)),
            child: Text(buttonText,
                style: TextStyle(
                  fontSize: 25,
                  color: textColor,
                ))));
  }

  onPressedOperator(String op) {
    if (firstnum == null) {
      firstnum = double.parse(inputReader);
      currentOperator = op;
      inputReader = '';
    } else if (secnum == null) {
      secnum = inputReader != '' ? double.parse(inputReader) : 0.0;
      inputReader = '';
      result = calculate(firstnum, secnum);

      displayText = result.toString();
      firstnum = result;
      secnum = null;
      currentOperator = op;
    }
  }

  onPressEqual() {
    if (currentOperator != '') {
      secnum = inputReader != '' ? double.parse(inputReader) : 0.0;
      inputReader = '';
      result = calculate(firstnum, secnum);

      displayText = result.toString();
      firstnum = null;
      secnum = null;
      currentOperator = '';
    }
  }

  calculate(double? num1, double? num2) {
    if (currentOperator == '+') {
      return num1! + num2!;
    } else if (currentOperator == '-') {
      return num1! - num2!;
    } else if (currentOperator == '/') {
      return num1! / num2!;
    } else if (currentOperator == 'x') {
      return num1! * num2!;
    } else if (currentOperator == 'x') {
      return num1! * num2!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                padding: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      displayText,
                      style: TextStyle(color: Colors.white, fontSize: 75),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    calcButton('AC', Colors.black, Colors.grey, () {
                      setState(
                        () {
                          displayText = '0';
                          inputReader = '';
                          currentOperator = '';
                          firstnum = null;
                          secnum = null;
                          result = null;
                        },
                      );
                    }),
                    calcButton('+/-', Colors.black, Colors.grey, () {
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
                    calcButton('%', Colors.black, Colors.grey, () {}),
                    calcButton('/', Colors.white, Colors.amber.shade700, () {
                      setState(() {
                        onPressedOperator('/');
                      });
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('7', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '7';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('8', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '8';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('9', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '9';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('x', Colors.white, Colors.amber.shade700, () {
                        setState(() {
                          onPressedOperator('x');
                        });
                      }),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('4', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '4';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('5', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '5';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('6', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '6';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('-', Colors.white, Colors.amber.shade700, () {
                        setState(() {
                          onPressedOperator('-');
                        });
                      }),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      calcButton('1', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '1';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('2', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '2';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('3', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '3';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('+', Colors.white, Colors.amber.shade700, () {
                        setState(() {
                          onPressedOperator('+');
                        });
                      }),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            inputReader = inputReader + '0';
                            displayText = inputReader;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.only(
                                left: 65, right: 65, top: 15, bottom: 15)),
                      ),
                      calcButton('.', Colors.white, Colors.grey.shade800, () {
                        setState(() {
                          inputReader = inputReader + '.';
                          displayText = inputReader;
                        });
                      }),
                      calcButton('=', Colors.white, Colors.amber.shade700, () {
                        setState(() {
                          onPressEqual();
                        });
                      }),
                    ]),
              )
            ])));
  }
}
