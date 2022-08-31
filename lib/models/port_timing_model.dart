class PortTimingModel {
  double deck = 0;
  double rod = 0;
  double stroke = 0;
  double portHeight = 0;
  double portDuration = 0;

  PortTimingModel({
    this.deck = 0,
    this.rod = 0,
    this.stroke = 0,
    this.portHeight = 0,
    this.portDuration = 0,
  });

  factory PortTimingModel.fromJson(Map<String, dynamic> json) {
    return PortTimingModel(
      deck: json['deck'] ?? 0,
      rod: json['rod'] ?? 0,
      stroke: json['stroke'] ?? 0,
      portHeight: json['portHeight'] ?? 0,
      portDuration: json['portDuration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deck': deck,
      'rod': rod,
      'stroke': stroke,
      'portHeight': portHeight,
      'portDuration': portDuration,
    };
  }
}
