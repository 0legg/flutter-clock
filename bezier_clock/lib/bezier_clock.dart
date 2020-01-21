import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import 'bezier_digit.dart';

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

class BezierClock extends StatefulWidget {
  const BezierClock(this.model);

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

  @override
  Widget build(BuildContext context) {
    final theme = _themes[Theme.of(context).brightness];
    final hour =
        widget.model.is24HourFormat ? _dateTime.hour : _dateTime.hour % 12;
    final minute = _dateTime.minute;
    final second = _dateTime.second;

    final progressSeconds = _dateTime.millisecond / 1000;

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
                fromDigit: hour ~/ 10,
                toDigit: hour ~/ 10,
                progress: 0.0,
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: hour % 10,
                toDigit: hour % 10,
                progress: 0.0,
                color: theme[_Element.text],
              ),
              SizedBox(
                width: 100,
              ),
              BezierDigit(
                fromDigit: minute ~/ 10,
                toDigit: minute ~/ 10,
                progress: 0.0,
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: minute % 10,
                toDigit: minute % 10,
                progress: 0.0,
                color: theme[_Element.text],
              ),
              SizedBox(
                width: 100,
              ),
              BezierDigit(
                fromDigit: second ~/ 10,
                toDigit: second ~/ 10,
                progress: 0.0,
                color: theme[_Element.text],
              ),
              BezierDigit(
                fromDigit: second % 10,
                toDigit: (second + 1) % 10,
                progress: progressSeconds,
                color: theme[_Element.text],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
