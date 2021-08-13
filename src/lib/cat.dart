import 'package:flutter/material.dart';

// Cat Image Info
class Cat {
  final String id;
  final String url;

  Cat({
    required this.id,
    required this.url,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    var cat = Cat(
      id: json['id'],
      url: json['url'],
    );

    debugPrint("${cat.id}");
    debugPrint("${cat.url}");
    return cat;
  }
}