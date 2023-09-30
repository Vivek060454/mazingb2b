// To parse this JSON data, do
//
//     final newproduct = newproductFromJson(jsonString);

import 'dart:convert';

Newproduct newproductFromJson(String str) => Newproduct.fromJson(json.decode(str));

String newproductToJson(Newproduct data) => json.encode(data.toJson());

class Newproduct {
  List<Datum> data;
  bool success;
  int status;

  Newproduct({
    required this.data,
    required this.success,
    required this.status,
  });

  factory Newproduct.fromJson(Map<String, dynamic> json) => Newproduct(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Datum {
  int id;
  String name;
  String thumbnailImage;
  bool hasDiscount;
  Discount discount;
  String strokedPrice;
  String mainPrice;
  double rating;
  int sales;
  Links links;

  Datum({
    required this.id,
    required this.name,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.mainPrice,
    required this.rating,
    required this.sales,
    required this.links,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    thumbnailImage: json["thumbnail_image"],
    hasDiscount: json["has_discount"],
    discount: discountValues.map[json["discount"]]!,
    strokedPrice: json["stroked_price"],
    mainPrice: json["main_price"],
    rating: json["rating"]?.toDouble(),
    sales: json["sales"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_image": thumbnailImage,
    "has_discount": hasDiscount,
    "discount": discountValues.reverse[discount],
    "stroked_price": strokedPrice,
    "main_price": mainPrice,
    "rating": rating,
    "sales": sales,
    "links": links.toJson(),
  };
}

enum Discount {
  THE_0
}

final discountValues = EnumValues({
  "-0%": Discount.THE_0
});

class Links {
  String details;

  Links({
    required this.details,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "details": details,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
