part of 'compression_bloc.dart';

@immutable
abstract class CompressionEvent {}

class LoadCompression extends CompressionEvent {
  final CompressionRatioModel compressionRatio;

  LoadCompression(this.compressionRatio);
}

class ClearCompression extends CompressionEvent {
  ClearCompression();
}
