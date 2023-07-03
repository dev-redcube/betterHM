enum Stations {
  lothstr;

  @override
  String toString() => name;

  static Stations fromString(String string) => values.byName(string);
}

const stationIds = {
  Stations.lothstr: "de:09162:12",
};

const lineIds = {};
