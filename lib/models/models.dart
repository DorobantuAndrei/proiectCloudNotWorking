import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/rates_screen.dart';
import '../widgets/show_dialogs_rates.dart';

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
  String currency;

  String date;
  String details;

  bool showTransactions = false;

  Contract({
    this.id, // nn
    this.clientId, // nn
    this.number, // nn
    this.productType, // nn
    this.quantity, // nn
    this.active, // nn (true / false
    this.price,
    this.currency,
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
  double penalizedPrice;
  String currency;

  double humidity;
  double foreignObjects;
  double hectolitre;

  String details;

  String date;
  String carPlate;

  bool selectedForPrint = false;

  MyTransaction({
    this.id,
    this.type,
    this.clientId,
    this.contractId,
    this.furnizorId,
    this.productType,
    this.quantity,
    this.price,
    this.penalizedPrice,
    this.currency,
    this.humidity,
    this.foreignObjects,
    this.hectolitre,
    this.details,
    this.date,
    this.carPlate,
  });
}

class Rate {
  // required
  String id;
  String name;
  String type; // (lunara, trimestriala, semestriala, anuala)
  DateTime issueDate;

  // optional
  String amount;
  int dueDays;

  // need calculation
  DateTime dueDate;

  Rate({
    this.id,
    this.name,
    this.type,
    this.issueDate,
    //
    this.amount,
    this.dueDays,
    //
    this.dueDate,
  });

  String returnDate(DateTime date) {
    if (date == null) return '-';
    return DateFormat("dd/MM/yyyy").format(date);
  }

  Map toJson() => {
        'name': name,
        'type': type,
        'issueDate': issueDate.toIso8601String(),
        //
        'amount': amount,
        'dueDays': dueDays == null ? null : dueDays.toString(),
      };

  static Rate fromJson(String id, Map data) => Rate(
        id: id,
        name: data['name'],
        type: data['type'],
        issueDate: DateTime.parse(data['issueDate']),
        //
        dueDays: data['dueDays'] == null ? null : int.tryParse(data['dueDays']),
        amount: data['amount'],
        //
      );

  void calculateDueDate() {
    if (dueDays != null) {
      dueDate = issueDate.add(Duration(days: dueDays));
    }
  }

  void nextDate() {
    int newDays = 0;
    switch (type) {
      case 'lunara':
        newDays = 1;
        break;
      case 'trimestriala':
        newDays = 3;
        break;
      case 'semestriala':
        newDays = 6;
        break;
      case 'anuale':
        newDays = 12;
        break;
      default:
    }
    issueDate =
        DateTime(issueDate.year, issueDate.month + newDays, issueDate.day);
    calculateDueDate();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  DataRow returnTableRow(BuildContext context) {
    int daysLeft;
    if (dueDays != null) {
      DateTime today = DateTime.now();
      if (dueDate != null) {
        daysLeft = daysBetween(today, dueDate);
      }
    }
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(type)),
        DataCell(Text(returnDate(issueDate))),
        DataCell(Text(
          dueDays == null ? '-' : daysLeft.toString(),
          style: TextStyle(
            color: daysLeft != null
                ? (daysLeft <= 3 ? Colors.red : Colors.black)
                : Colors.black,
          ),
        )),
        DataCell(Text(returnDate(dueDate))),
        DataCell(Text(amount ?? '-')),
        DataCell(
          RateOptionsIcon(
            icon: Icons.check,
            label: 'Achitat',
            onTap: () async {
              await nextDateRate(context, this);
            },
          ),
        ),
        DataCell(
          RateOptionsIcon(
            icon: Icons.edit_outlined,
            label: 'Modifica',
            onTap: () async {
              await modifyRate(context, this);
            },
          ),
        ),
        DataCell(
          RateOptionsIcon(
            icon: Icons.delete_outline,
            label: 'Sterge',
            onTap: () async {
              await deleteRate(context, this);
            },
          ),
        ),
      ],
    );
  }

  void copyFromObject(Rate r) {
    id = r.id;
    name = r.name;
    issueDate = r.issueDate;
    if (r.dueDays != null) {
      dueDays = r.dueDays;
    }
    if (r.amount != null) {
      amount = r.amount;
    }
    calculateDueDate();
  }
}
