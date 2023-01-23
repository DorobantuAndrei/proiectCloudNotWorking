import 'dart:convert';

import 'package:achizitii_cereale/models/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LoadFurnizori with ChangeNotifier {
  static List<Furnizor> _furnizori = [];

  List<Furnizor> get furnizori {
    return _furnizori;
  }

  void setFurnizori(List<Furnizor> furnizori) {
    _furnizori = furnizori;
    notifyListeners();
  }

  Future<void> getFurnizori() async {
    List<Furnizor> furnizori = [];
    await FirebaseDatabase.instance
        .ref()
        .child(databaseFurnizori)
        .once()
        .then((value) {
      final extractedData = value.snapshot.value as Map;
      if (extractedData != null) {
        extractedData.forEach((furnizorId, furnizorData) {
          furnizori.add(Furnizor(
            id: furnizorId,
            name: furnizorData['name'],
            identifier: furnizorData['identifier'],
            details: furnizorData['details'],
          ));
        });
      }
      print('there are ' + furnizori.length.toStringAsFixed(0) + ' furnizori');
      for (Furnizor f in furnizori) {
        // print(c.toString());
      }
    });
    _furnizori = furnizori;
    notifyListeners();
  }

  static Furnizor getFurnizorById(String id) {
    return _furnizori.firstWhere((e) => e.id == id, orElse: (() => null));
  }

  void toggleAllTransactions() {
    _furnizori.forEach((e) {
      e.showTransactions = false;
    });
    notifyListeners();
  }

  void toggleTransactions(String id, bool status) {
    _furnizori
        .firstWhere((e) => e.id == id, orElse: (() => null))
        .showTransactions = !status;
    _furnizori.forEach((e) {
      if (e.id != id) e.showTransactions = false;
    });
    notifyListeners();
  }

  Future<void> addFurnizor(Furnizor f) async {
    final url = Uri.parse('$database/$databaseFurnizori.json');
    var response = await http.post(url,
        body: json.encode({
          'name': f.name,
          'identifier': f.identifier,
          'details': f.details,
        }));
    var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    f.id = extractedData['name'];
    _furnizori.add(f);
    print('add furnizor');
    notifyListeners();
  }

  Future<void> deleteFurnizor(String id) async {
    final url = Uri.parse('$database/$databaseFurnizori/$id.json');
    var response = await http.delete(url);
    _furnizori.removeWhere((e) => e.id == id);
    print('delete furnizor');
    notifyListeners();
  }

  Future<void> modifyFurnizor({
    String id,
    String name,
    String identifier,
    String details,
  }) async {
    final url = Uri.parse('$database/$databaseFurnizori/$id.json');
    var response = await http.patch(url,
        body: json.encode({
          'name': name,
          'identifier': identifier,
          'details': details,
        }));
    _furnizori.firstWhere((e) => e.id == id).name = name;
    _furnizori.firstWhere((e) => e.id == id).identifier = identifier;
    _furnizori.firstWhere((e) => e.id == id).details = details;
    print('modify furnizor');
    notifyListeners();
  }

  // Future<void> addContract({String id, Contract contract}) async {
  //   final url = Uri.parse('$database/$databaseClients/$id/contracts.json');
  //   var response = await http.post(url,
  //       body: json.encode({
  //         'clientId': contract.clientId,
  //         'number': contract.number,
  //         'productType': contract.productType,
  //         'quantity': contract.quantity,
  //         'active': contract.active,
  //         'price': contract.price,
  //         'date': contract.date.toIso8601String(),
  //         'details': contract.details,
  //       }));
  //   var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
  //   contract.id = extractedData['name'];
  //   _clients.firstWhere((e) => e.id == id).contracts.add(contract);
  //   print('add contract');
  //   notifyListeners();
  // }

  // Future<void> deleteContract(String clientId, String contractId) async {
  //   final url = Uri.parse(
  //       '$database/$databaseClients/$clientId/contracts/$contractId.json');
  //   var response = await http.delete(url);
  //   _clients
  //       .firstWhere((e) => e.id == clientId)
  //       .contracts
  //       .removeWhere((e) => e.id == contractId);
  //   print('delete contract');
  //   notifyListeners();
  // }

  // Future<void> modifyContract({
  //   String id,
  //   Contract contract,
  // }) async {
  //   final url = Uri.parse(
  //       '$database/$databaseClients/$id/contracts/${contract.id}.json');
  //   var response = await http.patch(url,
  //       body: json.encode({
  //         'clientId': contract.clientId,
  //         'number': contract.number,
  //         'productType': contract.productType,
  //         'quantity': contract.quantity,
  //         'active': contract.active,
  //         'price': contract.price,
  //         'date': contract.date.toIso8601String(),
  //         'details': contract.details,
  //       }));
  //   _clients.firstWhere((e) => e.id == id).contracts[_clients
  //       .firstWhere((e) => e.id == id)
  //       .contracts
  //       .indexWhere((e) => e.id == contract.id)] = contract;
  //   print('modify contract');
  //   notifyListeners();
  // }
}
