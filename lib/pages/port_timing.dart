import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_stroke_stuff/bloc/port/port_bloc.dart';
import 'package:two_stroke_stuff/enum/port_action.dart';
import 'package:two_stroke_stuff/models/port_timing_model.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/utils/toaster.dart';
import 'package:two_stroke_stuff/widgets/icon_action_button.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/primary_input_field.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';

class PortTiming extends StatefulWidget {
  const PortTiming({super.key});

  @override
  State<PortTiming> createState() => _PortTimingState();
}

class _PortTimingState extends State<PortTiming> {
  String _result = '';
  double? _portHeightResult;
  double? _portDurationResult;
  bool _isPortDuration = false;

  final _formKey = GlobalKey<FormState>();
  final _deckHeight = TextEditingController();
  final _rodLength = TextEditingController();
  final _stroke = TextEditingController();
  final _portDuration = TextEditingController();
  final _portHeight = TextEditingController();

  @override
  void didChangeDependencies() {
    final state = BlocProvider.of<PortBloc>(context).state;
    if (state is PortLoaded) {
      final port = state.portTiming;

      _deckHeight.text = port.deck.toString();
      _rodLength.text = port.rod.toString();
      _stroke.text = port.stroke.toString();
      _portDuration.text = port.portDuration.toString();
      _portHeight.text = port.portHeight.toString();
    }

    super.didChangeDependencies();
  }

  void clearCalculation() {
    setState(() {
      _deckHeight.clear();
      _rodLength.clear();
      _stroke.clear();
      _portDuration.clear();
      _portHeight.clear();

      _result = '';
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void calculateDeckHeight() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final targetPortDuration = double.parse(_portDuration.text);
    if (targetPortDuration < 1 || 359 < targetPortDuration) {
      showToastMessage(
          'Target port duration must be between 1 and 359 degrees!');
      return;
    }

    final deck = double.parse(_deckHeight.text);
    final rod = double.parse(_rodLength.text);
    final radius = double.parse(_stroke.text) / 2;

    if (rod < 0 || deck < 0 || radius < 0) {
      showToastMessage('Rod Deck and Stroke must have positive value!');
      return;
    }

    final degreesFromBdc = targetPortDuration / 2;
    final y = cos(degreesFromBdc * pi / 180) * radius;
    final z = sin(degreesFromBdc * pi / 180) * radius;
    final x = sqrt(pow(rod, 2) - pow(z, 2)) - y;

    _portHeightResult =
        double.parse((rod + radius + deck - x).toStringAsFixed(2));

    setState(() {
      _result = 'Port Height: ${_portHeightResult?.toStringAsFixed(2)} mm';
    });
  }

  void calculatePortDuration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final deck = double.parse(_deckHeight.text);
    final rod = double.parse(_rodLength.text);
    final stroke = double.parse(_stroke.text);
    final radius = double.parse(_stroke.text) / 2;
    final currentPortHeight = double.parse(_portHeight.text);

    if (rod < 0 || deck < 0 || radius < 0 || currentPortHeight < 0) {
      showToastMessage(
          'Rod Deck Stroke and Port Height must have positive value!');
      return;
    }

    if (stroke + deck < currentPortHeight) {
      showToastMessage('Stroke value must be greater than Port height!');
      return;
    }

    final x = deck + rod + radius - currentPortHeight;
    final angle = (pow(radius, 2) + pow(x, 2) - pow(rod, 2)) / (2 * radius * x);

    _portDurationResult = (180 - (acos(angle) * 180 / pi)) * 2;

    setState(() {
      _result = 'Port Duration: ${_portDurationResult?.toStringAsFixed(2)} deg';
    });
  }

  void changePortParameter(PortAction portAction) {
    if (_result == '') {
      showToastMessage('First you have to execute calculation!');
      return;
    }

    var portChange = 1;
    if (portAction == PortAction.decrease) {
      portChange = -1;
    }

    if (_isPortDuration) {
      var portHeight = double.parse(_portHeight.text) + portChange;
      final deck = double.parse(_deckHeight.text);
      final stroke = double.parse(_stroke.text);

      if ((portHeight < deck && portAction == PortAction.decrease) ||
          (stroke < portHeight - deck && portAction == PortAction.increase)) {
        return;
      }

      if (portHeight < deck && portAction == PortAction.increase) {
        portHeight = deck;
      } else if (stroke < portHeight - deck &&
          portAction == PortAction.decrease) {
        portHeight = stroke + deck;
      }

      setState(() {
        _portHeight.text = portHeight.toStringAsFixed(1);
      });

      calculatePortDuration();
    } else {
      var portDuration = double.parse(_portDuration.text) + portChange;

      if ((portDuration <= 0 && portAction == PortAction.decrease) ||
          (360 <= portDuration && portAction == PortAction.increase)) {
        return;
      }

      if (portDuration <= 0 && portAction == PortAction.increase) {
        portDuration = 1;
      } else if (360 <= portDuration && portAction == PortAction.decrease) {
        portDuration = 359;
      }

      setState(() {
        _portDuration.text = portDuration.toStringAsFixed(1);
      });

      calculateDeckHeight();
    }
  }

  void saveCalculation() {
    if (_result == '') {
      showToastMessage('First you have to execute calculation!');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    Storage.prefs?.setString(
      'port',
      jsonEncode(
        PortTimingModel(
          deck: double.parse(_deckHeight.text),
          rod: double.parse(_rodLength.text),
          stroke: double.parse(_stroke.text),
          portHeight: !_isPortDuration
              ? _portHeightResult!
              : double.parse(_portHeight.text),
          portDuration: _isPortDuration
              ? _portDurationResult!
              : double.parse(_portDuration.text),
        ),
      ),
    );

    showToastMessage('Calculation saved successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: 'Port Calculator',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Port Height',
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: _isPortDuration,
                    activeColor: Colors.deepPurple,
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return null;
                        }

                        return Colors.grey;
                      },
                    ),
                    onChanged: (bool value) {
                      _portDuration.clear();
                      _portHeight.clear();

                      setState(() {
                        _result = '';
                        _isPortDuration = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Port Duration',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _deckHeight,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      label: 'Deck Height (mm)',
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryInputField(
                      textEditor: _rodLength,
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      label: 'Rod Length (mm)',
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              PrimaryInputField(
                textEditor: _stroke,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                label: 'Stroke (mm)',
                isRequired: true,
              ),
              const SizedBox(height: 50),
              if (_isPortDuration) ...[
                Row(
                  children: [
                    Expanded(
                      child: PrimaryInputField(
                        textEditor: _portHeight,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        label: 'Current Height (mm)',
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconActionButton(
                      icon: Icons.remove,
                      action: () => changePortParameter(PortAction.decrease),
                    ),
                    IconActionButton(
                      icon: Icons.add,
                      action: () => changePortParameter(PortAction.increase),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: PrimaryInputField(
                        textEditor: _portDuration,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        label: 'Target Duration (deg)',
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconActionButton(
                      icon: Icons.remove,
                      action: () => changePortParameter(PortAction.decrease),
                    ),
                    IconActionButton(
                      icon: Icons.add,
                      action: () => changePortParameter(PortAction.increase),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 50),
              Center(
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 21,
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
                  action: () {
                    if (_isPortDuration) {
                      calculatePortDuration();
                    } else {
                      calculateDeckHeight();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
