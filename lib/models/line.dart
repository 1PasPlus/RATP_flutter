class Line {
  final String? idLine;
  final String? nameLine;
  final String? shortNameLine;
  final String? transportMode;
  final String? transportSubMode;
  final String? operatorName;
  final String? networkName;
  final String? colourWebHexa;
  final String? textColourWebHexa;

  Line({
    this.idLine,
    this.nameLine,
    this.shortNameLine,
    this.transportMode,
    this.transportSubMode,
    this.operatorName,
    this.networkName,
    this.colourWebHexa,
    this.textColourWebHexa,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      idLine: json['id_line'] as String?,
      nameLine: json['name_line'] as String?,
      shortNameLine: json['shortname_line'] as String?,
      transportMode: json['transportmode'] as String?,
      transportSubMode: json['transportsubmode'] as String?,
      operatorName: json['operatorname'] as String?,
      networkName: json['networkname'] as String?,
      colourWebHexa: json['colourweb_hexa'] as String?,
      textColourWebHexa: json['textcolourweb_hexa'] as String?,
    );
  }
}
