import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:two_stroke_stuff/models/port_timing_model.dart';

part 'port_event.dart';
part 'port_state.dart';

class PortBloc extends Bloc<PortEvent, PortState> {
  PortBloc() : super(const PortInitial()) {
    on<LoadPort>((event, emit) {
      emit(PortLoaded(event.portTiming));
    });

    on<ClearPort>((event, emit) {
      emit(const PortInitial());
    });
  }
}
