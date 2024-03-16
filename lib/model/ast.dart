import 'dart:math';

import 'package:flutter/cupertino.dart';

abstract class Expression {
  Expression copy();

  /*
  Duplicate the expression:
  >the leftmost operand is the the wrappee expression
  >the rest of the operands are copied as-is

  For example:
  -2 => -(-2)
  2 + 3 => (2 + 3) + 3
  sin(5 + 6) => sin(sin(5+6))
  twoArgFunction(5 + 9, 3.14) => twoArgFunction(twoArgFunction(5+9, 3.14), 3.14)
   */
  Expression repeatedLeftMost();

  /*
  Simplify the leftmost side of the expression - reduce it to a single value

  For example:
  -2 => -2

  (2 + 3) + 3 => 6 + 3
  sin(5 + 6) => sin(11)
  twoArgFunction(5 + 9, 3.14) => twoArgFunction(twoArgFunction(5+9, 3.14).eval(), 3.14)
   */
  Expression simplifiedLeftMost();

  /*
  Evaluate the expression - return double
   */
  double eval();

  @override
  String toString();

  String prettyPrint();
}

class Value extends Expression {
  final double value;

  Value(this.value);

  @override
  Expression copy() => Value(value);

  @override
  Expression repeatedLeftMost() {
    return this;
  }

  @override
  Expression simplifiedLeftMost() {
    return this;
  }

  @override
  double eval() => value;

  @override
  String toString() => 'Value(${value.toString()})';

  @override
  String prettyPrint() => value.toString();
}

class UnaryOp extends Expression {
  final Expression expr;
  final Op op;

  UnaryOp(this.expr, this.op);

  @override
  Expression copy() => UnaryOp(expr.copy(), op);

  @override
  Expression repeatedLeftMost() {
    return UnaryOp(this, op);
  }

  @override
  Expression simplifiedLeftMost() {
    return UnaryOp(Value(expr.eval()), op);
  }

  @override
  double eval() => op.invoke([expr.eval()]);

  @override
  String toString() => '${op.name}${expr.toString()}';

  @override
  String prettyPrint() => toString();
}

class BinaryOp extends Expression {
  final Expression lhs;
  final Expression rhs;
  final Op op;

  BinaryOp(this.lhs, this.rhs, this.op);

  @override
  Expression copy() => BinaryOp(lhs.copy(), rhs.copy(), op);

  @override
  Expression repeatedLeftMost() {
    return BinaryOp(this, rhs, op);
  }

  @override
  Expression simplifiedLeftMost() {
    return BinaryOp(Value(lhs.eval()), rhs, op);
  }

  @override
  double eval() => op.invoke([lhs.eval(), rhs.eval()]);

  @override
  String toString() => '(${lhs.toString()} ${op.name} ${rhs.toString()})';

  @override
  String prettyPrint() =>
      '(${lhs.prettyPrint()} ${op.name} ${rhs.prettyPrint()})';
}

class FunctionExpr extends Expression {
  final List<Expression> args;
  final Op op;

  FunctionExpr(this.args, this.op);

  @override
  Expression copy() => FunctionExpr(args.map((e) => e.copy()).toList(), op);

  @override
  Expression repeatedLeftMost() {
    return FunctionExpr([copy(), ...args]..removeAt(1), op);
  }

  @override
  Expression simplifiedLeftMost() {
    return FunctionExpr(args.map((e) => Value(e.eval())).toList(), op);
  }

  @override
  double eval() => op.invoke(args.map((e) => e.eval()).toList());

  @override
  String toString() =>
      '${op.name}(${args.map((e) => e.toString()).join(', ')})';

  @override
  String prettyPrint() =>
      '${op.name}(${args.map((e) => e.prettyPrint()).join(', ')})';
}

class Op {
  final String name;
  late final Function op;
  late final int arity;

  Op(this.name, this.op, this.arity);

  Op.operator(String char)
      : name = char,
        arity = 2 {
    op = switch (char) {
      '+' => (args) => args[0] + args[1],
      '-' => (args) => args[0] - args[1],
      '*' => (args) => args[0] * args[1],
      '/' => (args) => args[0] / args[1],
      '^' => (args) => pow(args[0], args[1]),
      _ => (args) => throw UnimplementedError(),
    };
  }

  Op.function(String fnName)
    : name = fnName {
    switch(fnName) {
      case "sqrt(":
        op = (args) => sqrt(args[0]);
        arity = 1;
      case _:
        throw UnimplementedError();
    }
  }


  double invoke(List<double> args) => op(args);
}
