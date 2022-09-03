import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_stroke_stuff/bloc/compression/compression_bloc.dart';
import 'package:two_stroke_stuff/models/compression_ratio_model.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/input_field.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';

class CompressionRatio extends StatefulWidget {
  const CompressionRatio({Key? key}) : super(key: key);

  @override
  State<CompressionRatio> createState() => _CompressionRatioState();
}

class _CompressionRatioState extends State<CompressionRatio> {
  double? _volume;
  double? _compressionRatio;
  String _result = '';

  final TextEditingController _head = TextEditingController();
  final TextEditingController _deck = TextEditingController();
  final TextEditingController _gasket = TextEditingController();
  final TextEditingController _piston = TextEditingController();
  final TextEditingController _bore = TextEditingController();
  final TextEditingController _stroke = TextEditingController();

  @override
  void didChangeDependencies() {
    final state = BlocProvider.of<CompressionBloc>(context).state;
    if (state is CompressionLoaded) {
      final compression = state.compressionRatio;

      _head.text = compression.head.toString();
      _deck.text = compression.deck.toString();
      _gasket.text = compression.gasket.toString();
      _piston.text = compression.piston.toString();
      _bore.text = compression.bore.toString();
      _stroke.text = compression.stroke.toString();
    }

    super.didChangeDependencies();
  }

  void clearCalculation() {
    setState(() {
      _head.clear();
      _deck.clear();
      _gasket.clear();
      _piston.clear();
      _bore.clear();
      _stroke.clear();

      _result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculate() {
    if (_head.text == '' ||
        _deck.text == '' ||
        _gasket.text == '' ||
        _piston.text == '' ||
        _bore.text == '' ||
        _stroke.text == '') {
      showToastMessage('All inputs are required!');
      return;
    }

    final headVolume = double.parse(_head.text);
    final deckHeight = double.parse(_deck.text) / 10;
    final gasketHeight = double.parse(_gasket.text) / 10;
    final pistonVolume = double.parse(_piston.text);
    final boreSize = double.parse(_bore.text) / 10;
    final strokeLength = double.parse(_stroke.text) / 10;

    final boreArea = pi * boreSize * boreSize / 4;
    final gasketVolume = boreArea * gasketHeight;
    final deckVolume = boreArea * deckHeight;
    final cylinderVolume = boreArea * strokeLength;
    final chamberVolume = headVolume + pistonVolume + gasketVolume + deckVolume;
    final compressionRatio = (chamberVolume + cylinderVolume) / chamberVolume;

    _volume = double.parse(cylinderVolume.toStringAsFixed(2));
    _compressionRatio = double.parse(compressionRatio.toStringAsFixed(2));

    var text = 'Displacement: ${_volume?.toStringAsFixed(2)} cm3\n\n';
    text += 'Static Compression Ratio: ${_compressionRatio?.toStringAsFixed(2)}:1';

    setState(() {
      _result = text;
    });
  }

  void saveCalculation() {
    if (_result == '') {
      showToastMessage('First you have to execute calculation!');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    Storage.prefs?.setString(
      'compression',
      jsonEncode(
        CompressionRatioModel(
          head: double.parse(_head.text),
          deck: double.parse(_deck.text),
          gasket: double.parse(_gasket.text),
          piston: double.parse(_piston.text),
          bore: double.parse(_bore.text),
          stroke: double.parse(_stroke.text),
          volume: _volume!,
          compressionRatio: _compressionRatio!,
        ),
      ),
    );

    showToastMessage('Calculation saved successfully!');
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
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: PrimaryInputField(
                    textEditor: _head,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Head (cm3)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: _deck,
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
                    textEditor: _gasket,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Gasket (mm)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: _piston,
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
                    textEditor: _bore,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    label: 'Bore (mm)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryInputField(
                    textEditor: _stroke,
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
                _result,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                action: calculate,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
