import 'package:flutter/foundation.dart';

import '../../../core/error/app_exception.dart';

@immutable
class Article {
  const Article({required this.id, required this.title, required this.body});

  /// Throws a [ParseException] if [json] doesn't have the expected shape,
  /// so a backend change shows up as a clear error, not a crash.
  factory Article.fromJson(Object? json) {
    if (json case {
      'id': final int id,
      'title': final String title,
      'body': final String body,
    }) {
      return Article(id: id, title: title, body: body);
    }
    throw ParseException('Unexpected article JSON: $json');
  }

  final int id;
  final String title;
  final String body;

  @override
  bool operator ==(Object other) =>
      other is Article &&
      other.id == id &&
      other.title == title &&
      other.body == body;

  @override
  int get hashCode => Object.hash(id, title, body);
}
