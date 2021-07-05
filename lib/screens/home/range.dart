import 'package:flutter/material.dart';

class RangeWidget extends StatefulWidget {
  final String currentRange;
  final Function notify;

  const RangeWidget({Key key, this.currentRange, this.notify})
      : super(key: key);

  @override
  _RangeWidgetState createState() => _RangeWidgetState();
}

class _RangeWidgetState extends State<RangeWidget> {
  String rangeModifier(double value) {
    value = (value / 5).round().toDouble() * 5;
    final roundedValue = value.ceil().toInt().toString();
    return roundedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Search range:",
              style: Theme.of(context).textTheme.headline5,
            ),
            widget.currentRange != null
                ? Text("${rangeModifier(double.parse(widget.currentRange))} km",
                    style: Theme.of(context).textTheme.headline5)
                : Text("15 km", style: Theme.of(context).textTheme.headline5),
          ],
        ),
      ),
    );
  }
}
