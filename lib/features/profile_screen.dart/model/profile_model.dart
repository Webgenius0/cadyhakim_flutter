import 'dart:convert';

class GetProfile {
    final bool? success;
    final Data? data;
    final String? message;

    GetProfile({
        this.success,
        this.data,
        this.message,
    });

    factory GetProfile.fromRawJson(String str) => GetProfile.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    final int? id;
    final String? name;
    final String? email;
    final String? role;
    final dynamic phone;
    final dynamic image;
    final int? notification;

    Data({
        this.id,
        this.name,
        this.email,
        this.role,
        this.phone,
        this.image,
        this.notification,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        image: json["image"],
        notification: json["notification"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "image": image,
        "notification": notification,
    };
}
