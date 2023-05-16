import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/providers/transactionsProvider.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import '../providers/clientsProvider.dart';

Future<void> addTranzactie(BuildContext context, String productType) async {
  final _formKey = GlobalKey<FormState>();

  print(productType);

  // type: isIntrare
  bool isIntrare = true;
  bool isCalculatedManual = false;

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final penalizedPriceController = TextEditingController();
  final currencyController = TextEditingController(text: 'ron');
  final detailsController = TextEditingController();
  final dateController = TextEditingController();
  final carPlateController = TextEditingController();

  final humidityController = TextEditingController();
  final foreignObjectsController = TextEditingController();
  final hectolitreController = TextEditingController();

  final List<Furnizor> furnizori =
      Provider.of<LoadFurnizori>(context, listen: false).furnizori;
  Furnizor selectedFurnior;

  final List<Client> clients =
      Provider.of<LoadClients>(context, listen: false).clients;
  Contract selectedContract;

  Map<String, double> params = cerealeParams[productType];

  Future<void> submitForm() {
    if ((isIntrare && selectedFurnior != null) ||
        (isIntrare == false && selectedContract != null)) {
      if (_formKey.currentState.validate()) {
        try {
          String type = isIntrare ? 'intrare' : 'iesire';
          Provider.of<LoadTransactions>(context, listen: false)
              .addTransaction(MyTransaction(
            type: type,
            clientId: type == 'intrare' ? null : selectedContract.clientId,
            contractId: type == 'intrare' ? null : selectedContract.id,
            furnizorId: type == 'intrare' ? selectedFurnior.id : null,
            productType: productType,
            quantity: double.parse(quantityController.text),
            price: (priceController.text == null || priceController.text == '')
                ? null
                : double.parse(priceController.text),
            penalizedPrice: (type == 'intrare')
                ? ((penalizedPriceController.text == null ||
                        penalizedPriceController.text == '')
                    ? null
                    : double.parse(penalizedPriceController.text))
                : (null),
            currency: currencyController.text,
            details: detailsController.text,
            date: dateController.text,
            humidity: type == 'intrare'
                ? (params['humidity'] != null
                    ? double.parse(humidityController.text)
                    : null)
                : null,
            foreignObjects: type == 'intrare'
                ? (params['foreignObjects'] != null
                    ? double.parse(foreignObjectsController.text)
                    : null)
                : null,
            hectolitre: type == 'intrare'
                ? (params['hectolitre'] != null
                    ? double.parse(hectolitreController.text)
                    : null)
                : null,
            carPlate: carPlateController.text,
          ));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adaugare tranzactie...'),
              duration: Duration(seconds: 1),
            ),
          );

          Navigator.of(context).pop();
        } catch (e) {
          print(e);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nu ati ales contract / furnizor!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<List<Furnizor>> filterFurnizori(String x) async {
    return furnizori
        .where((e) =>
            e.name.toLowerCase().contains(x.toLowerCase()) ||
            e.identifier.toLowerCase().contains(x.toLowerCase()))
        .toList();
  }

  Future<List<Contract>> filterContracte(String x) async {
    List<Contract> contracte = [];
    try {
      clients.forEach((e) {
        e.contracts.forEach((c) {
          contracte.add(c);
        });
      });
      contracte = contracte
          .where((e) =>
              (e.clientName.toLowerCase().contains(x.toLowerCase()) ||
                  e.clientIdentifier.toLowerCase().contains(x.toLowerCase()) ||
                  e.number.toLowerCase().contains(x.toLowerCase())) &&
              e.active &&
              e.productType == productType)
          .toList();
    } catch (e) {
      print(e);
    }
    return contracte;
  }

  const primaryColor = kPrimaryColor;
  const secondaryColor = kAccentColor;
  const accentColor = Color(0xffffffff);
  const backgroundColor = Color(0xffffffff);
  const errorColor = Color(0xffEF4444);

  bool calculateAllParams() {
    return ((params['humidity'] != null)
            ? (humidityController.text != '')
            : true) &&
        ((params['foreignObjects'] != null)
            ? (foreignObjectsController.text != '')
            : true) &&
        ((params['hectolitre'] != null)
            ? (hectolitreController.text != '')
            : true);
  }

  bool isAllParams = calculateAllParams();
  double penalizedPricePercent = 0;

  void calculatePenalizedPrice() {
    if (isAllParams && priceController.text != '') {
      double percent = 1;
      if (params['humidity'] != null) {
        if (double.parse(humidityController.text) > params['humidity']) {
          percent -=
              ((double.parse(humidityController.text) - params['humidity']) /
                  100);
        }
      }
      if (params['foreignObjects'] != null) {
        if (double.parse(foreignObjectsController.text) >
            params['foreignObjects']) {
          percent -= ((double.parse(foreignObjectsController.text) -
                  params['foreignObjects']) /
              100);
        }
      }
      if (params['hectolitre'] != null) {
        if (productType == 'orz') {
          if (double.parse(hectolitreController.text) < params['hectolitre']) {
            percent -= ((params['hectolitre'] -
                    double.parse(hectolitreController.text)) /
                100);
          }
        } else {
          if (double.parse(hectolitreController.text) > params['hectolitre']) {
            isCalculatedManual = true;
          } else {
            isCalculatedManual = false;
          }
        }
      }
      penalizedPriceController.text =
          (double.parse(priceController.text) * percent).toStringAsFixed(2);
      penalizedPricePercent = (1 - percent) * 100;
    } else {
      penalizedPriceController.text = '';
      penalizedPricePercent = 0;
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                'Adauga tranzactie noua',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // product type
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(text: 'Tip produs: '),
                                TextSpan(
                                  text: productType,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // transaction type
                          const SizedBox(height: 8),
                          const Text(
                            'Tip tranzactie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Iesire',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Switch(
                                  value: isIntrare,
                                  onChanged: (value) {
                                    setState(() {
                                      isIntrare = value;
                                      currencyController.text = 'ron';
                                      selectedFurnior = null;
                                      selectedContract = null;
                                    });
                                  },
                                  activeTrackColor: Colors.grey,
                                  activeColor: Colors.green,
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.redAccent,
                                ),
                                const Text(
                                  'Intrare',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // client
                          const Text(
                            'Contracte / Furnizori',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isIntrare)
                            DropdownSearch<Furnizor>(
                              popupBarrierColor: kPrimaryColor.withOpacity(0.1),
                              mode: Mode.MENU,
                              showSearchBox: true,
                              label: "Furnizori",
                              onFind: (String filter) =>
                                  filterFurnizori(filter),
                              itemAsString: (Furnizor f) =>
                                  f.name + ' - ' + f.identifier,
                              onChanged: (Furnizor f) {
                                print(f.name);
                                selectedFurnior = f;
                                selectedContract = null;
                                currencyController.text = 'ron';
                                setState(() {});
                              },
                            )
                          else
                            DropdownSearch<Contract>(
                              mode: Mode.MENU,
                              popupBarrierColor: kPrimaryColor.withOpacity(0.1),
                              showSearchBox: true,
                              label: "Contracte",
                              onFind: (String filter) =>
                                  filterContracte(filter),
                              itemAsString: (Contract c) =>
                                  c.clientName +
                                  ' - ' +
                                  c.clientIdentifier +
                                  ' - ' +
                                  c.number,
                              onChanged: (Contract c) {
                                print(c.clientId);
                                selectedFurnior = null;
                                selectedContract = c;
                                currencyController.text = c.currency;
                                setState(() {});
                              },
                            ),

                          // quantity
                          const SizedBox(height: 8),
                          const Text(
                            'Cantitate',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: quantityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cantitatea este goala';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: accentColor,
                              hintText: 'introdu cantitatea aici',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(.75)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          // umiditate si corpuri straine
                          if (isIntrare)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (params['humidity'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Umiditate: ' +
                                              params['humidity']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: humidityController,
                                          validator: (value) {
                                            if (params['humidity'] != null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Umiditatea este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText: 'introdu umiditate aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (params['humidity'] != null)
                                  const SizedBox(width: 20),
                                if (params['foreignObjects'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Corpuri straine: ' +
                                              params['foreignObjects']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: foreignObjectsController,
                                          validator: (value) {
                                            if (params['foreignObjects'] !=
                                                null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Corpuri straine este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText:
                                                'introdu corpuri straine aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (params['hectolitre'] != null)
                                  const SizedBox(width: 20),
                                if (params['hectolitre'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Masa Hectolitrica: ' +
                                              params['hectolitre']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: hectolitreController,
                                          validator: (value) {
                                            if (params['hectolitre'] != null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Masa Hectolitrica este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText:
                                                'introdu Masa Hectolitrica aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          // price
                          Container(
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Pret',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: priceController,
                                        onChanged: (value) {
                                          print(value);
                                          if (isIntrare) {
                                            if (isCalculatedManual ||
                                                !isAllParams) {
                                            } else {
                                              if (value != '') {
                                                calculatePenalizedPrice();
                                                setState(() {});
                                              } else {
                                                penalizedPriceController.text =
                                                    '';
                                                setState(() {});
                                              }
                                            }
                                          }
                                        },
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: accentColor,
                                          hintText: 'introdu pretul aici',
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(.75)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: errorColor, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Moneda',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: kPrimaryColor,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 20.0,
                                        ),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          focusColor: Colors.white,
                                          value: currencyController.text,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: kAccentColor),
                                          underline: Container(),
                                          onChanged: isIntrare
                                              ? (String newValue) {
                                                  currencyController.text =
                                                      newValue;
                                                  setState(() {});
                                                }
                                              : null,
                                          items: currencies
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isIntrare)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // pret penalizat
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        'Pret penalizat: ' +
                                            penalizedPricePercent
                                                .toStringAsFixed(2) +
                                            '%',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: penalizedPriceController,
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        enabled: isCalculatedManual,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: accentColor,
                                          hintText: isCalculatedManual
                                              ? 'introdu valoare'
                                              : 'se calculeaza automat',
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(.75)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: errorColor, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 30),
                                      CheckboxListTile(
                                        activeColor: kAccentColor,
                                        checkColor: Colors.white,
                                        tileColor: Colors.grey[300],
                                        selectedTileColor: Colors.red,
                                        title: const Text(
                                          'Calculare manuala',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        value: isCalculatedManual,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isCalculatedManual = newValue;
                                            if (newValue == false) {
                                              if (priceController.text == '' ||
                                                  !isAllParams) {
                                                penalizedPriceController.text =
                                                    '';
                                              } else {
                                                // penalizedPriceController.text =
                                                //     (double.parse(
                                                //                 priceController
                                                //                     .text) *
                                                //             1)
                                                //         .toStringAsFixed(2);
                                                calculatePenalizedPrice();
                                                setState(() {});
                                              }
                                            }
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          // details
                          const SizedBox(height: 8),
                          const Text(
                            'Detalii tranzactie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: detailsController,
                            validator: (value) {
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: accentColor,
                              hintText: 'introdu detalii aici',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(.75)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          // date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Data tranzactie',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: accentColor,
                                        hintText: 'introdu data aici',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(.75)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 20.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Nr. masina',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: carPlateController,
                                      validator: (value) {
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: accentColor,
                                        hintText: 'introdu nr masinii aici',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(.75)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 20.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await submitForm();
                    },
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text('Adauga Tranzactie'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kAccentColor),
                    ),
                  ),
                ),
              ),
            ],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      );
    },
  );
}

Future<void> modifyTransaction(
  BuildContext context,
  MyTransaction transaction,
) async {
  final _formKey = GlobalKey<FormState>();
  final oldQuantity = transaction.quantity;
  final oldType = transaction.type;

  // type: isIntrare
  bool isIntrare = transaction.type == 'intrare';
  bool isCalculatedManual = false;

  final quantityController = TextEditingController(
      text: transaction.quantity != null
          ? transaction.quantity.toStringAsFixed(2)
          : '');
  final priceController = TextEditingController(
      text: transaction.price != null
          ? transaction.price.toStringAsFixed(2)
          : '');
  final penalizedPriceController = TextEditingController(
      text: transaction.penalizedPrice != null
          ? transaction.penalizedPrice.toStringAsFixed(2)
          : '');
  final currencyController = TextEditingController(
      text:
          transaction.price != null ? (transaction.currency ?? 'ron') : 'ron');
  final detailsController = TextEditingController(text: transaction.details);
  final dateController = TextEditingController(text: transaction.date);
  final carPlateController = TextEditingController(text: transaction.carPlate);

  final humidityController = TextEditingController(
      text: transaction.humidity != null
          ? transaction.humidity.toStringAsFixed(2)
          : '');
  final foreignObjectsController = TextEditingController(
      text: transaction.foreignObjects != null
          ? transaction.foreignObjects.toStringAsFixed(2)
          : '');
  final hectolitreController = TextEditingController(
      text: transaction.hectolitre != null
          ? transaction.hectolitre.toStringAsFixed(2)
          : '');

  final List<Furnizor> furnizori =
      Provider.of<LoadFurnizori>(context, listen: false).furnizori;
  Furnizor selectedFurnior;

  final List<Client> clients =
      Provider.of<LoadClients>(context, listen: false).clients;
  Contract selectedContract;

  String productType = transaction.productType;
  Map<String, double> params = cerealeParams[productType];

  if (isIntrare) {
    selectedFurnior =
        furnizori.firstWhere((e) => e.id == transaction.furnizorId);
    selectedContract = null;
  } else {
    selectedFurnior = null;
    selectedContract = clients
        .firstWhere((e) => e.id == transaction.clientId)
        .contracts
        .firstWhere((e) => e.id == transaction.contractId);
  }

  Future<void> submitForm() {
    if ((isIntrare && selectedFurnior != null) ||
        (isIntrare == false && selectedContract != null)) {
      if (_formKey.currentState.validate()) {
        try {
          String type = isIntrare ? 'intrare' : 'iesire';
          Provider.of<LoadTransactions>(context, listen: false)
              .modifyTransaction(
            MyTransaction(
              id: transaction.id,
              type: type,
              clientId: type == 'intrare' ? null : selectedContract.clientId,
              contractId: type == 'intrare' ? null : selectedContract.id,
              furnizorId: type == 'intrare' ? selectedFurnior.id : null,
              productType: productType,
              quantity: double.parse(quantityController.text),
              price:
                  (priceController.text == null || priceController.text == '')
                      ? null
                      : double.parse(priceController.text),
              penalizedPrice: (type == 'intrare')
                  ? ((penalizedPriceController.text == null ||
                          penalizedPriceController.text == '')
                      ? null
                      : double.parse(penalizedPriceController.text))
                  : (null),
              currency: currencyController.text,
              details: detailsController.text,
              date: dateController.text,
              humidity: type == 'intrare'
                  ? (params['humidity'] != null
                      ? double.parse(humidityController.text)
                      : null)
                  : null,
              foreignObjects: type == 'intrare'
                  ? (params['foreignObjects'] != null
                      ? double.parse(foreignObjectsController.text)
                      : null)
                  : null,
              hectolitre: type == 'intrare'
                  ? (params['hectolitre'] != null
                      ? double.parse(hectolitreController.text)
                      : null)
                  : null,
              carPlate: carPlateController.text,
            ),
            oldQuantity,
            oldType,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Modificare tranzactie...'),
              duration: Duration(seconds: 1),
            ),
          );

          Navigator.of(context).pop();
        } catch (e) {
          print(e);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nu ati ales contract / furnizor!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<List<Furnizor>> filterFurnizori(String x) async {
    return furnizori
        .where((e) =>
            e.name.toLowerCase().contains(x.toLowerCase()) ||
            e.identifier.toLowerCase().contains(x.toLowerCase()))
        .toList();
  }

  Future<List<Contract>> filterContracte(String x) async {
    List<Contract> contracte = [];
    try {
      clients.forEach((e) {
        e.contracts.forEach((c) {
          contracte.add(c);
        });
      });
      contracte = contracte
          .where((e) =>
              (e.clientName.toLowerCase().contains(x.toLowerCase()) ||
                  e.clientIdentifier.toLowerCase().contains(x.toLowerCase()) ||
                  e.number.toLowerCase().contains(x.toLowerCase())) &&
              e.active &&
              e.productType == productType)
          .toList();
    } catch (e) {
      print(e);
    }
    return contracte;
  }

  const primaryColor = kPrimaryColor;
  const secondaryColor = kAccentColor;
  const accentColor = Color(0xffffffff);
  const backgroundColor = Color(0xffffffff);
  const errorColor = Color(0xffEF4444);

  bool calculateAllParams() {
    return ((params['humidity'] != null)
            ? (humidityController.text != '')
            : true) &&
        ((params['foreignObjects'] != null)
            ? (foreignObjectsController.text != '')
            : true) &&
        ((params['hectolitre'] != null)
            ? (hectolitreController.text != '')
            : true);
  }

  bool isAllParams = calculateAllParams();
  double penalizedPricePercent = 0;

  void calculatePenalizedPrice() {
    if (isAllParams && priceController.text != '') {
      double percent = 1;
      if (params['humidity'] != null) {
        if (double.parse(humidityController.text) > params['humidity']) {
          percent -=
              ((double.parse(humidityController.text) - params['humidity']) /
                  100);
        }
      }
      if (params['foreignObjects'] != null) {
        if (double.parse(foreignObjectsController.text) >
            params['foreignObjects']) {
          percent -= ((double.parse(foreignObjectsController.text) -
                  params['foreignObjects']) /
              100);
        }
      }
      if (params['hectolitre'] != null) {
        if (double.parse(hectolitreController.text) > params['hectolitre']) {
          isCalculatedManual = true;
        } else {
          isCalculatedManual = false;
        }
      }
      penalizedPriceController.text =
          (double.parse(priceController.text) * percent).toStringAsFixed(2);
      penalizedPricePercent = (1 - percent) * 100;
    } else {
      penalizedPriceController.text = '';
      penalizedPricePercent = 0;
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                'Modifica Tranzactie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // product type
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(text: 'Tip produs: '),
                                TextSpan(
                                  text: productType,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // transaction type
                          const SizedBox(height: 8),
                          const Text(
                            'Tip tranzactie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Iesire',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Switch(
                                  value: isIntrare,
                                  onChanged: (value) {
                                    setState(() {
                                      isIntrare = value;
                                      currencyController.text = 'ron';
                                      selectedFurnior = null;
                                      selectedContract = null;
                                    });
                                  },
                                  activeTrackColor: Colors.grey,
                                  activeColor: Colors.green,
                                  inactiveTrackColor: Colors.grey,
                                  inactiveThumbColor: Colors.redAccent,
                                ),
                                const Text(
                                  'Intrare',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // client
                          const Text(
                            'Contracte / Furnizori',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isIntrare)
                            DropdownSearch<Furnizor>(
                              // popupBarrierColor: kPrimaryColor.withOpacity(0.1),
                              mode: Mode.MENU,
                              showSearchBox: true,
                              label: "Furnizori",
                              onFind: (String filter) =>
                                  filterFurnizori(filter),
                              itemAsString: (Furnizor f) =>
                                  f.name + ' - ' + f.identifier,
                              onChanged: (Furnizor f) {
                                print(f.name);
                                selectedFurnior = f;
                                selectedContract = null;
                                currencyController.text = 'ron';
                                setState(() {});
                              },
                              selectedItem: selectedFurnior,
                            )
                          else
                            DropdownSearch<Contract>(
                              mode: Mode.MENU,
                              // popupBarrierColor: kPrimaryColor.withOpacity(0.1),
                              showSearchBox: true,
                              label: "Contracte",
                              onFind: (String filter) =>
                                  filterContracte(filter),
                              itemAsString: (Contract c) =>
                                  c.clientName +
                                  ' - ' +
                                  c.clientIdentifier +
                                  ' - ' +
                                  c.number,
                              onChanged: (Contract c) {
                                print(c.clientId);
                                selectedFurnior = null;
                                selectedContract = c;
                                currencyController.text = c.currency;
                                setState(() {});
                              },
                              selectedItem: selectedContract,
                            ),

                          // quantity
                          const SizedBox(height: 8),
                          const Text(
                            'Cantitate',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: quantityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cantitatea este goala';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: accentColor,
                              hintText: 'introdu cantitatea aici',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(.75)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          // umiditate si corpuri straine
                          if (isIntrare)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (params['humidity'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Umiditate: ' +
                                              params['humidity']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: humidityController,
                                          validator: (value) {
                                            if (params['humidity'] != null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Umiditatea este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText: 'introdu umiditate aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (params['humidity'] != null)
                                  const SizedBox(width: 20),
                                if (params['foreignObjects'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Corpuri straine: ' +
                                              params['foreignObjects']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: foreignObjectsController,
                                          validator: (value) {
                                            if (params['foreignObjects'] !=
                                                null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Corpuri straine este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText:
                                                'introdu corpuri straine aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (params['foreignObjects'] != null)
                                  const SizedBox(width: 20),
                                if (params['hectolitre'] != null)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Masa Hectolitrica: ' +
                                              params['hectolitre']
                                                  .toStringAsFixed(1) +
                                              '%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: hectolitreController,
                                          validator: (value) {
                                            if (params['hectolitre'] != null) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Masa Hectolitrica este goala';
                                              }
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          onChanged: (value) {
                                            if (isIntrare) {
                                              isAllParams =
                                                  calculateAllParams();
                                              calculatePenalizedPrice();
                                              setState(() {});
                                            }
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: accentColor,
                                            hintText:
                                                'introdu Masa Hectolitrica aici',
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(.75)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 20.0),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: errorColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: primaryColor,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          // price
                          Container(
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Pret',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: priceController,
                                        onChanged: (value) {
                                          print(value);
                                          if (isIntrare) {
                                            if (isCalculatedManual ||
                                                !isAllParams) {
                                            } else {
                                              if (value != '') {
                                                calculatePenalizedPrice();
                                                setState(() {});
                                              } else {
                                                penalizedPriceController.text =
                                                    '';
                                                setState(() {});
                                              }
                                            }
                                          }
                                        },
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: accentColor,
                                          hintText: 'introdu pretul aici',
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(.75)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: errorColor, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Moneda',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: kPrimaryColor,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0.0,
                                          horizontal: 20.0,
                                        ),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          focusColor: Colors.white,
                                          value: currencyController.text,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: kAccentColor),
                                          underline: Container(),
                                          onChanged: isIntrare
                                              ? (String newValue) {
                                                  currencyController.text =
                                                      newValue;
                                                  setState(() {});
                                                }
                                              : null,
                                          items: currencies
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isIntrare)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // pret penalizat
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        'Pret penalizat: ' +
                                            penalizedPricePercent
                                                .toStringAsFixed(1) +
                                            '%',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: penalizedPriceController,
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        enabled: isCalculatedManual,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: accentColor,
                                          hintText: isCalculatedManual
                                              ? 'introdu valoare'
                                              : 'se calculeaza automat',
                                          hintStyle: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(.75)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: errorColor, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 30),
                                      CheckboxListTile(
                                        activeColor: kAccentColor,
                                        checkColor: Colors.white,
                                        tileColor: Colors.grey[300],
                                        selectedTileColor: Colors.red,
                                        title: const Text(
                                          'Calculare manuala',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        value: isCalculatedManual,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isCalculatedManual = newValue;
                                            if (newValue == false) {
                                              if (priceController.text == '' ||
                                                  !isAllParams) {
                                                penalizedPriceController.text =
                                                    '';
                                              } else {
                                                penalizedPriceController.text =
                                                    (double.parse(
                                                                priceController
                                                                    .text) *
                                                            1)
                                                        .toStringAsFixed(2);
                                              }
                                            }
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          // details
                          const SizedBox(height: 8),
                          const Text(
                            'Detalii tranzactie',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: detailsController,
                            validator: (value) {
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: accentColor,
                              hintText: 'introdu detalii aici',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(.75)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: secondaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          // date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Data tranzactie',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: accentColor,
                                        hintText: 'introdu data aici',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(.75)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 20.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Nr. masina',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: carPlateController,
                                      validator: (value) {
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: accentColor,
                                        hintText: 'introdu nr masinii aici',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(.75)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 20.0),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: secondaryColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await submitForm();
                    },
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text('Modifica Tranzactie'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kAccentColor),
                    ),
                  ),
                ),
              ),
            ],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      );
    },
  );
}

Future<String> deleteTransaction(
  BuildContext context,
  MyTransaction transaction,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ești sigur că vrei să stergi acesta tranzactie?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, size: 24),
                label: const Text('Inapoi'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kAccentColor),
                ),
              ),
              const SizedBox(width: 25),
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<LoadTransactions>(context, listen: false)
                      .deleteTransaction(transaction.id);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_outline, size: 24),
                label: const Text('Sterge'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
    },
  );
}
