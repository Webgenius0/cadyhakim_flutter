import 'dart:convert';

class GetAllMusic {
  final bool? success;
  final Data? data;
  final String? message;

  GetAllMusic({
    this.success,
    this.data,
    this.message,
  });

  factory GetAllMusic.fromRawJson(String str) =>
      GetAllMusic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllMusic.fromJson(Map<String, dynamic> json) => GetAllMusic(
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
  final List<Audio>? audios;
  final Pagination? pagination;

  Data({
    this.audios,
    this.pagination,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        audios: json["audios"] == null
            ? []
            : List<Audio>.from(json["audios"]!.map((x) => Audio.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "audios": audios == null
            ? []
            : List<dynamic>.from(audios!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Audio {
  final int? id;
  final dynamic categoryId;
  final String? title;
  final String? slug;
  final String? description;
  final String? fileUrl;
  final String? thumbnailUrl;
  final bool? isSuggested;

  Audio({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.description,
    this.fileUrl,
    this.thumbnailUrl,
    this.isSuggested,
  });

  factory Audio.fromRawJson(String str) => Audio.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        fileUrl: json["file_url"],
        thumbnailUrl: json["thumbnail_url"],
        isSuggested: json["is_suggested"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "slug": slug,
        "description": description,
        "file_url": fileUrl,
        "thumbnail_url": thumbnailUrl,
        "is_suggested": isSuggested,
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
