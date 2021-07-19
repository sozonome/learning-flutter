import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nathan',
      theme: ThemeData(primaryColor: Colors.white),
      home: AlbumPage(),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json["title"]);
  }
}

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlbumContainer();
  }
}

class AlbumContainer extends StatefulWidget {
  const AlbumContainer({Key? key}) : super(key: key);

  @override
  _AlbumState createState() => _AlbumState();
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    List responseJson = jsonDecode(response.body);
    return responseJson.map((a) => Album.fromJson(a)).toList();
  } else {
    throw Exception('Failed');
  }
}

class _AlbumState extends State<AlbumContainer> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  Widget _buildRow(Album entry) {
    return ListTile(
        title: Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child: Text(entry.title)),
            Text("${entry.id}", style: TextStyle(color: Colors.grey[500]))
          ],
        ),
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album')),
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int i) {
                    return _buildRow(snapshot.data![i]);
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
