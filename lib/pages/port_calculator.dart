import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/input_field.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';
import 'dart:math';

class PortCalculator extends StatefulWidget {
  const PortCalculator({Key? key}) : super(key: key);

  @override
  State<PortCalculator> createState() => _PortCalculatorState();
}

class _PortCalculatorState extends State<PortCalculator> {
  String result = '';

  TextEditingController deckHeight = TextEditingController();
  TextEditingController rodLength = TextEditingController();
  TextEditingController stroke = TextEditingController();
  TextEditingController portDuration = TextEditingController();

  void clearCalculation() {
    setState(() {
      deckHeight.clear();
      rodLength.clear();
      stroke.clear();
      portDuration.clear();

      result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculate() {
    if (deckHeight.text == '' || rodLength.text == '' || stroke.text == '' || portDuration.text == '') {
      showToastMessage('All inputs are required!');
      return;
    }

    var targetPortDuration = double.parse(portDuration.text);
    if (targetPortDuration < 1 || 359 < targetPortDuration) {
      showToastMessage('Target port duration must be between 1 and 359 degrees!');
      return;
    }

    var deck = double.parse(deckHeight.text);
    var rod = double.parse(rodLength.text);
    var radius = double.parse(stroke.text) / 2;

    if (rod < 0 || deck < 0 || radius < 0) {
      showToastMessage('Rod Deck and Stroke must have positive value!');
      return;
    }

    var degreesFromBdc = targetPortDuration / 2;
    var y = cos(degreesFromBdc * pi / 180) * radius;
    var z = sin(degreesFromBdc * pi / 180) * radius;
    var x = sqrt(pow(rod, 2) - pow(z, 2)) - y;

    setState(() {
      result = '${(rod + radius + deck - x).toStringAsFixed(2)} mm from deck';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: 'Port Height',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            PrimaryInputField(
              textEditor: deckHeight,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              label: 'Deck Height (mm)',
            ),
            const SizedBox(height: 50),
            PrimaryInputField(
              textEditor: rodLength,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              label: 'Rod Length (mm)',
            ),
            const SizedBox(height: 50),
            PrimaryInputField(
              textEditor: stroke,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              label: 'Stroke (mm)',
            ),
            const SizedBox(height: 50),
            PrimaryInputField(
              textEditor: portDuration,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              label: 'Target Port Duration (deg)',
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PrimaryActionButton(
                  text: 'Clear',
                  action: clearCalculation,
                ),
                const SizedBox(width: 10),
                PrimaryActionButton(
                  text: 'Calculate',
                  action: calculate,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
