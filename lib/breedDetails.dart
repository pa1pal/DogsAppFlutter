import 'dart:convert';

class BreedDetails {
  final String status;
  final String imageUrl;

  const BreedDetails({required this.status, required this.imageUrl});

  factory BreedDetails.fromJson(Map<String, dynamic> json) {
    return BreedDetails(status: json['status'], imageUrl: json['message']);
  }
}