import 'package:flutter/material.dart';
import 'package:gradual_stepper/gradual_stepper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

void main() => runApp(MyApp());

class Currency {
  String iso;
  int subUnitToUnit;
  String symbol;
  String disambiguateSymbol;

  Currency(this.iso, this.subUnitToUnit, this.symbol, this.disambiguateSymbol);
}

class Money {
  String iso;
  int subUnits;

  Money(this.iso, this.subUnits);

  Money.money();

  factory Money.initializeWithIso(String iso) => Money(iso, 0);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradual Stepper Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State {
  double _lowerValue = 0;
  Money amount;
  double step = 0;
  double min = 0;
  double max = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _lowerValue = 10;
    _step();
    _max();
    _min();
    _setValue();
  }

  void _step() {
    step = 50 / currencies['BRL'].subUnitToUnit;
  }

  void _max() {
    max = 5000 / currencies['BRL'].subUnitToUnit;
  }

  void _min() {
    min = 1000 / currencies['BRL'].subUnitToUnit;
  }

  void _setValue() {
    var value = _lowerValue * currencies['BRL'].subUnitToUnit;
    amount = Money('BRL', value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: GradualStepper(
            initialValue: _lowerValue,
            minimumValue: min,
            maximumValue: max,
            displayValue: amount.formatIso,
            stepValue: step,
            counterTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600),
            onChanged: (value) {
              _lowerValue = value;
              _setValue();
              setState(() {});
            },
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Map<String, Currency> currencies = {
  'COP': Currency("COP", 100, "\$", "COL\$"),
  'PEN': Currency("PEN", 100, "S/", "S/"),
  'MXN': Currency("MXN", 100, "\$", "MEX\$"),
  'ARS': Currency("ARS", 100, "\$", "ARS\$"),
  'BTC': Currency("BTC", 100000000, "\u20BF", null),
  'CLP': Currency("CLP", 1, "\$", "CLP"),
  'BRL': Currency("BRL", 100, "R\$", "R\$"),
  'GTQ': Currency("GTQ", 100, "Q", "Q"),
  'USD': Currency("USD", 100, "\$", "US\$"),
  'UYU': Currency("UYU", 100, "\$", "\$"),
  'PYG': Currency("PYG", 1, "₲", "₲"),
  'BOB': Currency("BOB", 100, "Bs", "Bs")
};

extension Format on Money {
  String get formatSymbol {
    var currency = currencies[iso];
    return units.toCurrencyString(trailingSymbol: ' ${currency.symbol}');
  }

  String get formatIso {
    var currency = currencies[iso];
    return units.toCurrencyString(trailingSymbol: ' ${currency.iso}');
  }

  double get units {
    var currency = currencies[iso];
    if (subUnits != null) {
      return subUnits / currency.subUnitToUnit;
    } else {
      return 0.0;
    }
  }

  String format() {
    var currency = currencies[iso];
    var format = NumberFormat.currency(
        decimalDigits: 0,
        symbol: currency.symbol,
        customPattern: "\$ #,##0.00");
    return format.format(subUnits / currency.subUnitToUnit);
  }

  String formatWithIso() => "${format()} $iso".trim();

  int formatWithoutDecimals() {
    var currency = currencies[iso];
    return subUnits ~/ currency.subUnitToUnit;
  }

  int formatAddDecimals(int newValueSubUnits) {
    var currency = currencies[iso];
    return newValueSubUnits * currency.subUnitToUnit;
  }
}
