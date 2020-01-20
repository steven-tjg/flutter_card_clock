import 'dart:async';

import 'package:card_clock/styles/variables.dart';
import 'package:card_clock/utils.dart';
import 'package:card_clock/widgets/CardText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'package:intl/intl.dart';

class CardClock extends StatefulWidget {
  const CardClock(this.model);

  final ClockModel model;

  @override
  _CardClockState createState() {
    return _CardClockState();
  }
}

class _CardClockState extends State<CardClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  WeatherCondition _weatherCondition;
  Timer _timer;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
        }
      });

    _updateTime();
    _updateModel();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _weatherCondition = widget.model.weatherCondition;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  @override
  void didUpdateWidget(CardClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateTime() {
    _animationController.forward();
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  Map<_Element, Color> getColors(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        switch (_weatherCondition) {
          case WeatherCondition.sunny:
            return _lightSunnyTheme;
          case WeatherCondition.cloudy:
            return _lightCloudyTheme;
          case WeatherCondition.foggy:
            return _lightFoggyTheme;
          case WeatherCondition.rainy:
            return _lightRainyTheme;
          case WeatherCondition.snowy:
            return _lightSnowyTheme;
          case WeatherCondition.thunderstorm:
            return _lightThunderStromTheme;
          case WeatherCondition.windy:
            return _lightWindyTheme;
          default:
            return _lightTheme;
        }
        break;
      case Brightness.dark:
        switch (_weatherCondition) {
          case WeatherCondition.sunny:
            return _darkSunnyTheme;
          case WeatherCondition.cloudy:
            return _darkCloudyTheme;
          case WeatherCondition.foggy:
            return _darkFoggyTheme;
          case WeatherCondition.rainy:
            return _darkRainyTheme;
          case WeatherCondition.snowy:
            return _darkSnowyTheme;
          case WeatherCondition.thunderstorm:
            return _darkThunderStromTheme;
          case WeatherCondition.windy:
            return _darkWindyTheme;
          default:
            return _darkTheme;
        }
        break;
      default:
        return _lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = getColors(Theme.of(context).brightness);
    final is24HourFormat = widget.model.is24HourFormat;

    final date = DateFormat('EEE, MMM d, ' 'yy').format(_dateTime);
    final timeMarker = DateFormat('a').format(_dateTime);

    final hour = DateFormat(is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final hourDigit1 = hour.substring(0, 1);
    final hourDigit2 = hour.substring(1, 2);

    final minute = DateFormat('mm').format(_dateTime);
    final minuteDigit1 = minute.substring(0, 1);
    final minuteDigit2 = minute.substring(1, 2);

    final TextStyle textStyle = TextStyle(
      color: colors[_Element.text],
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(3, 0),
        ),
      ],
    );

    final TextStyle textStyleInfo = TextStyle(
      color: colors[_Element.text],
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: colors[_Element.background],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CardText(
                      color: colors[_Element.card],
                      text: Text(
                        hourDigit1,
                        style: textStyle.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.15,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth * 0.175,
                      height: constraints.maxWidth * 0.225,
                    ),
                    boxWidthXS,
                    CardText(
                      color: colors[_Element.card],
                      text: Text(
                        hourDigit2,
                        style: textStyle.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.15,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth * 0.175,
                      height: constraints.maxWidth * 0.225,
                    ),
                    boxWidthXS,
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _animation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: colors[_Element.text],
                            borderRadius: BorderRadiusDirectional.circular(50)),
                        width: constraints.maxWidth * 0.04,
                        height: constraints.maxWidth * 0.04,
                      ),
                    ),
                    boxWidthXS,
                    CardText(
                      color: colors[_Element.card],
                      text: Text(
                        minuteDigit1,
                        style: textStyle.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.15,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth * 0.175,
                      height: constraints.maxWidth * 0.225,
                    ),
                    boxWidthXS,
                    CardText(
                      color: colors[_Element.card],
                      text: Text(
                        minuteDigit2,
                        style: textStyle.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.15,
                          ),
                        ),
                      ),
                      width: constraints.maxWidth * 0.175,
                      height: constraints.maxWidth * 0.225,
                    ),
                    Offstage(
                      offstage: is24HourFormat,
                      child: boxWidthXS,
                    ),
                    Offstage(
                      offstage: is24HourFormat,
                      child: CardText(
                        color: colors[_Element.card],
                        text: Text(
                          timeMarker,
                          style: textStyle.merge(
                            TextStyle(
                              fontSize: constraints.maxWidth * 0.05,
                            ),
                          ),
                        ),
                        width: constraints.maxWidth * 0.1,
                        height: constraints.maxWidth * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.room,
                            color: colors[_Element.text],
                            size: constraints.maxWidth * 0.05,
                          ),
                          boxWidthXS,
                          Text(
                            _location,
                            style: textStyleInfo.merge(
                              TextStyle(
                                fontSize: constraints.maxWidth * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                      boxHeightS,
                      Text(
                        capitalize(_condition) +
                            " ," +
                            _temperature +
                            " " +
                            _temperatureRange,
                        style: textStyleInfo.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.today,
                        color: colors[_Element.text],
                        size: constraints.maxWidth * 0.05,
                      ),
                      boxWidthXS,
                      Text(
                        date,
                        style: textStyleInfo.merge(
                          TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _Element {
  background,
  text,
  shadow,
  card,
}

final _lightTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorPurple,
};

final _darkTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorPurpleDark,
};

final _lightCloudyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorBlue
};

final _darkCloudyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorBlueDark,
};

final _lightSunnyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorYellow
};

final _darkSunnyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorYellowDark,
};

final _lightFoggyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorBlueGrey
};

final _darkFoggyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorBlueGreyDark,
};

final _lightWindyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorGreen
};

final _darkWindyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorGreenDark,
};

final _lightRainyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorIndingo
};

final _darkRainyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorIndingoDark,
};

final _lightSnowyTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorCyan
};

final _darkSnowyTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorCyanDark,
};

final _lightThunderStromTheme = {
  _Element.background: colorWhite,
  _Element.text: colorBlack,
  _Element.shadow: Colors.transparent,
  _Element.card: colorTeal
};

final _darkThunderStromTheme = {
  _Element.background: colorBlack,
  _Element.text: colorWhite,
  _Element.shadow: colorBlack,
  _Element.card: colorTealDark,
};
