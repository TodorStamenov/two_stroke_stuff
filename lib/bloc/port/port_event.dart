part of 'port_bloc.dart';

@immutable
abstract class PortEvent {}

class LoadPort extends PortEvent {
  final PortTimingModel portTiming;

  LoadPort(this.portTiming);
}

class ClearPort extends PortEvent {
  ClearPort();
}
