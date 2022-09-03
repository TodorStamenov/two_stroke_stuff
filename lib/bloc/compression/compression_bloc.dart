import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:two_stroke_stuff/models/compression_ratio_model.dart';

part 'compression_event.dart';
part 'compression_state.dart';

class CompressionBloc extends Bloc<CompressionEvent, CompressionState> {
  CompressionBloc() : super(const CompressionInitial()) {
    on<LoadCompression>((event, emit) {
      emit(CompressionLoaded(event.compressionRatio));
    });

    on<ClearCompression>((event, emit) {
      emit(const CompressionInitial());
    });
  }
}
