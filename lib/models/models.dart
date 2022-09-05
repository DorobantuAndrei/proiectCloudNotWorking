import 'package:achizitii_cereale/models/product_type.dart';
import 'package:intl/intl.dart';

// CONTRACT
// firma (nn)
// numar 5/10.08.2022 (nn)
// tip produs (nn)
// cantitate (nn)
// acitv da/nu
// pret
// data
// detalii
class Contract {
  String id; // nn

  String clientName;
  String clientIdentifier;

  String clientId; // nn
  String number; // nn
  String productType; // nn
  double quantity; // nn
  bool active; // nn (true / false)
  double price;
  String date;
  String details;

  Contract({
    this.id, // nn
    this.clientId, // nn
    this.number, // nn
    this.productType, // nn
    this.quantity, // nn
    this.active, // nn (true / false
    this.price,
    this.date,
    this.details,
    // doar pt filtrare
    this.clientName,
    this.clientIdentifier,
  });

  String toString() {
    String result = '';
    result += 'Contract - id: ' +
        id +
        ' | quantity: ' +
        quantity.toStringAsFixed(0) +
        ' | date: ' +
        (date ?? '');
    return result;
  }
}

// CLIENT
// nume firma (nn)
// cui (nn)
// detalii
// contracte
class Client {
  String id; // nn

  String name; // nn
  String identifier; // nn
  String details;

  List<Contract> contracts = [];

  bool showContracts = false;

  Client({
    this.id,
    this.name,
    this.identifier,
    this.details,
    this.contracts,
  });

  String toString() {
    String result = '';
    result += 'Client - name: ' + name + ' | id: ' + id + '\n';
    if (contracts != null && contracts.isNotEmpty) {
      for (Contract c in contracts) {
        result += c.toString() + '\n';
      }
    }
    return result;
  }
}

// FURNIZOR
// nume (nn)
// cnp / cui (nn)
class Furnizor {
  String id; // nn

  String name; // nn
  String identifier; // nn
  String details;

  bool showTransactions = false;

  Furnizor({
    this.id,
    this.name,
    this.identifier,
    this.details,
  });
}

// TRANZACTIE
// intrare / iesire (nn)
// furnizor / contract (nn)
// tip produs (nn)
// cantitate (nn)
// pret
// detalii
class MyTransaction {
  String id; // nn

  String type; // nn "intrare" sau "iesire"

  String clientId; // nn "furnizor" sau "contract"
  String contractId; // nn "furnizor" sau "contract"
  String furnizorId; // nn "furnizor" sau "contract"

  String productType; // nn
  double quantity; // nn
  double price;
  String details;

  String date;

  MyTransaction({
    this.id,
    this.type,
    this.clientId,
    this.contractId,
    this.furnizorId,
    this.productType,
    this.quantity,
    this.price,
    this.details,
    this.date,
  });
}
