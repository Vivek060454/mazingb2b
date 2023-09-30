// To parse this JSON data, do
//
//     final deliveryInfoResponse = deliveryInfoResponseFromJson(jsonString);

import 'dart:convert';

List<DeliveryInfoResponse> deliveryInfoResponseFromJson(String str) => List<DeliveryInfoResponse>.from(json.decode(str).map((x) => DeliveryInfoResponse.fromJson(x)));

String deliveryInfoResponseToJson(List<DeliveryInfoResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryInfoResponse {
  String? name;
  int ?ownerId;
  List<CartItem> ?cartItems;
  List<Carrier> ?carriers;

  DeliveryInfoResponse({
     this.name,
     this.ownerId,
     this.cartItems,
      this.carriers,
  });

  factory DeliveryInfoResponse.fromJson(Map<String, dynamic> json) => DeliveryInfoResponse(
    name: json["name"],
    ownerId: json["owner_id"],
    cartItems: List<CartItem>.from(json["cart_items"].map((x) => CartItem.fromJson(x))),
    carriers: List<Carrier>.from(json["carriers"].map((x) => Carrier.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner_id": ownerId,
    "cart_items": List<dynamic>.from(cartItems!.map((x) => x.toJson())),
    "carriers": List<dynamic>.from(carriers!.map((x) => x.toJson())),
  };
}

class Carrier {
  int ?id;
  String? name;
  String ?mobileNo;
  String ?phoneNo;
  dynamic logo;
  String ?transitTime;
  String? gstin;
  int ?freeShipping;
  int ?status;
  String? warehouseId;
  int? allIndia;
  String ?deliveryStates;
  DateTime? createdAt;
  DateTime? updatedAt;

  Carrier({
     this.id,
     this.name,
      this.mobileNo,
      this.phoneNo,
      this.logo,
      this.transitTime,
      this.gstin,
      this.freeShipping,
      this.status,
      this.warehouseId,
      this.allIndia,
      this.deliveryStates,
     this.createdAt,
     this.updatedAt,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
    id: json["id"],
    name: json["name"],
    mobileNo: json["mobile_no"],
    phoneNo: json["phone_no"],
    logo: json["logo"],
    transitTime: json["transit_time"],
    gstin: json["gstin"],
    freeShipping: json["free_shipping"],
    status: json["status"],
    warehouseId: json["warehouse_id"],
    allIndia: json["all_india"],
    deliveryStates: json["delivery_states"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_no": mobileNo,
    "phone_no": phoneNo,
    "logo": logo,
    "transit_time": transitTime,
    "gstin": gstin,
    "free_shipping": freeShipping,
    "status": status,
    "warehouse_id": warehouseId,
    "all_india": allIndia,
    "delivery_states": deliveryStates,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class CartItem {
  int id;
  int ownerId;
  int userId;
  int productId;
  String productName;
  String productThumbnailImage;

  CartItem({
    required this.id,
    required this.ownerId,
    required this.userId,
    required  this.productId,
    required  this.productName,
    required  this.productThumbnailImage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    ownerId: json["owner_id"],
    userId: json["user_id"],
    productId: json["product_id"],
    productName: json["product_name"],
    productThumbnailImage: json["product_thumbnail_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "user_id": userId,
    "product_id": productId,
    "product_name": productName,
    "product_thumbnail_image": productThumbnailImage,
  };
}
