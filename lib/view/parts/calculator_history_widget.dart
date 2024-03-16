import 'package:flutter/material.dart';

import '../../model/ast.dart';
import '../../model/calculator.dart';

class CalculatorHistoryWidget extends StatefulWidget {
  final Calculator initCalc;

  const CalculatorHistoryWidget({super.key, required this.initCalc});

  @override
  State<CalculatorHistoryWidget> createState() =>
      _CalculatorHistoryWidgetState();
}

class _CalculatorHistoryWidgetState extends State<CalculatorHistoryWidget> {
  late final Calculator _calc;

  @override
  void initState() {
    _calc = widget.initCalc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: _calc.history.reversed.map((e) => _buildListTile(e)).toList()
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => setState(() => _calc.history.clear()), child: const Text("Usuń historię", style: TextStyle(fontSize: 24)))),
        ],
      ),
    );
  }

  Widget _buildListTile(Expression each) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {setState(() {
          _calc.input = each.prettyPrint();
        });},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(each.prettyPrint(), style: const TextStyle(fontSize: 24),),
            Text('= ${each.eval().toString()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),)
          ],
        ),
      ),
    );
  }
}
