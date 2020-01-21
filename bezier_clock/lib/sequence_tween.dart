import 'package:flutter/material.dart';

/// Tween subclass interpolating [first] animatable during [firstLength] part,
/// and [second] animatable during [secondLength] part
class SequenceTween extends Tween<double> {
  SequenceTween({
    @required this.first,
    @required this.second,
    @required this.firstLength,
    @required this.secondLength,
  })  : assert(first != null),
        assert(second != null),
        assert(firstLength != null),
        assert(firstLength > 0),
        assert(secondLength != null),
        assert(secondLength > 0);

  Animatable<double> first;
  Animatable<double> second;
  double firstLength;
  double secondLength;

  @override
  double transform(double t) {
    final totalLength = firstLength + secondLength;
    if (t * totalLength <= firstLength) {
      return first.transform(t * totalLength / firstLength);
    } else {
      return second.transform((t * totalLength - firstLength) / secondLength);
    }
  }
}
