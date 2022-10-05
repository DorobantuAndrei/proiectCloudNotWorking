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
              penalizedPrice:
                  type == 'intrare' ? transactionData['penalizedPrice'] : null,
              currency: transactionData['currency'],
              details: transactionData['details'],
              date: transactionData['date'],
              humidity: transactionData['humidity'],
              foreignObjects: transactionData['foreignObjects'],
              hectolitre: transactionData['hectolitre'],
              carPlate: transactionData['carPlate'],
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
          'penalizedPrice': t.penalizedPrice,
          'currency': t.currency,
          'details': t.details,
          'date': t.date,
          'humidity': t.humidity,
          'foreignObjects': t.foreignObjects,
          'hectolitre': t.hectolitre,
          'carPlate': t.carPlate,
        }));
    var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    t.id = extractedData['name'];
    _transactions.add(t);
    await changeStock(t.productType, t.quantity, t.type == 'intrare');
    print('add transaction');
    notifyListeners();
  }

  Future<void> modifyTransaction(
    MyTransaction t,
    double oldQuantity,
    String oldType,
  ) async {
    final url = Uri.parse('$database/$databaseTransactions/${t.id}.json');
    var response = await http.patch(url,
        body: json.encode({
          'type': t.type,
          'clientId': t.type == 'intrare' ? null : t.clientId,
          'contractId': t.type == 'intrare' ? null : t.contractId,
          'furnizorId': t.type == 'intrare' ? t.furnizorId : null,
          'productType': t.productType,
          'quantity': t.quantity,
          'price': t.price,
          'penalizedPrice': t.penalizedPrice,
          'currency': t.currency,
          'details': t.details,
          'date': t.date,
          'humidity': t.humidity,
          'foreignObjects': t.foreignObjects,
          'hectolitre': t.hectolitre,
          'carPlate': t.carPlate,
        }));

    if (t.quantity != oldQuantity) {
      if (oldType == 'intrare' && t.type == 'intrare') {
        if (t.quantity > oldQuantity) {
          await changeStock(t.productType, t.quantity - oldQuantity, true);
        } else {
          await changeStock(t.productType, oldQuantity - t.quantity, false);
        }
      } else if (oldType == 'iesire' && t.type == 'iesire') {
        if (t.quantity > oldQuantity) {
          await changeStock(t.productType, t.quantity - oldQuantity, false);
        } else {
          await changeStock(t.productType, oldQuantity - t.quantity, true);
        }
      } else if (oldType == 'intrare' && t.type == 'iesire') {
        await changeStock(t.productType, oldQuantity + t.quantity, false);
      } else if (oldType == 'iesire' && t.type == 'intrare') {
        await changeStock(t.productType, oldQuantity + t.quantity, true);
      }
    } else {
      if (oldType == 'intrare' && t.type == 'iesire') {
        await changeStock(t.productType, oldQuantity + t.quantity, false);
      } else if (oldType == 'iesire' && t.type == 'intrare') {
        await changeStock(t.productType, oldQuantity + t.quantity, true);
      }
    }

    // old: intrare
    // new: intrare
    // => daca quantity > oldQuantity => adauga diferenta
    // => daca quantity < oldQuantity => scade diferenta

    // old: iesire
    // new: iesire
    // => daca quantity > oldQuantity => scade diferenta
    // => daca quantity < oldQuantity => adauga diferenta

    // old: intrare
    // new: iesire
    // => scad oldQuantity si scad quantity

    // old: iesire
    // new: intrare
    // => adaug oldQuantity si adaug quantity

    Map<String, double> params = cerealeParams[t.productType];

    _transactions.firstWhere((e) => e.id == t.id).type = t.type;
    _transactions.firstWhere((e) => e.id == t.id).clientId =
        t.type == 'intrare' ? null : t.clientId;
    _transactions.firstWhere((e) => e.id == t.id).contractId =
        t.type == 'intrare' ? null : t.contractId;
    _transactions.firstWhere((e) => e.id == t.id).furnizorId =
        t.type == 'intrare' ? t.furnizorId : null;
    _transactions.firstWhere((e) => e.id == t.id).productType = t.productType;
    _transactions.firstWhere((e) => e.id == t.id).quantity = t.quantity;
    _transactions.firstWhere((e) => e.id == t.id).price = t.price;
    _transactions.firstWhere((e) => e.id == t.id).penalizedPrice =
        t.penalizedPrice;
    _transactions.firstWhere((e) => e.id == t.id).currency = t.currency;
    _transactions.firstWhere((e) => e.id == t.id).details = t.details;
    _transactions.firstWhere((e) => e.id == t.id).date = t.date;
    _transactions.firstWhere((e) => e.id == t.id).carPlate = t.carPlate;

    _transactions.firstWhere((e) => e.id == t.id).humidity =
        (t.type == 'intrare' && params['humidity'] != null) ? t.humidity : null;
    _transactions.firstWhere((e) => e.id == t.id).foreignObjects =
        (t.type == 'intrare' && params['foreignObjects'] != null)
            ? t.foreignObjects
            : null;
    _transactions.firstWhere((e) => e.id == t.id).hectolitre =
        (t.type == 'intrare' && params['hectolitre'] != null)
            ? t.hectolitre
            : null;

    print('modify transaction');
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

  void toggleTransactionForPrint(String id, bool value) {
    _transactions.firstWhere((e) => e.id == id).selectedForPrint = value;
    notifyListeners();
  }

  void toggleAllTransactionForPrint(bool value) {
    _transactions
        // .where((element) => element.furnizorId == id)
        .forEach(((element) => element.selectedForPrint = false));
    notifyListeners();
  }

  void toggleAllTransactionForPrintForTx(String id, bool value) {
    _transactions
        .where((element) => element.furnizorId == id)
        .forEach(((element) => element.selectedForPrint = value));
    notifyListeners();
  }
}
