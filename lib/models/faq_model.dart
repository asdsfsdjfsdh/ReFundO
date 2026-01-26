class Faq {
  final int? id;
  final int? categoryId;
  final String? question;
  final String? answer;
  final int? viewCount;
  final int? isTop;
  final int? status;
  final DateTime? createTime;
  final DateTime? updateTime;

  Faq({
    this.id,
    this.categoryId,
    this.question,
    this.answer,
    this.viewCount,
    this.isTop,
    this.status,
    this.createTime,
    this.updateTime,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: _parseInt(json['id']),
      categoryId: _parseInt(json['categoryId']),
      question: json['question']?.toString(),
      answer: json['answer']?.toString(),
      viewCount: _parseInt(json['viewCount']),
      isTop: _parseInt(json['isTop']),
      status: _parseInt(json['status']),
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'].toString())
          : null,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'].toString())
          : null,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'question': question,
      'answer': answer,
      'viewCount': viewCount,
      'isTop': isTop,
      'status': status,
      'createTime': createTime?.toIso8601String(),
      'updateTime': updateTime?.toIso8601String(),
    };
  }

  // Helper property to check if this FAQ is pinned/top
  bool get isPinned => isTop == 1;
}
