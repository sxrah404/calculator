import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:glass_kit/glass_kit.dart';
import 'theme.dart';
import 'calculator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(const Size(500, 850));
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getCalculatorTheme(Brightness.light),
      darkTheme: getCalculatorTheme(Brightness.dark),
      themeMode: themeMode,
      home: CalculatorApp(onToggleTheme: toggleTheme),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const CalculatorApp({super.key, required this.onToggleTheme});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final Calculator calculator = Calculator();

  void handleButtonPress(String buttonText) {
    setState(() {
      calculator.handleButtonPress(buttonText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final gradients = theme.extension<CalculatorGradients>()!;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradients.background),
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
                        onTap: widget.onToggleTheme,
                        child: Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          calculator.historyDisplay,
                          textAlign: TextAlign.right,
                          style: textTheme.headlineMedium,
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
                          calculator.mainDisplay,
                          style: textTheme.displayLarge,
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
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['7', '8', '9', '×'],
                          onPressed: handleButtonPress,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['4', '5', '6', '-'],
                          onPressed: handleButtonPress,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['1', '2', '3', '+'],
                          onPressed: handleButtonPress,
                        ),
                        SizedBox(height: 12),
                        CalculatorButtonRow(
                          buttons: ['+/-', '0', '.', '='],
                          onPressed: handleButtonPress,
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

  const CalculatorButtonRow({
    super.key,
    required this.buttons,
    required this.onPressed,
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

  const CalculatorButton({
    super.key,
    required this.text,
    required this.isAccent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (isAccent) {
      return ElevatedButton(
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: text.length > 2 ? 22 : 32,
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
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: text.length > 2 ? 22 : 32,
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
