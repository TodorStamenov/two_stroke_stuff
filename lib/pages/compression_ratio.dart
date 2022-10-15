import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_stroke_stuff/bloc/compression/compression_bloc.dart';
import 'package:two_stroke_stuff/enum/intake_duration_action.dart';
import 'package:two_stroke_stuff/models/compression_ratio_model.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/icon_action_button.dart';
import 'package:two_stroke_stuff/widgets/primary_input_field.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _head = TextEditingController();
  final _deck = TextEditingController();
  final _gasket = TextEditingController();
  final _piston = TextEditingController();
  final _bore = TextEditingController();
  final _stroke = TextEditingController();
  final _rod = TextEditingController();
  final _intake = TextEditingController();

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
    _head.clear();
    _deck.clear();
    _gasket.clear();
    _piston.clear();
    _bore.clear();
    _stroke.clear();
    _rod.clear();
    _intake.clear();

    setState(() {
      _result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculate() {
    if (!_formKey.currentState!.validate()) {
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
    text += 'Static Compression Ratio: ${_compressionRatio?.toStringAsFixed(2)}:1\n\n';

    var dynamicCompressionRatio = 'N\\A';
    if (_rod.text != '' && _intake.text != '') {
      final rodLength = double.parse(_rod.text);
      final intakeDuration = double.parse(_intake.text);
      if (rodLength <= 0) {
        showToastMessage('Rod length must have positive value!');
        return;
      }

      if (intakeDuration < 0 || 180 < intakeDuration) {
        showToastMessage('Intake duration must be between 0 and 180 degrees!');
        return;
      }

      final radius = strokeLength / 2;

      final y = cos(intakeDuration * pi / 180) * radius;
      final z = sin(intakeDuration * pi / 180) * radius;
      final x = sqrt(pow(rodLength, 2) - pow(z, 2)) - y;

      final dynamicStroke = rodLength + radius - x;
      final dynamicCylinderVolume = boreArea * dynamicStroke;
      dynamicCompressionRatio = '${((chamberVolume + dynamicCylinderVolume) / chamberVolume).toStringAsFixed(2)}:1';
    }

    text += 'Dynamic Compression Ratio: $dynamicCompressionRatio';

    setState(() {
      _result = text;
    });
  }

  void changeIntakeDuration(IntakeDurationAction intakeDurationAction) {
    if (_result == '') {
      showToastMessage('First you have to execute calculation!');
      return;
    }

    if (_rod.text == '' || _intake.text == '') {
      return;
    }

    var durationChange = 1;
    if (intakeDurationAction == IntakeDurationAction.decrease) {
      durationChange = -1;
    }

    var intakeDuration = double.parse(_intake.text) + durationChange;
    if ((intakeDuration < 0 && intakeDurationAction == IntakeDurationAction.decrease) ||
        (180 < intakeDuration && intakeDurationAction == IntakeDurationAction.increase)) {
      return;
    }

    if (intakeDuration < 0 && intakeDurationAction == IntakeDurationAction.increase) {
      intakeDuration = 0;
    } else if (180 < intakeDuration && intakeDurationAction == IntakeDurationAction.decrease) {
      intakeDuration = 180;
    }

    setState(() {
      _intake.text = intakeDuration.toStringAsFixed(1);
    });

    calculate();
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _head,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      label: 'Head (cm3)',
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _deck,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      label: 'Deck (mm)',
                      isRequired: true,
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
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _piston,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      label: 'Piston (cm3)',
                      isRequired: true,
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
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _stroke,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      label: 'Stroke (mm)',
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _rod,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      label: 'Rod (mm)',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _intake,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      label: 'Intake ABDC (deg)',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconActionButton(
                    icon: Icons.remove,
                    action: () => changeIntakeDuration(IntakeDurationAction.decrease),
                  ),
                  IconActionButton(
                    icon: Icons.add,
                    action: () => changeIntakeDuration(IntakeDurationAction.increase),
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
            ],
          ),
        ),
      ),
    );
  }
}
