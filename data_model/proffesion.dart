// To parse this JSON data, do
//
//     final proffesion = proffesionFromJson(jsonString);

import 'dart:convert';

Proffesion proffesionFromJson(String str) => Proffesion.fromJson(json.decode(str));

String proffesionToJson(Proffesion data) => json.encode(data.toJson());

class Proffesion {
  List<Datum>? data;
  bool? success;
  int ?status;

  Proffesion({
    this.data,
    this.success,
    this.status,
  });

  factory Proffesion.fromJson(Map<String, dynamic> json) => Proffesion(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Datum {
  String? name;
  String? logo;
  Links ?links;

  Datum({
    this.name,
    this.logo,
    this.links,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    logo: json["logo"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "logo": logo,
    "links": links!.toJson(),
  };
}

class Links {
  String? products;

  Links({
    this.products,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
  };
}
