import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Cat> fetchCat() async {
  final response =
      await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));

  if (response.statusCode == 200) {
    List responseJson = json.decode(response.body);
    return new Cat.fromJson(responseJson[0]);
  } else {
    throw Exception('Failed to load Cat');
  }
}

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

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Cat> futureCat;

  @override
  void initState() {
    super.initState();
    futureCat = fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nayn Nayn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nayn Nayn'),
        ),
        body: Center(
          child: FutureBuilder<Cat>(
            future: futureCat,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint("------------------------------");
                String imageUrl = snapshot.data!.url;
                ui.platformViewRegistry.registerViewFactory(
                  imageUrl,
                  (int _) => ImageElement()
                  ..src = imageUrl
                  ..style.objectFit = 'cover'
                );
                return HtmlElementView(
                  viewType: imageUrl,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}