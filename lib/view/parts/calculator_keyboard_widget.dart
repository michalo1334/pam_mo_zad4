import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../model/calculator.dart';
import 'calculator_button_widget.dart';

class CalculatorKeyboardWidget extends StatefulWidget {
  final Calculator initCalc;

  const CalculatorKeyboardWidget({super.key, required this.initCalc});

  @override
  State<CalculatorKeyboardWidget> createState() =>
      _CalculatorKeyboardWidgetState();
}

class _CalculatorKeyboardWidgetState extends State<CalculatorKeyboardWidget> {
  late final Calculator _calc;

  final String gridTemplate = """
      C   ()   X^a    /
      7   8     9     x
      4   5     6     -
      1   2     3     +
      +/- 0     .     =
      r2 r8     r10   r16
      """;

  late final Map<String, void Function()> _buttonOps;

  void _initButtonOps() {
    _buttonOps = {
      "C": () => setState(() {
            _calc.clear();
          }),
      "()": () => setState(() {
            _calc.appendParenthesis();
          }),
      "X^a": () => setState(() {
            _calc.appendOp("^");
          }),
      "/": () => setState(() {
            _calc.appendOp("/");
          }),
      "7": () => setState(() {
            _calc.appendDigit("7");
          }),
      "8": () => setState(() {
            _calc.appendDigit("8");
          }),
      "9": () => setState(() {
            _calc.appendDigit("9");
          }),
      "x": () => setState(() {
            _calc.appendOp("*");
          }),
      "4": () => setState(() {
            _calc.appendDigit("4");
          }),
      "5": () => setState(() {
            _calc.appendDigit("5");
          }),
      "6": () => setState(() {
            _calc.appendDigit("6");
          }),
      "-": () => setState(() {
            _calc.appendOp("-");
          }),
      "1": () => setState(() {
            _calc.appendDigit("1");
          }),
      "2": () => setState(() {
            _calc.appendDigit("2");
          }),
      "3": () => setState(() {
            _calc.appendDigit("3");
          }),
      "+": () => setState(() {
            _calc.appendOp("+");
          }),
      "+/-": () => setState(() {}),
      "0": () => setState(() {
            _calc.appendDigit("0");
          }),
      ".": () => setState(() {
            _calc.appendDecimalSeparator();
          }),
      "=": () => setState(() {_calc.accept();}),
      "r2": () => setState(() {_calc.currentRadix = 2;}),
      "r8": () => setState(() {_calc.currentRadix = 8;}),
      "r10": () => setState(() {_calc.currentRadix = 10;}),
      "r16": () => setState(() {_calc.currentRadix = 16;}),
    };
  }

  @override
  void initState() {
    _calc = widget.initCalc;
    _initButtonOps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: LayoutGrid(
            columnSizes: [for (var i = 0; i < 4; i++) 1.fr],
            rowSizes: [for (var i = 0; i < 6; i++) 1.fr],
            children: _buildButtons(context)));
  }

  List<Widget> _buildButtons(BuildContext context) {
    return _buttonOps.keys.map((name) {
      var (bc, tc) = _themeForButtonNamed(name, context);

      return CalculatorButtonWidget(
          text: name,
          textColor: tc,
          backgroundColor: bc,
          onPressed: _buttonOps[name]!);
    }).toList();
  }

  (Color, Color) _themeForButtonNamed(String name, BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    return switch (name) {
      "r2" || "r8" || "r10" || "r16" when 'r${_calc.currentRadix.toString()}' == name => (Colors.green, cs.onSecondary),
      "r2" || "r8" || "r10" || "r16" => (cs.secondary, cs.onSecondary),
      "+" || "-" || "x" || "/" => (cs.inversePrimary, Colors.purple),
      "C" => (cs.inversePrimary, Colors.red),
      "=" => (cs.primary, cs.onPrimary),
      _ => (cs.inversePrimary, Colors.black)
    };
  }
}
