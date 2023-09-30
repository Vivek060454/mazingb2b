// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  List<GroupDatum> data;
  bool success;
  int status;

  Group({
    required this.data,
    required this.success,
    required this.status,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    data: List<GroupDatum>.from(json["data"].map((x) => GroupDatum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class GroupDatum {
  int id;
  String name;
  Categories categories;

  GroupDatum({
    required  this.id,
    required  this.name,
    required  this.categories,
  });

  factory GroupDatum.fromJson(Map<String, dynamic> json) => GroupDatum(
    id: json["id"],
    name: json["name"],
    categories: Categories.fromJson(json["categories"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "categories": categories.toJson(),
  };
}

class Categories {
  List<CategoriesDatum> data;

  Categories({
    required  this.data,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    data: List<CategoriesDatum>.from(json["data"].map((x) => CategoriesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoriesDatum {
  int id;
  String name;
  String banner;
  String icon;
  int numberOfChildren;
  Links links;

  CategoriesDatum({
    required  this.id,
    required  this.name,
    required  this.banner,
    required  this.icon,
    required this.numberOfChildren,
    required this.links,
  });

  factory CategoriesDatum.fromJson(Map<String, dynamic> json) => CategoriesDatum(
    id: json["id"],
    name: json["name"],
    banner: json["banner"],
    icon: json["icon"],
    numberOfChildren: json["number_of_children"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "banner": banner,
    "icon": icon,
    "number_of_children": numberOfChildren,
    "links": links.toJson(),
  };
}
class Links {
  String products;
  String subCategories;

  Links({
    required this.products,
    required  this.subCategories,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
    subCategories: json["sub_categories"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
    "sub_categories": subCategories,
  };
}
