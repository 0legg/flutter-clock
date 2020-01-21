import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'bezier_digit.dart';
import 'sequence_tween.dart';

enum _Element {
  background,
  text,
}

final _themes = {
  Brightness.light: {
    _Element.background: Colors.white,
    _Element.text: Colors.black,
  },
  Brightness.dark: {
    _Element.background: Colors.black,
    _Element.text: Colors.white,
  },
};

final _secondTensLength = 2.0;
final _minuteUnitLength = 5.0;
final _minuteTensLength = 5.0;
final _hourUnitLength = 5.0;
final _hourTensLength = 5.0;
final _defaultTween = CurveTween(curve: Curves.easeInOut);

final _secondUnitTween = _defaultTween;
final _secondTensTween = SequenceTween(
  first: ConstantTween<double>(0.0),
  firstLength: 10.0 - _secondTensLength,
  second: _defaultTween,
  secondLength: _secondTensLength,
);
final _minuteUnitTween = SequenceTween(
  first: ConstantTween<double>(0.0),
  firstLength: 60.0 - _minuteUnitLength,
  second: _defaultTween,
  secondLength: _minuteUnitLength,
);
final _minuteTensTween = SequenceTween(
  first: ConstantTween<double>(0.0),
  firstLength: 600.0 - _minuteTensLength,
  second: _defaultTween,
  secondLength: _minuteTensLength,
);
final _hourUnitTween = SequenceTween(
  first: ConstantTween<double>(0.0),
  firstLength: 3600.0 - _hourUnitLength,
  second: _defaultTween,
  secondLength: _hourUnitLength,
);
final _hourTensTween = SequenceTween(
  first: ConstantTween<double>(0.0),
  firstLength: 36000.0 - _hourTensLength,
  second: _defaultTween,
  secondLength: _hourTensLength,
);

class BezierClock extends StatefulWidget {
  BezierClock(this.model);

  final ClockModel model;

  @override
  _BezierClockState createState() => _BezierClockState();
}

class _BezierClockState extends State<BezierClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(BezierClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(milliseconds: 16),
        _updateTime,
      );
    });
  }

  int _convertHour(int rawHour, bool is24HourFormat) {
    if (is24HourFormat) {
      return rawHour % 24;
    } else {
      final cutHour = rawHour % 12;
      return cutHour == 0 ? 12 : cutHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[Theme.of(context).brightness];
    final is24Hours = widget.model.is24HourFormat;
    final hour = _convertHour(_dateTime.hour, is24Hours);
    final hourTens = hour ~/ 10;
    final nextHourTens = _convertHour(hour + 1, is24Hours) ~/ 10;
    final hourUnits = hour % 10;
    final nextHourUnits = _convertHour(hour + 1, is24Hours) % 10;
    final minuteTens = _dateTime.minute ~/ 10;
    final minuteUnits = _dateTime.minute % 10;
    final secondTens = _dateTime.second ~/ 10;
    final secondUnits = _dateTime.second % 10;

    final secondsUnitsProgress = _dateTime.millisecond / 1000;
    final secondsTensProgress = (secondUnits + secondsUnitsProgress) / 10;
    final minuteUnitsProgress = (secondTens + secondsTensProgress) / 6;
    final minuteTensProgress = (minuteUnits + minuteUnitsProgress) / 10;
    final hourUnitsProgress = (minuteTens + minuteTensProgress) / 6;
    final hourTensProgress = nextHourTens == 0
        ? (hourUnits + hourUnitsProgress) / (is24Hours ? 4 : 2)
        : (hourUnits + hourUnitsProgress) / 10;

    return Container(
      color: theme[_Element.background],
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BezierDigit(
                fromDigit: hourTens,
                toDigit: nextHourTens,
                progress: _hourTensTween.transform(hourTensProgress),
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: hourUnits,
                toDigit: nextHourUnits,
                progress: _hourUnitTween.transform(hourUnitsProgress),
                color: theme[_Element.text],
              ),
              SizedBox(
                width: 100,
              ),
              BezierDigit(
                fromDigit: minuteTens,
                toDigit: (minuteTens + 1) % 6,
                progress: _minuteTensTween.transform(minuteTensProgress),
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: minuteUnits,
                toDigit: (minuteUnits + 1) % 10,
                progress: _minuteUnitTween.transform(minuteUnitsProgress),
                color: theme[_Element.text],
              ),
              SizedBox(
                width: 100,
              ),
              BezierDigit(
                fromDigit: secondTens,
                toDigit: (secondTens + 1) % 6,
                progress: _secondTensTween.transform(secondsTensProgress),
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: secondUnits,
                toDigit: (secondUnits + 1) % 10,
                progress: _secondUnitTween.transform(secondsUnitsProgress),
                color: theme[_Element.text],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
