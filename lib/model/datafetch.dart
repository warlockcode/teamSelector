import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:teamselector/model/Person.dart';


Future<List<Person>> fetchPerson() async {
  var data = await rootBundle.loadString("assets/heliverse_mock_data.json");

  return compute(parseBlogs, data);
}

List<Person> parseBlogs(String responseBody) {
  final data = jsonDecode(responseBody);

  final parsed =data.cast<Map<String, dynamic>>();

  return parsed.map<Person>((json) => Person.fromJson(json)).toList();
}