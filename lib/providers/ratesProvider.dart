import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/models.dart';

class LoadRates with ChangeNotifier {
  static List<Rate> _rates = [];

  List<Rate> get rates {
    return _rates;
  }

  void setRates(List<Rate> rates) {
    _rates = rates;
    notifyListeners();
  }

  Future<void> getRates() async {
    List<Rate> rates = [];

    await FirebaseDatabase.instance
        .ref()
        .child(databaseRates)
        .once()
        .then((value) {
      final extractedData = value.snapshot.value as Map;
      if (extractedData != null) {
        extractedData.forEach((rateId, rateData) {
          // print(rateId);
          // print(rateData['dueDays']);
          Rate r = Rate.fromJson(rateId, rateData);
          r.calculateDueDate();
          rates.add(r);
        });
      }
      print('there are ' + rates.length.toStringAsFixed(0) + ' rates');
    });
    _rates = rates;
    notifyListeners();
  }

  static Rate getRateById(String id) {
    return _rates.firstWhere((e) => e.id == id, orElse: (() => null));
  }

  Future<void> addRate(Rate r) async {
    try {
      r.calculateDueDate();
      final url = Uri.parse('$database/$databaseRates.json');
      var response = await http.post(url, body: json.encode(r.toJson()));
      var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      r.id = extractedData['name'];
      _rates.add(r);
      print('add rate');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteRate(String id) async {
    final url = Uri.parse('$database/$databaseRates/$id.json');
    var response = await http.delete(url);
    _rates.removeWhere((e) => e.id == id);
    print('delete rate');
    notifyListeners();
  }

  Future<void> modifyRate(Rate r) async {
    final url = Uri.parse('$database/$databaseRates/${r.id}.json');
    var response = await http.patch(url, body: json.encode(r.toJson()));
    _rates.firstWhere((e) => e.id == r.id).copyFromObject(r);
    print('modify rate');
    notifyListeners();
  }

  Future<void> nextDate(String id) async {
    _rates.firstWhere((e) => e.id == id).nextDate();
    Rate r = getRateById(id);
    final url = Uri.parse('$database/$databaseRates/$id.json');
    var response = await http.patch(url, body: json.encode(r.toJson()));
    print('next date rate');
    notifyListeners();
  }
}
