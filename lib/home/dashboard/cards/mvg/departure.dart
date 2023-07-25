import 'package:better_hm/home/dashboard/cards/mvg/transport_type.dart';
import 'package:logging/logging.dart';

class Departure {
  final DateTime plannedDepartureTime;
  final bool realtime;
  final int? delayInMinutes;
  final DateTime realtimeDepartureTime;
  final TransportType transportType;
  final String label;
  final String network;
  final String? trainType;
  final String destination;
  final bool cancelled;
  final bool sev;
  final List messages;
  final String? bannerHash;
  final String? occupancy;
  final String stopPointGlobalId;

  Departure({
    required this.plannedDepartureTime,
    required this.realtime,
    required this.delayInMinutes,
    required this.realtimeDepartureTime,
    required this.transportType,
    required this.label,
    required this.network,
    this.trainType,
    required this.destination,
    required this.cancelled,
    required this.sev,
    required this.messages,
    required this.bannerHash,
    required this.occupancy,
    required this.stopPointGlobalId,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    try {
      final plannedDepartureTime =
          DateTime.fromMillisecondsSinceEpoch(json["plannedDepartureTime"]);
      final realtimeDepartureTime =
          DateTime.fromMillisecondsSinceEpoch(json["realtimeDepartureTime"]);
      final transportType = TransportType.fromString(json["transportType"]);

      String? bannerHash = json["bannerHash"] ?? [];
      if (bannerHash != null && bannerHash.isEmpty) bannerHash = null;

      final departure = Departure(
        plannedDepartureTime: plannedDepartureTime,
        realtime: json["realtime"] ?? true,
        delayInMinutes: json["delayInMinutes"],
        realtimeDepartureTime: realtimeDepartureTime,
        transportType: transportType,
        label: json["label"],
        network: json["network"] ?? "swm",
        trainType:
            json["trainType"].toString().isEmpty ? null : json["trainType"],
        destination: json["destination"],
        cancelled: json["cancelled"] ?? false,
        sev: json["sev"] ?? false,
        messages: json["messages"] ?? [],
        bannerHash: bannerHash,
        occupancy: json["occupancy"],
        stopPointGlobalId: json["stopPointGlobalId"],
      );
      return departure;
    } catch (e, stacktrace) {
      Logger("Departure")
          .severe("Error while parsing Departure: $e", e, stacktrace);
      rethrow;
    }
  }
}
