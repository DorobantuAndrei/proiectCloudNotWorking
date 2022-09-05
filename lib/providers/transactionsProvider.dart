import 'dart:convert';

import 'package:achizitii_cereale/models/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LoadTransactions with ChangeNotifier {
  static List<MyTransaction> _transactions = [];

  static double grau = 0;
  static double porumb = 0;
  static double floare = 0;
  static double soia = 0;
  static double rapita = 0;
  static double orz = 0;

  List<MyTransaction> get transactions {
    return _transactions;
  }

  void setTransactions(List<MyTransaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  Future<void> getStock() async {
    await FirebaseDatabase.instance
        .ref()
        .child(databaseStock)
        .once()
        .then((value) {
      final extractedData = value.snapshot.value as Map;
      if (extractedData != null) {
        extractedData.forEach((productType, quantity) {
          try {
            if (productType == 'grau') grau = quantity ?? 0;
            if (productType == 'porumb') porumb = quantity ?? 0;
            if (productType == 'floare') floare = quantity ?? 0;
            if (productType == 'soia') soia = quantity ?? 0;
            if (productType == 'rapita') rapita = quantity ?? 0;
            if (productType == 'orz') orz = quantity ?? 0;
          } catch (e) {
            print(e);
          }
        });
      }
    });
    print('grau ' + grau.toStringAsFixed(2));
    print('porumb ' + porumb.toStringAsFixed(2));
    print('floare ' + floare.toStringAsFixed(2));
    print('soia ' + soia.toStringAsFixed(2));
    print('rapita ' + rapita.toStringAsFixed(2));
    print('orz ' + orz.toStringAsFixed(2));
    notifyListeners();
  }

  double getStockByType(String productType) {
    if (productType == 'grau') return grau;
    if (productType == 'porumb') return porumb;
    if (productType == 'floare') return floare;
    if (productType == 'soia') return soia;
    if (productType == 'rapita') return rapita;
    if (productType == 'orz') return orz;
    return 0;
  }

  void changeStockByType(String productType, double quantity) {
    if (productType == 'grau') grau += quantity;
    if (productType == 'porumb') porumb += quantity;
    if (productType == 'floare') floare += quantity;
    if (productType == 'soia') soia += quantity;
    if (productType == 'rapita') rapita += quantity;
    if (productType == 'orz') orz += quantity;
  }

  Future<void> changeStock(
    String productType,
    double quantity,
    bool isPlus,
  ) async {
    final double currentStock = getStockByType(productType);
    if (!isPlus) quantity = quantity * (-1);
    final url = Uri.parse('$database/$databaseStock.json');
    var response = await http.patch(url,
        body: json.encode({productType: currentStock + quantity}));
    changeStockByType(productType, quantity);
    print('change $productType');
    notifyListeners();
  }

  Future<void> getTransactions() async {
    List<MyTransaction> transactions = [];
    await FirebaseDatabase.instance
        .ref()
        .child(databaseTransactions)
        .once()
        .then((value) {
      final extractedData = value.snapshot.value as Map;
      if (extractedData != null) {
        extractedData.forEach((transactionId, transactionData) {
          try {
            String type = transactionData['type'];
            transactions.add(MyTransaction(
              id: transactionId,
              type: type,
              clientId: type == 'intrare' ? null : transactionData['clientId'],
              contractId:
                  type == 'intrare' ? null : transactionData['contractId'],
              furnizorId:
                  type == 'intrare' ? transactionData['furnizorId'] : null,
              productType: transactionData['productType'],
              quantity: transactionData['quantity'],
              price: transactionData['price'],
              details: transactionData['details'],
              date: transactionData['date'],
            ));
          } catch (e) {
            print(e);
          }
        });
      }
      print('there are ' +
          transactions.length.toStringAsFixed(0) +
          ' transactions');
      for (MyTransaction t in transactions) {
        // print(c.toString());
      }
    });
    _transactions = transactions;
    notifyListeners();
  }

  static MyTransaction getTransactionById(String id) {
    return _transactions.firstWhere((e) => e.id == id, orElse: (() => null));
  }

  Future<void> addTransaction(MyTransaction t) async {
    final url = Uri.parse('$database/$databaseTransactions.json');
    var response = await http.post(url,
        body: json.encode({
          'type': t.type,
          'clientId': t.type == 'intrare' ? null : t.clientId,
          'contractId': t.type == 'intrare' ? null : t.contractId,
          'furnizorId': t.type == 'intrare' ? t.furnizorId : null,
          'productType': t.productType,
          'quantity': t.quantity,
          'price': t.price,
          'details': t.details,
          'date': t.date,
        }));
    var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    t.id = extractedData['name'];
    _transactions.add(t);
    await changeStock(t.productType, t.quantity, t.type == 'intrare');
    print('add transaction');
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    final t = getTransactionById(id);
    await changeStock(t.productType, t.quantity, t.type != 'intrare');
    final url = Uri.parse('$database/$databaseTransactions/$id.json');
    var response = await http.delete(url);
    _transactions.removeWhere((e) => e.id == id);
    print('delete transaction');
    notifyListeners();
  }

  // Future<void> modifyFurnizor({
  //   String id,
  //   String name,
  //   String identifier,
  //   String details,
  // }) async {
  //   final url = Uri.parse('$database/$databaseFurnizori/$id.json');
  //   var response = await http.patch(url,
  //       body: json.encode({
  //         'name': name,
  //         'identifier': identifier,
  //         'details': details,
  //       }));
  //   _furnizori.firstWhere((e) => e.id == id).name = name;
  //   _furnizori.firstWhere((e) => e.id == id).identifier = identifier;
  //   _furnizori.firstWhere((e) => e.id == id).details = details;
  //   print('modify furnizor');
  //   notifyListeners();
  // }

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
