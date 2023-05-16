import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String kTitle = 'Achizitii cereale';
const bool kIsWeb = true;
const bool kCanSee = false;

const bool isTest = false;
const String isTestDatabase = isTest ? 'Test' : '';

const String databaseRates = 'rates' + isTestDatabase;
const String databaseClients = 'clients' + isTestDatabase;
const String databaseFurnizori = 'furnizori' + isTestDatabase;
const String databaseTransactions = 'transactions' + isTestDatabase;
const String databaseStock = 'cereale' + isTestDatabase;

const int kSelectedPage = 0;

const String database =
    'https://proiectcloud-3d8e9-default-rtdb.europe-west1.firebasedatabase.app';
const String databaseFunctions = "";

NumberFormat numberFormat = NumberFormat("#,##0.00", "ro_RO");

const Color kPrimaryColor = Color.fromRGBO(6, 70, 53, 1);
const Color kAccentColor = Color.fromRGBO(81, 146, 89, 1);
const Color kGrey = Color.fromARGB(255, 150, 168, 173);

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return kPrimaryColor;
  }
  return kAccentColor;
}

const List<String> cereale = [
  'grau',
  'porumb',
  'floare',
  'soia',
  'rapita',
  'orz',
];

Map<String, Map<String, double>> cerealeParams = {
  'grau': {
    'humidity': 14.0,
    'foreignObjects': 2.0,
    'hectolitre': 77.0,
  },
  'porumb': {
    'humidity': 14.5,
    'foreignObjects': null,
    'hectolitre': null,
  },
  'floare': {
    'humidity': 9.0,
    'foreignObjects': 2.0,
    'hectolitre': null,
  },
  'soia': {
    'humidity': 12.0,
    'foreignObjects': 2.0,
    'hectolitre': null,
  },
  'rapita': {
    'humidity': 9.0,
    'foreignObjects': 2.0,
    'hectolitre': null,
  },
  'orz': {
    'humidity': 14.0,
    'foreignObjects': 2.0,
    'hectolitre': 62.0,
  },
};

const List<String> currencies = [
  'ron',
  'usd',
  'eur',
];

const List<String> rateTypes = [
  'lunara',
  'trimestriala',
  'semestriala',
  'anuale',
];
