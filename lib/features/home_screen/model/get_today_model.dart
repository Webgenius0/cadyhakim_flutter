import 'dart:convert';

class GetTodaySongModel {
  final bool? success;
  final Data? data;
  final String? message;

  GetTodaySongModel({
    this.success,
    this.data,
    this.message,
  });

  factory GetTodaySongModel.fromRawJson(String str) =>
      GetTodaySongModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTodaySongModel.fromJson(Map<String, dynamic> json) =>
      GetTodaySongModel(
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
  final List<TodaysPick>? todaysPicks;
  final Pagination? pagination;

  Data({
    this.todaysPicks,
    this.pagination,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        todaysPicks: json["todays_picks"] == null
            ? []
            : List<TodaysPick>.from(
                json["todays_picks"]!.map((x) => TodaysPick.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "todays_picks": todaysPicks == null
            ? []
            : List<dynamic>.from(todaysPicks!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
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

class TodaysPick {
  final int? id;
  final dynamic categoryId;
  final String? title;
  final String? slug;
  final String? description;
  final String? tags;
  final String? fileUrl;
  final String? thumbnailUrl;
  final dynamic categoryName;

  TodaysPick({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.description,
    this.tags,
    this.fileUrl,
    this.thumbnailUrl,
    this.categoryName,
  });

  factory TodaysPick.fromRawJson(String str) =>
      TodaysPick.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TodaysPick.fromJson(Map<String, dynamic> json) => TodaysPick(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        tags: json["tags"],
        fileUrl: json["file_url"],
        thumbnailUrl: json["thumbnail_url"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "slug": slug,
        "description": description,
        "tags": tags,
        "file_url": fileUrl,
        "thumbnail_url": thumbnailUrl,
        "category_name": categoryName,
      };
}
