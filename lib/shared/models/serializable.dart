abstract class Serializable {
  Map<String, dynamic> toJson();

  fromJson(Map<String, dynamic> json);
}
