import 'dart:core';

import 'package:flutter/material.dart';
import 'package:petitparser/core.dart';

import 'ast.dart';
import 'calculator_input_parser.dart';

class Calculator with ChangeNotifier {
  List<Expression> history = [];

  String _input = '';

  String get input => _input;

  set input(String value) {
    _input = value;
    notifyListeners();
  }

  int _currentRadix = 10;

  int get currentRadix => _currentRadix;

  set currentRadix(int value) {
    _currentRadix = value;
    notifyListeners();
  }

  Expression? get parsedInputExpr {
    try {
      return calcInputParser().parse(input).value as Expression?;
    } on ParserException {
      return null;
    }
  }

  String get parsedInputExprValueString => parsedInputExprValueStringRadix(radix: currentRadix);

  String parsedInputExprValueStringRadix({int radix = 10}) {
    return switch(radix) {
      10 => parsedInputExpr?.eval().toString() ?? '',
      _ => parsedInputExpr == null ? '' : doubleRadixString(parsedInputExpr!.eval(), radix),
    };
  }

  String doubleRadixString(double v, int radix) {
    var vSplittedString = v.toString().split('.');

    var intPart = int.parse(vSplittedString[0]);
    var fracPart = vSplittedString.length == 2 ? int.parse(vSplittedString[1]) : 0;

    return '${intPart.toRadixString(radix)}.${fracPart.toRadixString(radix)}';
  }

  Expression get _historyEntryRepeated => history.last.repeatedLeftMost().simplifiedLeftMost();
  String get _historyEntryRepeatedString => _historyEntryRepeated.eval().toString();

  //=
  void accept() {
    if(input == '' && history.isNotEmpty) {
      input = _historyEntryRepeatedString;
    }
    if(input == '') return;
    if (parsedInputExpr == null && history.isNotEmpty) {
      var expr = _historyEntryRepeated;
      input = expr.eval().toString();
      history.add(expr.copy());
    } else if (parsedInputExpr is! Value && parsedInputExpr != null) {
      var expr = parsedInputExpr!.copy();
      input = parsedInputExprValueString;
      history.add(expr);
    } else if (history.isNotEmpty && parsedInputExpr is Value) {
      var expr = _historyEntryRepeated;
      input = expr.eval().toString();
      history.add(expr.copy());
    }

    shouldClearInput = true;

    notifyListeners();
  }

  bool numberBeingEntered = false;
  bool decimalSeparatorEntered = false;

  bool shouldClearInput = false;

  bool evenNumberOfParenthesis = true;

  //input editing methods
  void appendDigit(String digit) {

    if(shouldClearInput) {
      input = '';
      shouldClearInput = false;
    }
    numberBeingEntered = true;
    input += digit;

    notifyListeners();
  }

  void appendDecimalSeparator() {
    if (!decimalSeparatorEntered) {
      input += '.';
      decimalSeparatorEntered = true;
    }

    shouldClearInput = false;

    notifyListeners();
  }

  void appendOp(String op) {
    input += ' $op';
    numberBeingEntered = false;
    decimalSeparatorEntered = false;

    shouldClearInput = false;

    notifyListeners();
  }

  void clear() {
    input = '';

    numberBeingEntered = false;
    decimalSeparatorEntered = false;

    evenNumberOfParenthesis = true;

    notifyListeners();
  }

  //trim whitespaces then remove single character
  void backspace() {
    if (input == '') {
      return;
    }

    input = input.trimRight();

    var removedChar = input[input.length - 1];

    if (removedChar == '.') {
      decimalSeparatorEntered = false;
    }
    if(removedChar == ')') {
      evenNumberOfParenthesis = false;
    }
    if(removedChar == '(') {
      evenNumberOfParenthesis = true;
    }

    input = input.substring(0, input.length - 1);

    notifyListeners();
  }

  void appendParenthesis() {
    input += evenNumberOfParenthesis ? '(' : ')';
    evenNumberOfParenthesis = !evenNumberOfParenthesis;
    notifyListeners();
  }
}
