import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flickr Image App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageUrl = '';
  final String flickrApiKey = '9f8aadba894e1a397e1eba8cd265f5dd';
  final String flickrUserId = 'CyaINhxLL';

  Future<void> fetchRandomImage() async {
    final endpoint =
        'https://www.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=$flickrApiKey&user_id=$flickrUserId&format=json&nojsoncallback=1';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final photos = jsonData['photos']['photo'] as List<dynamic>;

      if (photos.isNotEmpty) {
        final randomIndex = Random().nextInt(photos.length);
        final photo = photos[randomIndex];
        final farm = photo['farm'];
        final server = photo['server'];
        final id = photo['id'];
        final secret = photo['secret'];

        setState(() {
          imageUrl =
          'https://farm$farm.staticflickr.com/$server/$id' '_$secret.jpg';
        });
      }
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flickr Image App'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl.isNotEmpty
                  ? CachedNetworkImage(imageUrl: imageUrl)
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => fetchRandomImage(),
                child: Text('Show me some cars!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
