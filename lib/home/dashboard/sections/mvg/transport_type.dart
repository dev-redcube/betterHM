enum TransportType {
  UBAHN,
  REGIONAL_BUS,
  BUS,
  TRAM,
  SBAHN;

  static TransportType fromString(String string) => values.byName(string);
}
