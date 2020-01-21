import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[Theme.of(context).brightness];
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: theme[_Element.text],
      fontSize: fontSize,
    );

    return Container(
      color: theme[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(left: offset, top: 0, child: Text(hour)),
              Positioned(right: offset, bottom: offset, child: Text(minute)),
            ],
          ),
        ),
      ),
    );
  }
}
