part of 'port_bloc.dart';

@immutable
abstract class PortState {
  const PortState();
}

class PortInitial extends PortState {
  const PortInitial();
}

class PortLoaded extends PortState {
  final PortTimingModel portTiming;

  const PortLoaded(this.portTiming);

  @override
  int get hashCode => portTiming.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PortLoaded && other.portTiming == portTiming;
  }
}
