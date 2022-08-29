import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/input_field.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';
import 'dart:math';

class CompressionRatioCalculator extends StatefulWidget {
  const CompressionRatioCalculator({Key? key}) : super(key: key);

  @override
  State<CompressionRatioCalculator> createState() => _CompressionRatioCalculatorState();
}

class _CompressionRatioCalculatorState extends State<CompressionRatioCalculator> {
  String result = '';

  TextEditingController head = TextEditingController();
  TextEditingController deck = TextEditingController();
  TextEditingController gasket = TextEditingController();
  TextEditingController piston = TextEditingController();
  TextEditingController bore = TextEditingController();
  TextEditingController stroke = TextEditingController();

  void clearCalculation() {
    setState(() {
      head.clear();
      deck.clear();
      gasket.clear();
      piston.clear();
      bore.clear();
      stroke.clear();

      result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculate() {
    if (head.text == '' ||
        deck.text == '' ||
        gasket.text == '' ||
        piston.text == '' ||
        bore.text == '' ||
        stroke.text == '') {
      showToastMessage('All inputs are required!');
      return;
    }

    var headVolume = double.parse(head.text);
    var deckHeight = double.parse(deck.text) / 10;
    var gasketHeight = double.parse(gasket.text) / 10;
    var pistonVolume = double.parse(piston.text);
    var boreSize = double.parse(bore.text) / 10;
    var strokeLength = double.parse(stroke.text) / 10;

    var boreArea = pi * boreSize * boreSize / 4;
    var gasketVolume = boreArea * gasketHeight;
    var deckVolume = boreArea * deckHeight;
    var cylinderVolume = boreArea * strokeLength;
    var chamberVolume = headVolume + pistonVolume + gasketVolume + deckVolume;
    var compressionRatio = (chamberVolume + cylinderVolume) / chamberVolume;

    var text = 'Displacement: ${cylinderVolume.toStringAsFixed(2)} cm3\n';
    text += 'Static Compression Ratio: ${compressionRatio.toStringAsFixed(2)}:1';

    setState(() {
      result = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: 'Compression Ratio',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryInputField(
                    textEditor: head,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Head (cm3)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: deck,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Deck (mm)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: PrimaryInputField(
                    textEditor: gasket,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Gasket (mm)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: piston,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Piston (cm3)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: PrimaryInputField(
                    textEditor: bore,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Bore (mm)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: stroke,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    label: 'Stroke (mm)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 18,
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
