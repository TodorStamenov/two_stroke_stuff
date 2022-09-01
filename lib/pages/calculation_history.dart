import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/models/compression_ratio_model.dart';
import 'package:two_stroke_stuff/models/port_timing_model.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/widgets/header.dart';
import 'package:two_stroke_stuff/widgets/primary_action_button.dart';

class CalculationHistory extends StatefulWidget {
  const CalculationHistory({Key? key}) : super(key: key);

  @override
  State<CalculationHistory> createState() => _CalculationHistoryState();
}

class _CalculationHistoryState extends State<CalculationHistory> {
  PortTimingModel _portTiming = PortTimingModel();
  CompressionRatioModel _compressionRatio = CompressionRatioModel();

  void initModels() {
    if (Storage.prefs?.getString('port') == null) {
      Storage.prefs?.setString('port', jsonEncode(PortTimingModel()));
    }

    if (Storage.prefs?.getString('compression') == null) {
      Storage.prefs?.setString('compression', jsonEncode(CompressionRatioModel()));
    }

    _portTiming = PortTimingModel.fromJson(jsonDecode((Storage.prefs?.getString('port'))!));
    _compressionRatio = CompressionRatioModel.fromJson(jsonDecode((Storage.prefs?.getString('compression'))!));
  }

  @override
  void initState() {
    super.initState();
    initModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        title: 'Calculation History',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Port timing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Deck: ${_portTiming.deck} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rod Length: ${_portTiming.rod} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Stroke: ${_portTiming.stroke} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Port Duration: ${_portTiming.portDuration.toStringAsFixed(2)} deg',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Port Height: ${_portTiming.portHeight.toStringAsFixed(2)} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryActionButton(
                  text: 'Clear',
                  action: () {
                    Storage.prefs?.setString(
                      'port',
                      jsonEncode(PortTimingModel()),
                    );
                    setState(() {
                      _portTiming = PortTimingModel();
                    });
                  },
                ),
                const SizedBox(width: 10),
                PrimaryActionButton(
                  text: 'Load',
                  action: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Compression Ratio',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Head: ${_compressionRatio.head} cm3',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Deck: ${_compressionRatio.deck} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Gasket: ${_compressionRatio.gasket} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Piston: ${_compressionRatio.piston} cm3',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Bore: ${_compressionRatio.bore} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Stroke: ${_compressionRatio.stroke} mm',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Displacement: ${_compressionRatio.volume} cm3\nStatic Compression Ratio: ${_compressionRatio.compressionRatio}:1',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryActionButton(
                  text: 'Clear',
                  action: () {
                    Storage.prefs?.setString(
                      'compression',
                      jsonEncode(CompressionRatioModel()),
                    );
                    setState(() {
                      _compressionRatio = CompressionRatioModel();
                    });
                  },
                ),
                const SizedBox(width: 10),
                PrimaryActionButton(
                  text: 'Load',
                  action: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
