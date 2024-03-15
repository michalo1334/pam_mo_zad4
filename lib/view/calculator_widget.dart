import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:mo_zad4/model/calculator.dart';
import 'package:mo_zad4/view/parts/calculator_history_widget.dart';

import 'parts/calculator_keyboard_widget.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key, required this.initCalc});

  final Calculator initCalc;

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  late final Calculator _calc;

  final String gridTemplateSmallLayout =
    """
    display
    keyboard
    """;

  final String gridTemplateLargeLayout =
    """
    display display
    history keyboard 
    """;

  late final TextEditingController _inputTextController =
      TextEditingController();

  bool _currentlyShownHistoryOverKeyboard = false;

  bool get _showHistoryButton => MediaQuery.of(context).size.width < 700;

  @override
  void initState() {
    _calc = widget.initCalc;
    super.initState();

    _calc.addListener(() {
      _inputTextController.text = _calc.input;
    });

    _calc.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: MediaQuery.of(context).size.width < 700 ? _buildSmallLayout() : _buildLargeLayout()
    );
  }

  Widget _buildSmallLayout() {
    return LayoutGrid(
      areas: gridTemplateSmallLayout,
      columnSizes: [1.fr],
      rowSizes: [
        1.fr,
        2.fr,
      ],
      children: [
        _buildDisplay().inGridArea("display"),
        _buildKeyboard().inGridArea("keyboard"),
      ],
    );
  }

  /*
  display display
  pane    keyboard
   */
  Widget _buildLargeLayout() {
    return LayoutGrid(
      areas: gridTemplateLargeLayout,
      columnSizes: [1.fr, 1.fr],
      rowSizes: [
        1.fr,
        2.fr,
      ],
      children: [
        _buildDisplay().inGridArea("display"),
        _buildKeyboard().inGridArea("keyboard"),
        _buildHistory().inGridArea("history"),
      ],
    );
  }

  Widget _buildHistory() {
    return Align(alignment: Alignment.centerLeft, child: Container(color: Colors.white, child: CalculatorHistoryWidget(initCalc: _calc)));
  }

  Widget _buildDisplay() {
    return Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 2),
        )),
        child: Column(
          children: [
            _buildDisplayInputText(),
            _buildDisplayResultText(),
            _buildDisplayButtons(),
          ],
        ));
  }

  Widget _buildDisplayInputText() {
    return Align(
      alignment: Alignment.topRight,
      child: TextField(
          autofocus: true,
          decoration: null,
          controller: _inputTextController,
          onChanged: (value) => setState(() {
                _calc.input = value;
              }),
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 28,
          )),
    );
  }

  Widget _buildDisplayResultText() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(_calc.parsedInputExprValueString,
          style: const TextStyle(
            fontSize: 16,
          )),
    );
  }

  Widget _buildDisplayButtons() {
    var historyButton = IconButton(onPressed: () {setState(() {
      _currentlyShownHistoryOverKeyboard = !_currentlyShownHistoryOverKeyboard;
    });}, icon: Icon(Icons.history, color: _currentlyShownHistoryOverKeyboard ? Colors.green : null));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _showHistoryButton ? historyButton : Container(),
        IconButton(
            onPressed: () {
              setState(() {
                _calc.backspace();
              });
            },
            icon: const Icon(Icons.backspace)),
      ],
    );
  }

  Widget _buildKeyboard() {
    var children = <Widget>[];
    children.add(CalculatorKeyboardWidget(initCalc: _calc));
    if(_currentlyShownHistoryOverKeyboard && _showHistoryButton) children.add(_buildHistory());

    return Align(alignment: Alignment.centerRight, child: Stack(children: children));
  }

  void _update() {
    setState((){/* The input text has changed */});
  }
}

enum LayoutType {
  small, //smartphones in portrait mode
  large, //tablets, PCs, smartphones in landscape mode etc
}
