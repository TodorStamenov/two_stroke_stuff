part of 'compression_bloc.dart';

@immutable
abstract class CompressionState {
  const CompressionState();
}

class CompressionInitial extends CompressionState {
  const CompressionInitial();
}

class CompressionLoaded extends CompressionState {
  final CompressionRatioModel compressionRatio;

  const CompressionLoaded(this.compressionRatio);

  @override
  int get hashCode => compressionRatio.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CompressionLoaded && other.compressionRatio == compressionRatio;
  }
}
