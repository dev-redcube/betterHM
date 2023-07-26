enum TransportType {
  UBAHN,
  TRAM,
  BUS,
  SBAHN,
  SCHIFF;

  static TransportType fromString(String string) => values.byName(string);
}
