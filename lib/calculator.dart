// this is just all the calculator logic and all that jazz bc my main.dart got too messy

class Calculator {
  String mainDisplay = '0';
  String historyDisplay = '';
  String currentOperation = '';
  double firstNum = 0;
  bool shouldResetDisplay = false;

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

  void handleButtonPress(String buttonText) {
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

  String formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(8).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }
}