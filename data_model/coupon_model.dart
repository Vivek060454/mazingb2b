// To parse this JSON data, do
//
//     final couponResponse = couponResponseFromJson(jsonString);

import 'dart:convert';

CouponResponse couponResponseFromJson(String str) => CouponResponse.fromJson(json.decode(str));

String couponResponseToJson(CouponResponse data) => json.encode(data.toJson());

class CouponResponse {
  List<Coupone> coupon;

  CouponResponse({
    required this.coupon,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) => CouponResponse(
    coupon: List<Coupone>.from(json["coupon"].map((x) => Coupone.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "coupon": List<dynamic>.from(coupon.map((x) => x.toJson())),
  };
}

class Coupone {
  int id;
  int userId;
  dynamic customerId;
  String type;
  String code;
  String description;
  String details;
  int maxUsageCount;
  int discount;
  int newUserOnly;
  String discountType;
  int startDate;
  int endDate;
  DateTime createdAt;
  DateTime updatedAt;

  Coupone({
    required this.id,
    required this.userId,
    this.customerId,
    required this.type,
    required this.code,
    required this.description,
    required  this.details,
    required  this.maxUsageCount,
    required  this.discount,
    required  this.newUserOnly,
    required  this.discountType,
    required  this.startDate,
    required  this.endDate,
    required  this.createdAt,
    required  this.updatedAt,
  });

  factory Coupone.fromJson(Map<String, dynamic> json) => Coupone(
    id: json["id"],
    userId: json["user_id"],
    customerId: json["customer_id"],
    type: json["type"],
    code: json["code"],
    description: json["description"],
    details: json["details"],
    maxUsageCount: json["max_usage_count"],
    discount: json["discount"],
    newUserOnly: json["new_user_only"],
    discountType: json["discount_type"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "customer_id": customerId,
    "type": type,
    "code": code,
    "description": description,
    "details": details,
    "max_usage_count": maxUsageCount,
    "discount": discount,
    "new_user_only": newUserOnly,
    "discount_type": discountType,
    "start_date": startDate,
    "end_date": endDate,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
