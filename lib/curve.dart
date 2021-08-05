import 'dart:math';

abstract class Line {
  Point<double> get point1;
  Point<double> get point2;
}

class QuadraticCurve implements Line {
  QuadraticCurve(this.point1, this.handle1, this.point2);

  factory QuadraticCurve.fromList(List<List<double>> list) {
    assert(list.length == 3, 'list should be no more or no less then the length of 4');
    return QuadraticCurve(
      Point(list[0][0], list[0][1]),
      Point(list[1][0], list[1][1]),
      Point(list[2][0], list[2][1]),
    );
  }

  // first point
  @override
  Point<double> point1;
  // first controlpoint
  Point<double> handle1;
  // end points
  @override
  Point<double> point2;

  QuadraticCurve round() => QuadraticCurve(
        point1.round(),
        handle1.round(),
        point2.round(),
      );

  /// Multiplication operator.
  QuadraticCurve operator *(double operand) => QuadraticCurve(point1 * operand, handle1 * operand, point2 * operand);

  /// Division operator.
  QuadraticCurve operator /(double operand) => QuadraticCurve(point1 * operand, handle1 * operand, point2 * operand);
}

typedef Curve = CubicCurve;

class CubicCurve implements Line {
  CubicCurve(this.point1, this.handle1, this.handle2, this.point2);

  factory CubicCurve.fromList(List<List<double>> list) {
    assert(list.length == 4, 'list should be no more or no less then the length of 4');
    return CubicCurve(
      Point(list[0][0], list[0][1]),
      Point(list[1][0], list[1][1]),
      Point(list[2][0], list[2][1]),
      Point(list[3][0], list[3][1]),
    );
  }

  // first point
  @override
  Point<double> point1;
  // first controlpoint
  Point<double> handle1;
  // end controlpoint
  Point<double> handle2;
  // end points
  @override
  Point<double> point2;

  Iterable<QuadraticCurve> toQuadraticCurve() sync* {
    final double x0 = point1.x;
    final double y0 = point1.y;
    final double x1 = handle1.x;
    final double y1 = handle1.y;
    final double x2 = handle2.x;
    final double y2 = handle2.y;
    final double x3 = point2.x;
    final double y3 = point2.y;

    final double x = ((x0 + 3 * x1 + 3 * x2 + x3 + 4) / 8).floorToDouble();
    final double y = ((y0 + 3 * y1 + 3 * y2 + y3 + 4) / 8).floorToDouble();

    yield QuadraticCurve.fromList([
      [x0, y0],
      [
        ((x0 + 3 * x1 + 2) / 4).floorToDouble(),
        ((y0 + 3 * y1 + 2) / 4).floorToDouble(),
      ],
      [x, y],
    ]);

    yield QuadraticCurve.fromList([
      [x, y],
      [
        ((3 * x2 + x3 + 2) / 4).floorToDouble(),
        ((3 * y2 + y3 + 2) / 4).floorToDouble(),
      ],
      [x3, y3]
    ]);
  }

  CubicCurve round() => CubicCurve(
        point1.round(),
        handle1.round(),
        handle2.round(),
        point2.round(),
      );

  /// Multiplication operator.
  CubicCurve operator *(double operand) =>
      CubicCurve(point1 * operand, handle1 * operand, handle2 * operand, point2 * operand);

  /// Division operator.
  CubicCurve operator /(double operand) =>
      CubicCurve(point1 * operand, handle1 * operand, handle2 * operand, point2 * operand);
}

extension _ExtendedPoint on Point<double> {
  Point<double> round() => Point(x.roundToDouble(), y.roundToDouble());
}
