import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/models/port_timing_model.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/input_field.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';

class PortTiming extends StatefulWidget {
  const PortTiming({Key? key}) : super(key: key);

  @override
  State<PortTiming> createState() => _PortTimingState();
}

class _PortTimingState extends State<PortTiming> {
  String result = '';
  double? portHeightResult;
  double? portDurationResult;
  bool isPortDuration = false;

  TextEditingController deckHeight = TextEditingController();
  TextEditingController rodLength = TextEditingController();
  TextEditingController stroke = TextEditingController();
  TextEditingController portDuration = TextEditingController();
  TextEditingController portHeight = TextEditingController();

  void clearCalculation() {
    setState(() {
      deckHeight.clear();
      rodLength.clear();
      stroke.clear();
      portDuration.clear();
      portHeight.clear();

      result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculateDeckHeight() {
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

    portHeightResult = double.parse((rod + radius + deck - x).toStringAsFixed(2));

    setState(() {
      result = '${portHeightResult?.toStringAsFixed(2)} mm from deck';
    });
  }

  void calculatePortDuration() {
    if (deckHeight.text == '' || rodLength.text == '' || stroke.text == '' || portHeight.text == '') {
      showToastMessage('All inputs are required!');
      return;
    }

    var deck = double.parse(deckHeight.text);
    var rod = double.parse(rodLength.text);
    var radius = double.parse(stroke.text) / 2;
    var targetPortHeight = double.parse(portHeight.text);

    if (rod < 0 || deck < 0 || radius < 0 || targetPortHeight < 0) {
      showToastMessage('Rod Deck Stroke and Port Height must have positive value!');
      return;
    }

    var x = deck + rod + radius - targetPortHeight;
    var angle = (pow(radius, 2) + pow(x, 2) - pow(rod, 2)) / (2 * radius * x);

    portDurationResult = 180 - (acos(angle) * 180 / pi);

    setState(() {
      result = 'Port Duration: ${portDurationResult?.toStringAsFixed(2)} deg';
    });
  }

  void saveCalculation() {
    if (result == '') {
      showToastMessage('First you have to execute calculation!');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    Storage.prefs?.setString(
      'port',
      jsonEncode(
        PortTimingModel(
          deck: double.parse(deckHeight.text),
          rod: double.parse(rodLength.text),
          stroke: double.parse(stroke.text),
          portHeight: !isPortDuration ? portHeightResult! : double.parse(portHeight.text),
          portDuration: isPortDuration ? portDurationResult! : double.parse(portDuration.text),
        ),
      ),
    );

    showToastMessage('Calculation saved successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: 'Port Height or Duration',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Port Height'),
                const SizedBox(width: 10),
                Switch(
                  value: isPortDuration,
                  activeColor: Colors.deepPurple,
                  onChanged: (bool value) {
                    setState(() {
                      isPortDuration = value;
                      clearCalculation();
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text('Port Duration'),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: PrimaryInputField(
                    textEditor: deckHeight,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Deck Height (mm)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: rodLength,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Rod Length (mm)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            PrimaryInputField(
              textEditor: stroke,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              label: 'Stroke (mm)',
            ),
            const SizedBox(height: 50),
            if (isPortDuration) ...[
              PrimaryInputField(
                textEditor: portHeight,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                label: 'Target Port Height (mm)',
              ),
            ] else ...[
              PrimaryInputField(
                textEditor: portDuration,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                label: 'Target Port Duration (deg)',
              ),
            ],
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PrimaryActionButton(
                  text: 'Clear',
                  action: clearCalculation,
                ),
                const SizedBox(width: 10),
                PrimaryActionButton(
                  text: 'Save',
                  action: saveCalculation,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: PrimaryActionButton(
                text: 'Calculate',
                action: () {
                  if (isPortDuration) {
                    calculatePortDuration();
                  } else {
                    calculateDeckHeight();
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
