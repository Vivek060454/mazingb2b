// To parse this JSON data, do
//
//     final categoriesListQuickOrderResponse = categoriesListQuickOrderResponseFromJson(jsonString);

import 'dart:convert';

CategoriesListQuickOrderResponse categoriesListQuickOrderResponseFromJson(String str) => CategoriesListQuickOrderResponse.fromJson(json.decode(str));

String categoriesListQuickOrderResponseToJson(CategoriesListQuickOrderResponse data) => json.encode(data.toJson());

class CategoriesListQuickOrderResponse {
  List<Datum>? data;
  bool? success;
  int ?status;

  CategoriesListQuickOrderResponse({
     this.data,
     this.success,
     this.status,
  });

  factory CategoriesListQuickOrderResponse.fromJson(Map<String, dynamic> json) => CategoriesListQuickOrderResponse(
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
  int? id;
  String? name;

  Datum({
     this.id,
     this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
