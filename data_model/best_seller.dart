// To parse this JSON data, do
//
//     final bestsellerModel = bestsellerModelFromJson(jsonString);

import 'dart:convert';

BestsellerModel bestsellerModelFromJson(String str) => BestsellerModel.fromJson(json.decode(str));

String bestsellerModelToJson(BestsellerModel data) => json.encode(data.toJson());

class BestsellerModel {
  List<Datum> ?data;
  bool? success;
  int? status;

  BestsellerModel({
     this.data,
     this.success,
     this.status,
  });

  factory BestsellerModel.fromJson(Map<String, dynamic> json) => BestsellerModel(
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
  int ?id;
  String? name;
  String ?thumbnailImage;
  bool ?hasDiscount;
  Discount? discount;
  String ?strokedPrice;
  String ?mainPrice;
  double ?rating;
  int ?sales;
  Links? links;

  Datum({
     this.id,
     this.name,
     this.thumbnailImage,
     this.hasDiscount,
     this.discount,
     this.strokedPrice,
     this.mainPrice,
     this.rating,
     this.sales,
     this.links,
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
    "links": links!.toJson(),
  };
}

enum Discount {
  THE_0
}

final discountValues = EnumValues({
  "-0%": Discount.THE_0
});

class Links {
  String? details;

  Links({
     this.details,
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
