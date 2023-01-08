import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:new_flutter_app/Breed.dart';
import 'package:new_flutter_app/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DogsApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DogsApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<String>> fetchBreedList() async {
  final url = Uri.parse("https://dog.ceo/api/breeds/list");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);
    return Breed.fromJson(decodedData).breedList;
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: fetchBreedList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String name = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      developer.log("breed + $name");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(breedName: name)),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
