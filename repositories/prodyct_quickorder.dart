// To parse this JSON data, do
//
//     final productQuickOrderResponse = productQuickOrderResponseFromJson(jsonString);

import 'dart:convert';

ProductQuickOrderResponse productQuickOrderResponseFromJson(String str) => ProductQuickOrderResponse.fromJson(json.decode(str));

String productQuickOrderResponseToJson(ProductQuickOrderResponse data) => json.encode(data.toJson());

class ProductQuickOrderResponse {
  List<Datum>? data;
  Links ?links;
  Meta? meta;
  bool? success;
  int ?status;

  ProductQuickOrderResponse({
     this.data,
     this.links,
     this.meta,
     this.success,
     this.status,
  });

  factory ProductQuickOrderResponse.fromJson(Map<String, dynamic> json) => ProductQuickOrderResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links!.toJson(),
    "meta": meta!.toJson(),
    "success": success,
    "status": status,
  };
}

class Datum {
  int ?id;
  dynamic name;
  String ?thumbnailImg;
  dynamic homeBasePrice;
  dynamic homeDiscountedBasePrice;

  Datum({
     this.id,
    this.name,
     this.thumbnailImg,
    this.homeBasePrice,
    this.homeDiscountedBasePrice,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    thumbnailImg: json["thumbnail_img"],
    homeBasePrice: json["home_base_price"],
    homeDiscountedBasePrice: json["home_discounted_base_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_img": thumbnailImg,
    "home_base_price": homeBasePrice,
    "home_discounted_base_price": homeDiscountedBasePrice,
  };
}

class Links {
  String ?first;
  String ?last;
  dynamic prev;
  String ?next;

  Links({
     this.first,
     this.last,
    this.prev,
     this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
     this.currentPage,
     this.from,
     this.lastPage,
     this.links,
     this.path,
     this.perPage,
     this.to,
     this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String? url;
  String? label;
  bool ?active;

  Link({
    this.url,
     this.label,
     this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
