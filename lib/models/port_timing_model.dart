class PortTimingModel {
  double deck = 0;
  double rod = 0;
  double stroke = 0;
  double targetPort = 0;
  double portHeight = 0;

  PortTimingModel({
    this.deck = 0,
    this.rod = 0,
    this.stroke = 0,
    this.targetPort = 0,
    this.portHeight = 0,
  });

  factory PortTimingModel.fromJson(Map<String, dynamic> json) {
    return PortTimingModel(
      deck: json['deck'],
      rod: json['rod'],
      stroke: json['stroke'],
      targetPort: json['targetPort'],
      portHeight: json['portHeight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deck': deck,
      'rod': rod,
      'stroke': stroke,
      'targetPort': targetPort,
      'portHeight': portHeight,
    };
  }
}
