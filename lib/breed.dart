import 'dart:convert';

class Breed {
  final String status;
  final List<String> breedList;

  const Breed({required this.status, required this.breedList});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(status: json['status'], breedList: json['message'].cast<String>());
  }
}