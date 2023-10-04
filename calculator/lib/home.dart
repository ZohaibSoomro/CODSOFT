import 'package:calculator/utils/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String input = "0";
  String result = "0";
  String expression = "";

  //for operand button's color changing logic
  bool isDivisionClicked = false;
  bool isMultiplyClicked = false;
  bool isAdditionClicked = false;
  bool isSubtractionClicked = false;

  //calculator logic
  onClicked(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        input = "0";
        result = "0";
        expression = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '÷' ||
          buttonText == '×') {
        if (input == '0' || input == '') {
          return;
        } else {
          input = input + buttonText;
          expression = input;
          input = '';
        }
      } else if (buttonText == '=') {
        expression += input;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (result == "Infinity") {
            input = "0";
            result = "0";
            expression = '';
            showMyDialog(context, "Invalid operation!",
                "Divide by zero is not allowed.");
          }
          if (result.endsWith(".0")) {
            result = result.substring(0, result.indexOf("."));
          }
        } catch (e) {
          result = "Error";
        }

        input = result;
      } else {
        if (input == "0") {
          input = buttonText;
        } else {
          input = input + buttonText;
        }
      }
    });
  }

  //Button widget
  Widget circleButton({required String buttonText, required Color? btnColor}) {
    bool isLightGrey = false;
    if (btnColor == Colors.grey[400]) {
      isLightGrey = true;
    }

    bool isZeroButton = false;
    if (buttonText == '0') {
      isZeroButton = true;
    }

    bool isDarkGrey = false;
    if (btnColor == Colors.grey[800]) {
      isDarkGrey = true;
    }

    return isZeroButton
        ?
        //zero button
        Expanded(
            flex: 2,
            child: MaterialButton(
              // highlightColor: Colors.grey,
              color: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(width: 8),
              ),
              onPressed: () => setState(() {
                onClicked(buttonText);
                isDivisionClicked = false;
                isMultiplyClicked = false;
                isAdditionClicked = false;
                isSubtractionClicked = false;
              }),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: isLightGrey ? Colors.black : Colors.white,
                      fontSize: 35),
                ),
              ),
            ),
          )

        //other buttons
        : Expanded(
            flex: 1,
            child: MaterialButton(
              shape: const CircleBorder(),
              color: btnColor,
              highlightColor: isDarkGrey || isLightGrey
                  ? Colors.grey[600]
                  : Colors.orange[700],
              onPressed: () => setState(() {
                onClicked(buttonText);
                isDivisionClicked = false;
                isMultiplyClicked = false;
                isAdditionClicked = false;
                isSubtractionClicked = false;
              }),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: isLightGrey ? Colors.black : Colors.white,
                      fontSize: 30),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // TextOutput
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text(
                        input,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text(
                        expression,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Divider
            const Divider(
              height: 20,
              color: Colors.white24,
            ),
            //for Buttons
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.fromLTRB(3, 10, 3, 2),
                child: Column(
                  children: [
                    //1st row

                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          circleButton(
                            buttonText: 'AC',
                            btnColor: Colors.grey[400],
                          ),

                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '%',
                            btnColor: Colors.grey[400],
                          ),
                          const SizedBox(width: 10),

                          //operand button
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              shape: const CircleBorder(),
                              color: isDivisionClicked
                                  ? Colors.white
                                  : Colors.orange,
                              onPressed: () => setState(() {
                                onClicked('÷');
                                isDivisionClicked = true;
                              }),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text(
                                    '÷',
                                    style: TextStyle(
                                        color: isDivisionClicked
                                            ? Colors.orange
                                            : Colors.white,
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //2nd row
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          circleButton(
                            buttonText: '7',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '8',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '9',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),

                          //operand button
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              shape: const CircleBorder(),
                              color: isMultiplyClicked
                                  ? Colors.white
                                  : Colors.orange,
                              onPressed: () => setState(() {
                                onClicked('×');
                                isMultiplyClicked = true;
                              }),
                              child: Center(
                                child: Text(
                                  '×',
                                  style: TextStyle(
                                    color: isMultiplyClicked
                                        ? Colors.orange
                                        : Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //3rd row
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          circleButton(
                            buttonText: '4',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '5',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '6',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),

                          //operand button
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              shape: const CircleBorder(),
                              color: isSubtractionClicked
                                  ? Colors.white
                                  : Colors.orange,
                              onPressed: () => setState(() {
                                onClicked('-');
                                isSubtractionClicked = true;
                              }),
                              child: Center(
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                      color: isSubtractionClicked
                                          ? Colors.orange
                                          : Colors.white,
                                      fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    //4th row
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          circleButton(
                            buttonText: '1',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '2',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '3',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),

                          //operand button
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              shape: const CircleBorder(),
                              color: isAdditionClicked
                                  ? Colors.white
                                  : Colors.orange,
                              onPressed: () => setState(() {
                                onClicked('+');
                                isAdditionClicked = true;
                              }),
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                      color: isAdditionClicked
                                          ? Colors.orange
                                          : Colors.white,
                                      fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //5th row
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          circleButton(
                            buttonText: '0',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '.',
                            btnColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 10),
                          circleButton(
                            buttonText: '=',
                            btnColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
