import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:new_flutter_app/Breed.dart';
import 'package:new_flutter_app/breedDetails.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.breedName});

  final String breedName;

  @override
  State<DetailsPage> createState() => _DetailsState(breedName);
}

Future<String> fetchBreedDetails(String bName) async {
  final url = Uri.parse("https://dog.ceo/api/breed/$bName/images/random");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);
    return BreedDetails.fromJson(decodedData).imageUrl;
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class _DetailsState extends State<DetailsPage> {
  _DetailsState(this.bName);

  final String bName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(bName.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          FutureBuilder<String>(
            future: fetchBreedDetails(bName),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String? imageUrl = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageUrl!),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
