import 'dart:convert';

import 'package:achizitii_cereale/models/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LoadClients with ChangeNotifier {
  static List<Client> _clients = [];

  List<Client> get clients {
    return _clients;
  }

  List<Contract> get contracts {
    List<Contract> contracts = [];
    _clients.forEach((e) {
      e.contracts.forEach((ee) {
        contracts.add(ee);
      });
    });
    return contracts;
  }

  void setClients(List<Client> clients) {
    _clients = clients;
    notifyListeners();
  }

  Future<void> getClients() async {
    List<Client> clients = [];

    await FirebaseDatabase.instance
        .ref()
        .child(databaseClients)
        .once()
        .then((value) {
      final extractedData = value.snapshot.value as Map;
      if (extractedData != null) {
        extractedData.forEach((clientId, clientData) {
          List<Contract> contracts = [];
          var contractsData = clientData['contracts'];
          if (contractsData != null) {
            contractsData.forEach((contractId, contractData) {
              try {
                contracts.add(Contract(
                  id: contractId,
                  clientId: clientId,
                  number: contractData['number'],
                  productType: contractData['productType'],
                  quantity: contractData['quantity'],
                  active: contractData['active'],
                  price: contractData['price'],
                  currency: contractData['currency'],
                  date: contractData['date'],
                  details: contractData['details'],
                  clientName: clientData['name'],
                  clientIdentifier: clientData['identifier'],
                ));
              } catch (e) {
                print(contractData['date']);
                print(e);
              }
            });
          }
          clients.add(Client(
            id: clientId,
            name: clientData['name'],
            identifier: clientData['identifier'],
            details: clientData['details'],
            contracts: contracts,
          ));
        });
      }
      print('there are ' + clients.length.toStringAsFixed(0) + ' clients');
      for (Client c in clients) {
        // print(c.toString());
      }
    });
    _clients = clients;
    notifyListeners();
  }

  static Client getClientById(String id) {
    return _clients.firstWhere((e) => e.id == id, orElse: (() => null));
  }

  static Contract getContractById(String clientId, String contractId) {
    Client c =
        _clients.firstWhere((e) => e.id == clientId, orElse: (() => null));
    if (c != null) {
      return c.contracts
          .firstWhere((e) => e.id == contractId, orElse: (() => null));
    } else {
      return null;
    }
  }

  void toggleAllContracts() {
    _clients.forEach((e) {
      e.showContracts = false;
    });
    notifyListeners();
  }

  void toggleContracts(String id, bool status) {
    _clients.firstWhere((e) => e.id == id, orElse: (() => null)).showContracts =
        !status;
    _clients.forEach((e) {
      if (e.id != id) e.showContracts = false;
    });
    notifyListeners();
  }

  void toggleAllTransactions() {
    _clients.forEach((e) {
      e.contracts.forEach((element) {
        element.showTransactions = false;
      });
    });
    notifyListeners();
  }

  void toggleTransactions(String clientId, String contractId, bool status) {
    _clients
        .firstWhere((e) => e.id == clientId, orElse: (() => null))
        .contracts
        .firstWhere((e) => e.id == contractId)
        .showTransactions = !status;

    _clients.forEach((e) {
      e.contracts.forEach((element) {
        if (element.id != contractId) element.showTransactions = false;
      });
    });
    notifyListeners();
  }

  Future<void> addClient(Client c) async {
    try {
      final url = Uri.parse('$database/$databaseClients.json');
      var response = await http.post(url,
          body: json.encode({
            'name': c.name,
            'identifier': c.identifier,
            'details': c.details,
          }));
      var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      c.id = extractedData['name'];
      _clients.add(c);
      print('add client');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteClient(String id) async {
    final url = Uri.parse('$database/$databaseClients/$id.json');
    var response = await http.delete(url);
    _clients.removeWhere((e) => e.id == id);
    print('delete client');
    notifyListeners();
  }

  Future<void> modifyClient({
    String id,
    String name,
    String identifier,
    String details,
    List<Contract> contracts,
  }) async {
    final url = Uri.parse('$database/$databaseClients/$id.json');
    var response = await http.patch(url,
        body: json.encode({
          'name': name,
          'identifier': identifier,
          'details': details,
        }));
    _clients.firstWhere((e) => e.id == id).name = name;
    _clients.firstWhere((e) => e.id == id).identifier = identifier;
    _clients.firstWhere((e) => e.id == id).details = details;
    print('modify client');
    notifyListeners();
  }

  Future<void> addContract({String id, Contract contract}) async {
    final url = Uri.parse('$database/$databaseClients/$id/contracts.json');
    var response = await http.post(url,
        body: json.encode({
          'clientId': contract.clientId,
          'number': contract.number,
          'productType': contract.productType,
          'quantity': contract.quantity,
          'active': contract.active,
          'price': contract.price,
          'currency': contract.currency,
          'date': contract.date,
          'details': contract.details,
        }));
    var extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
    contract.id = extractedData['name'];
    _clients.firstWhere((e) => e.id == id).contracts.add(contract);
    print('add contract');
    notifyListeners();
  }

  Future<void> deleteContract(String clientId, String contractId) async {
    final url = Uri.parse(
        '$database/$databaseClients/$clientId/contracts/$contractId.json');
    var response = await http.delete(url);
    _clients
        .firstWhere((e) => e.id == clientId)
        .contracts
        .removeWhere((e) => e.id == contractId);
    print('delete contract');
    notifyListeners();
  }

  Future<void> modifyContract({
    String id,
    Contract contract,
  }) async {
    final url = Uri.parse(
        '$database/$databaseClients/$id/contracts/${contract.id}.json');
    var response = await http.patch(url,
        body: json.encode({
          'clientId': contract.clientId,
          'number': contract.number,
          'productType': contract.productType,
          'quantity': contract.quantity,
          'active': contract.active,
          'price': contract.price,
          'currency': contract.currency,
          'date': contract.date,
          'details': contract.details,
        }));
    _clients.firstWhere((e) => e.id == id).contracts[_clients
        .firstWhere((e) => e.id == id)
        .contracts
        .indexWhere((e) => e.id == contract.id)] = contract;
    print('modify contract');
    notifyListeners();
  }
}
