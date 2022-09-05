import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String kTitle = 'Achizitii cereale';
const bool kIsWeb = true;

const String databaseClients = 'clients';
const String databaseFurnizori = 'furnizori';
const String databaseTransactions = 'transactions';
const String databaseStock = 'cereale';

const String database =
    'https://achizitiicereale-f6819-default-rtdb.europe-west1.firebasedatabase.app';
const String databaseFunctions = "";

const String kUrlTerms = 'https://pages.flycricket.io/bella-italia/terms.html';
const String kApiKey = 'AIzaSyAsvPoOW6q1ucY4BL0DobJd80oAQrclZbA';

// const Color kPrimaryColor = Color.fromRGBO(7, 113, 52, 1);
// const Color kAccentColor = Color.fromARGB(255, 12, 180, 82);

NumberFormat numberFormat = NumberFormat("#,##0.00", "ro_RO");

const Color kPrimaryColor = Color.fromRGBO(6, 70, 53, 1);
const Color kAccentColor = Color.fromRGBO(81, 146, 89, 1);
// const Color kAccentColor = Color.fromRGBO(240, 187, 98, 1);

const List<String> cereale = [
  'grau',
  'porumb',
  'floare',
  'soia',
  'rapita',
  'orz',
];
