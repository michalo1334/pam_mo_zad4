import 'package:mo_zad4/model/ast.dart';
import 'package:petitparser/petitparser.dart';


Parser calcInputParser() {
  final builder = ExpressionBuilder<Expression>();

  builder
    .primitive(
      (
          char('-').optional().map((e) => e ?? '') & digit().plus() & char('.') & digit().plus() |
          char('-').optional().map((e) => e ?? '') & digit().plus() |
          string('Infinity')
      )
          .trim().flatten().map((v) => Value(double.parse(v)))
  );

  builder.group()
    .wrapper(
      char('(').trim(),
      char(')').trim(),
      (l, a, r) => a
  );

  builder.group()
    .right(char('^').trim(), (a, op, b) => BinaryOp(a, b, Op.operator(op)));
  builder.group()
    .left((char('*') | char('/')).trim(), (a, op, b) => BinaryOp(a, b, Op.operator(op)));
  builder.group()
      .left((char('+') | char('-')).trim(), (a, op, b) => BinaryOp(a, b, Op.operator(op)));

  return builder.build().end();
}