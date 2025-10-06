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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.6, -0.8),
              radius: 1.5,
              colors: [
                Color.fromARGB(255, 227, 175, 255),
                Color(0xFFFFB7E5),
                Color(0xFFEA7AF4),
                Color(0xFFD98DFB),
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
                    // theme icon and history
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        Text(
                          'history goes here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),

                    // answer
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'answer goes here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // button grid
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          buildButtonRow(['⌫', 'AC', '%', '÷']),
                          SizedBox(height: 12),
                          buildButtonRow(['7', '8', '9', '×']),
                          SizedBox(height: 12),
                          buildButtonRow(['4', '5', '6', '-']),
                          SizedBox(height: 12),
                          buildButtonRow(['1', '2', '3', '+']),
                          SizedBox(height: 12),
                          buildButtonRow(['+/-', '0', '.', '=']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
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
              child: buildButton(button, isOperator),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildButton(String text, bool isAccent) {
    return GestureDetector(
      onTap: () {
        // Button press logic will go here
        print('Pressed: $text');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAccent
              ? Color.fromARGB(255, 230, 107, 241)
              : Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
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
    );
  }
}
