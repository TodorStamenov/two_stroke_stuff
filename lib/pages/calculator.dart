import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String result = '';

  TextEditingController deckHeight = TextEditingController();
  TextEditingController rodLength = TextEditingController();
  TextEditingController stroke = TextEditingController();
  TextEditingController portDuration = TextEditingController();

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }

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

    double targetPortDuration = double.parse(portDuration.text);
    if (targetPortDuration < 1 || 359 < targetPortDuration) {
      showToastMessage('Target port duration must be between 1 and 359 degrees!');
      return;
    }

    double deck = double.parse(deckHeight.text);
    double rod = double.parse(rodLength.text);
    double radius = double.parse(stroke.text) / 2;

    if (rod < 0 || deck < 0 || radius < 0) {
      showToastMessage('Rod Deck and Stroke must have positive value!');
      return;
    }

    double degreesFromBdc = targetPortDuration / 2;
    double y = cos(degreesFromBdc * pi / 180) * radius;
    double z = sin(degreesFromBdc * pi / 180) * radius;
    double x = sqrt(pow(rod, 2) - pow(z, 2)) - y;

    setState(() {
      result = '${(rod + radius + deck - x).toStringAsFixed(2)} mm from deck';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Calculate Port Height',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: deckHeight,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Deck Height (mm)',
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: rodLength,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Rod Length (mm)',
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: stroke,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Stroke (mm)',
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: portDuration,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Target Port Duration (deg)',
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
            ],
          ),
        ),
      ),
    );
  }
}
