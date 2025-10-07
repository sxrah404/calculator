import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:glass_kit/glass_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(const Size(500, 850));
  }
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: CalculatorApp()));
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String mainDisplay = '0';
  String historyDisplay = '';
  String currentOperation = '';
  double firstNum = 0;
  bool shouldResetDisplay = false;
  bool isDarkMode = false;

  void handleButtonPress(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'AC':
          clearCalculator();
          break;
        case '⌫':
          deleteLastCharacter();
          break;
        case '=':
          calculateResult();
          break;
        case '÷':
        case '×':
        case '-':
        case '+':
        case '%':
          handleOperator(buttonText);
          break;
        case '+/-':
          toggleSign();
          break;
        default:
          handleNum(buttonText);
          break;
      }
    });
  }

  void clearCalculator() {
    mainDisplay = '0';
    historyDisplay = '';
    currentOperation = '';
    firstNum = 0;
    shouldResetDisplay = false;
  }

  void deleteLastCharacter() {
    if (mainDisplay.length > 1) {
      mainDisplay = mainDisplay.substring(0, mainDisplay.length - 1);
    } else {
      mainDisplay = '0';
    }
  }

  void handleNum(String value) {
    if (shouldResetDisplay) {
      mainDisplay = value;
      shouldResetDisplay = false;
    } else {
      if (value == '.' && mainDisplay.contains('.')) return;
      if (mainDisplay == '0' && value != '.') {
        mainDisplay = value;
      } else {
        mainDisplay += value;
      }
    }
  }

  void handleOperator(String operator) {
    firstNum = double.parse(mainDisplay);
    currentOperation = operator;
    historyDisplay = '$mainDisplay $operator';
    shouldResetDisplay = true;
  }

  void toggleSign() {
    if (mainDisplay == '0') return;
    if (mainDisplay.startsWith('-')) {
      mainDisplay = mainDisplay.substring(1);
    } else {
      mainDisplay = '-$mainDisplay';
    }
  }

  void calculateResult() {
    if (currentOperation.isEmpty) return;
    double secondNum = double.parse(mainDisplay);
    double result = 0;

    switch (currentOperation) {
      case '+':
        result = firstNum + secondNum;
        break;
      case '-':
        result = firstNum - secondNum;
        break;
      case '×':
        result = firstNum * secondNum;
        break;
      case '÷':
        if (secondNum != 0) {
          result = firstNum / secondNum;
        } else {
          mainDisplay = 'Error';
          historyDisplay = '';
          currentOperation = '';
          return;
        }
        break;
      case '%':
        result = firstNum % secondNum;
        break;
    }

    historyDisplay =
        '$firstNum $currentOperation $secondNum = ${formatResult(result)}';
    mainDisplay = formatResult(result);
    currentOperation = '';
    shouldResetDisplay = true;
  }

  String formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(8).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? RadialGradient(
                  center: Alignment(-0.6, -0.8),
                  radius: 1.5,
                  colors: [
                    Color.fromARGB(255, 4, 11, 26),
                    Color.fromARGB(255, 10, 30, 64),
                    Color.fromARGB(255, 26, 53, 112),
                    Color.fromARGB(255, 46, 47, 127),
                    Color.fromARGB(255, 91, 43, 155),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                )
              : RadialGradient(
                  center: Alignment(-0.6, -0.8),
                  radius: 1.5,
                  colors: [
                    Color.fromARGB(255, 227, 175, 255),
                    Color.fromARGB(255, 248, 174, 221),
                    Color.fromARGB(255, 231, 121, 241),
                    Color.fromARGB(255, 211, 135, 246),
                    Color.fromARGB(255, 177, 151, 248),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
        ),
        child: Center(
          child: GlassContainer.clearGlass(
            width: 425,
            height: 675,
            borderRadius: BorderRadius.circular(20),
            blur: 40,
            borderWidth: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: toggleTheme,
                        child: Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          historyDisplay,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          mainDisplay,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        CalculatorButtonRow(
                          buttons: ['⌫', 'AC', '%', '÷'],
                          onPressed: handleButtonPress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['7', '8', '9', '×'],
                          onPressed: handleButtonPress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['4', '5', '6', '-'],
                          onPressed: handleButtonPress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['1', '2', '3', '+'],
                          onPressed: handleButtonPress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['+/-', '0', '.', '='],
                          onPressed: handleButtonPress,
                          isDarkMode: isDarkMode,
                        ),
                      ],
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

class CalculatorButtonRow extends StatelessWidget {
  final List<String> buttons;
  final void Function(String) onPressed;
  final bool isDarkMode;

  const CalculatorButtonRow({
    super.key,
    required this.buttons,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: buttons.asMap().entries.map((entry) {
          int index = entry.key;
          String button = entry.value;
          bool isOperator = ['÷', '×', '-', '+', '='].contains(button);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < buttons.length - 1 ? 12 : 0,
              ),
              child: CalculatorButton(
                text: button,
                isAccent: isOperator,
                onTap: () => onPressed(button),
                isDarkMode: isDarkMode,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final bool isAccent;
  final VoidCallback onTap;
  final bool isDarkMode;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.isAccent,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (isAccent) {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? Color.fromARGB(255, 10, 30, 64)
              : Color.fromARGB(255, 230, 107, 241),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: text.length > 2 ? 22 : 32,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          GlassContainer.clearGlass(
            borderRadius: BorderRadius.circular(16),
            blur: 20,
            borderWidth: 0,
            elevation: 2,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: text.length > 2 ? 22 : 32,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.transparent,
              ),
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      );
    }
  }
}
