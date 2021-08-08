import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;


// 広告用
double adHeight = 100;

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // running on the web!
      adHeight = 100;
    } else {
      adHeight = 0;
    }

    futureCat = fetchCat();

    _timer = Timer.periodic(Duration(seconds: 10), _onTimer);
  }

  void _onTimer(Timer timer) {
      setState(() {
        futureCat = fetchCat();
      });
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
          child: Column(
            children: [
              FutureBuilder<Cat>(
              future: futureCat,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String imageUrl = snapshot.data!.url;
                  ui.platformViewRegistry.registerViewFactory(
                    imageUrl,
                    (int _) => ImageElement()
                    ..src = imageUrl
                    ..style.objectFit = 'contain'
                    ..style.maxHeight = 'calc(100% - 100px)'
                  );
                  return HtmlElementView(
                    viewType: imageUrl,
                  );
                }
                  return CircularProgressIndicator();
                },
              ),
              Container(height: adHeight, color: Colors.red),
            ],
          ),
        ),

      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: adHeight),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: (){
              if(_timer != null){
                _timer?.cancel();
              }
              setState(() {
                futureCat = fetchCat();
                _timer = Timer.periodic(Duration(seconds: 10), _onTimer);
              });
            },
            tooltip: 'Change Cat',
            child: Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: (){
              if(_timer != null){
                _timer?.cancel();
              }
            },
            tooltip: 'Pause Cat',
            child: Icon(Icons.pause),
          ),
        ],
      ),
      ),

        // refreshActionButton: FloatingActionButton(
        //   onPressed: (){
        //     if(_timer != null){
        //       _timer?.cancel();
        //     }
        //     setState(() {
        //       futureCat = fetchCat();
        //       _timer = Timer.periodic(Duration(seconds: 10), _onTimer);
        //     });
        //   },
        //   tooltip: 'Change Cat',
        //   child: Icon(Icons.refresh),

      ),
    );
  }
}