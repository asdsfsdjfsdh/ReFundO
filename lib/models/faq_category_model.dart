class FaqCategory {
  final int? id;
  final String? categoryName;
  final String? categoryDescription;
  final int? parentId;
  final int? status;
  final DateTime? createTime;
  final DateTime? updateTime;

  FaqCategory({
    this.id,
    this.categoryName,
    this.categoryDescription,
    this.parentId,
    this.status,
    this.createTime,
    this.updateTime,
  });

  factory FaqCategory.fromJson(Map<String, dynamic> json) {
    FaqCategory faqCategory =  FaqCategory(
      id: json['id'] as int?,
      categoryName: json['categoryName'] as String?,
      categoryDescription: json['categoryDescription'] as String?,
      parentId: json['parentId'] as int?,
      status: json['status'] as int?,
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'] as String)
          : null,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : null,
    );
    return faqCategory;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'CategoryName': categoryName,
      'CategoryDescription': categoryDescription,
      'ParentId': parentId,
      'Status': status,
      'CreateTime': createTime?.toIso8601String(),
      'UpdateTime': updateTime?.toIso8601String(),
    };
  }
}
