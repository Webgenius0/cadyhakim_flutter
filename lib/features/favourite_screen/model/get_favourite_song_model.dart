// import 'dart:convert';

// class GetFavouriteSong {
//     final bool? success;
//     final Datum? data;
//     final String? message;

//     GetFavouriteSong({
//         this.success,
//         this.data,
//         this.message,
//     });

//     factory GetFavouriteSong.fromRawJson(String str) => GetFavouriteSong.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory GetFavouriteSong.fromJson(Map<String, dynamic> json) => GetFavouriteSong(
//         success: json["success"],
//         data: json["data"] == null ? null : Datum.fromJson(json["data"]),
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data?.toJson(),
//         "message": message,
//     };
// }

// class Datum{
//     final List<Favorite>? favorites;
//     final Pagination? pagination;

//     Datum({
//         this.favorites,
//         this.pagination,
//     });

//     factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         favorites: json["favorites"] == null ? [] : List<Favorite>.from(json["favorites"]!.map((x) => Favorite.fromJson(x))),
//         pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "favorites": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x.toJson())),
//         "pagination": pagination?.toJson(),
//     };
// }

// class Favorite {
//     final int? id;
//     final int? categoryId;
//     final String? title;
//     final String? slug;
//     final String? description;
//     final String? tags;
//     final int? isTodaysPick;
//     final int? status;
//     final DateTime? createdAt;
//     final DateTime? updatedAt;
//     final String? fileUrl;
//     final String? categoryName;
//     final Pivot? pivot;

//     Favorite({
//         this.id,
//         this.categoryId,
//         this.title,
//         this.slug,
//         this.description,
//         this.tags,
//         this.isTodaysPick,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.fileUrl,
//         this.categoryName,
//         this.pivot,
//     });

//     factory Favorite.fromRawJson(String str) => Favorite.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
//         id: json["id"],
//         categoryId: json["category_id"],
//         title: json["title"],
//         slug: json["slug"],
//         description: json["description"],
//         tags: json["tags"],
//         isTodaysPick: json["is_todays_pick"],
//         status: json["status"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         fileUrl: json["file_url"],
//         categoryName: json["category_name"],
//         pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         "title": title,
//         "slug": slug,
//         "description": description,
//         "tags": tags,
//         "is_todays_pick": isTodaysPick,
//         "status": status,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "file_url": fileUrl,
//         "category_name": categoryName,
//         "pivot": pivot?.toJson(),
//     };
// }

// class Pivot {
//     final int? userId;
//     final int? audioId;
//     final DateTime? createdAt;
//     final DateTime? updatedAt;

//     Pivot({
//         this.userId,
//         this.audioId,
//         this.createdAt,
//         this.updatedAt,
//     });

//     factory Pivot.fromRawJson(String str) => Pivot.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
//         userId: json["user_id"],
//         audioId: json["audio_id"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "user_id": userId,
//         "audio_id": audioId,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//     };
// }

// class Pagination {
//     final int? currentPage;
//     final int? lastPage;
//     final int? perPage;
//     final int? total;

//     Pagination({
//         this.currentPage,
//         this.lastPage,
//         this.perPage,
//         this.total,
//     });

//     factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//         currentPage: json["current_page"],
//         lastPage: json["last_page"],
//         perPage: json["per_page"],
//         total: json["total"],
//     );

//     Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "last_page": lastPage,
//         "per_page": perPage,
//         "total": total,
//     };
// }

import 'dart:convert';

class GetFavouriteSong {
  final bool? success;
  final Data? data;
  final String? message;

  GetFavouriteSong({
    this.success,
    this.data,
    this.message,
  });

  factory GetFavouriteSong.fromRawJson(String str) =>
      GetFavouriteSong.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFavouriteSong.fromJson(Map<String, dynamic> json) =>
      GetFavouriteSong(
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
  final List<Favorite>? favorites;
  final Pagination? pagination;

  Data({
    this.favorites,
    this.pagination,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        favorites: json["favorites"] == null
            ? []
            : List<Favorite>.from(
                json["favorites"]!.map((x) => Favorite.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Favorite {
  final int? id;
  final dynamic categoryId;
  final String? title;
  final String? slug;
  final String? description;
  final String? tags;
  final int? isTodaysPick;
  final String? thumbnailPath;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;
  final dynamic categoryName;
  final Pivot? pivot;

  Favorite({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.description,
    this.tags,
    this.isTodaysPick,
    this.thumbnailPath,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.categoryName,
    this.pivot,
  });

  factory Favorite.fromRawJson(String str) =>
      Favorite.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        tags: json["tags"],
        isTodaysPick: json["is_todays_pick"],
        thumbnailPath: json["thumbnail_path"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        fileUrl: json["file_url"],
        categoryName: json["category_name"],
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "slug": slug,
        "description": description,
        "tags": tags,
        "is_todays_pick": isTodaysPick,
        "thumbnail_path": thumbnailPath,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "file_url": fileUrl,
        "category_name": categoryName,
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  final int? userId;
  final int? audioId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pivot({
    this.userId,
    this.audioId,
    this.createdAt,
    this.updatedAt,
  });

  factory Pivot.fromRawJson(String str) => Pivot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        audioId: json["audio_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "audio_id": audioId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Pagination {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "total": total,
      };
}
