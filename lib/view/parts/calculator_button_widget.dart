import 'dart:math';

import 'package:flutter/material.dart';

class CalculatorButtonWidget extends StatelessWidget {
  const CalculatorButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;

  final String text;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: onPressed,
          splashColor: Theme.of(context).splashColor,
          borderRadius: BorderRadius.circular(100),
          child: _buildText(),
        ),
      ),
    );
  }

  Widget _buildText() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var fontSize = min(constraints.biggest.height, constraints.biggest.width) / 2;
        return Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold
            ),
            maxLines: 1,
          ),
        );
      }
    );
  }
}
