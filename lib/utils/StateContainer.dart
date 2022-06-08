import 'package:flutter/material.dart';

class StateContainer extends StatefulWidget {
  final Widget child;
  final String mpBalc;
  final String qrBalc;
  final String welBalc;

  const StateContainer(
      {Key? key, required this.child, this.mpBalc = '', this.qrBalc = '', this.welBalc = ''})
      : super(key: key);
  static final navigatorKey = new GlobalKey<NavigatorState>();

  static _StateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedContainer>()
            as InheritedContainer)
        .data;
  }

  @override
  _StateContainerState createState() => _StateContainerState();
}

class _StateContainerState extends State<StateContainer> {
  String mpBalc = "0";
  String qrBalc = "0";
  String welBalc = "0";

  void updateMPBalc({value}) {
    if (value == null || value.toString() == "null") {
      setState(() {
        mpBalc = "0";
      });
    } else {
      setState(() {
        mpBalc = value;
      });
    }
  }

  void updateQRBalc({value}) {
    if (value == null || value.toString() == "null") {
      setState(() {
        qrBalc = "0";
      });
    } else {
      setState(() {
        qrBalc = value;
      });
    }
  }

  void updateWelBalc({value}) {
    if (value == null || value.toString() == "null") {
      setState(() {
        welBalc = "0";
      });
    } else {
      setState(() {
        welBalc = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedContainer(
      data: this,
      child: widget.child,
    );
  }
}

class InheritedContainer extends InheritedWidget {
  final _StateContainerState data;

  InheritedContainer({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedContainer oldWidget) {
    return true;
  }
}
