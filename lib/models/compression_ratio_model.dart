class CompressionRatioModel {
  double head = 0;
  double deck = 0;
  double gasket = 0;
  double piston = 0;
  double bore = 0;
  double stroke = 0;
  double volume = 0;
  double compressionRatio = 0;

  CompressionRatioModel({
    this.head = 0,
    this.deck = 0,
    this.gasket = 0,
    this.piston = 0,
    this.bore = 0,
    this.stroke = 0,
    this.volume = 0,
    this.compressionRatio = 0,
  });

  factory CompressionRatioModel.fromJson(Map<String, dynamic> json) {
    return CompressionRatioModel(
      head: json['head'] ?? 0,
      deck: json['deck'] ?? 0,
      gasket: json['gasket'] ?? 0,
      piston: json['piston'] ?? 0,
      bore: json['bore'] ?? 0,
      stroke: json['stroke'] ?? 0,
      volume: json['volume'] ?? 0,
      compressionRatio: json['compressionRatio'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'head': head,
      'deck': deck,
      'gasket': gasket,
      'piston': piston,
      'bore': bore,
      'stroke': stroke,
      'volume': volume,
      'compressionRatio': compressionRatio,
    };
  }
}
