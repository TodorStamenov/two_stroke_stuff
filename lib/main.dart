import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_stroke_stuff/bloc/compression/compression_bloc.dart';
import 'package:two_stroke_stuff/bloc/port/port_bloc.dart';
import 'package:two_stroke_stuff/utils/storage.dart';
import 'package:two_stroke_stuff/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.prefs = await SharedPreferences.getInstance();

  Widget unfocusOnTap(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  runApp(
    unfocusOnTap(
      MaterialApp(
        title: 'Two Stroke Port Calculator',
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PortBloc>(
              create: (context) => PortBloc(),
            ),
            BlocProvider<CompressionBloc>(
              create: (context) => CompressionBloc(),
            )
          ],
          child: const Home(),
        ),
      ),
    ),
  );
}
