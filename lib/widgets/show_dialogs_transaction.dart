import 'package:achizitii_cereale/models/product_type.dart';
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

  // type: isIntrare
  bool isIntrare = true;

  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final detailsController = TextEditingController();
  final dateController = TextEditingController();

  final List<Furnizor> furnizori =
      Provider.of<LoadFurnizori>(context, listen: false).furnizori;
  Furnizor selectedFurnior;

  final List<Client> clients =
      Provider.of<LoadClients>(context, listen: false).clients;
  Contract selectedContract;

  Future<void> submitForm() {
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
          details: detailsController.text,
          date: dateController.text,
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
                          // price
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
  MyTransaction t,
) async {
  // final _formKey = GlobalKey<FormState>();

  // final nameController = TextEditingController(text: f.name);
  // final identifierController = TextEditingController(text: f.identifier);
  // final detailsController = TextEditingController(text: f.details);

  // Future<void> submitForm() {
  //   if (_formKey.currentState.validate()) {
  //     Provider.of<LoadFurnizori>(context, listen: false).modifyFurnizor(
  //       id: f.id,
  //       name: nameController.text,
  //       identifier: identifierController.text,
  //       details: detailsController.text,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Modificare furnizor...'),
  //         duration: Duration(seconds: 1),
  //       ),
  //     );

  //     Navigator.of(context).pop();
  //   }
  // }

  // const primaryColor = kPrimaryColor;
  // const secondaryColor = kAccentColor;
  // const accentColor = Color(0xffffffff);
  // const backgroundColor = Color(0xffffffff);
  // const errorColor = Color(0xffEF4444);

  // return showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       backgroundColor: Colors.white,
  //       title: const Center(
  //         child: Text(
  //           'Modifica furnizor',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 19,
  //           ),
  //         ),
  //       ),
  //       content: Container(
  //         width: MediaQuery.of(context).size.width * 0.4,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // nume
  //                     const Text(
  //                       'Nume furnizor',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     TextFormField(
  //                       controller: nameController,
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Numele este gol';
  //                         }
  //                         return null;
  //                       },
  //                       keyboardType: TextInputType.name,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black,
  //                       ),
  //                       decoration: InputDecoration(
  //                         filled: true,
  //                         fillColor: accentColor,
  //                         hintText: 'introdu numele aici',
  //                         hintStyle:
  //                             TextStyle(color: Colors.grey.withOpacity(.75)),
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             vertical: 0.0, horizontal: 20.0),
  //                         border: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         focusedBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: secondaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         errorBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: errorColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         enabledBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                       ),
  //                     ),
  //                     // identifier
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Identificator furnizor',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     TextFormField(
  //                       controller: identifierController,
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Identificatorul este gol';
  //                         }
  //                         return null;
  //                       },
  //                       keyboardType: TextInputType.text,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black,
  //                       ),
  //                       decoration: InputDecoration(
  //                         filled: true,
  //                         fillColor: accentColor,
  //                         hintText: 'introdu identificatorul aici',
  //                         hintStyle:
  //                             TextStyle(color: Colors.grey.withOpacity(.75)),
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             vertical: 0.0, horizontal: 20.0),
  //                         border: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         focusedBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: secondaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         errorBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: errorColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         enabledBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                       ),
  //                     ),
  //                     // details
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Detalii furnizor',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     TextFormField(
  //                       controller: detailsController,
  //                       validator: (value) {
  //                         // if (value == null || value.isEmpty) {
  //                         //   return 'Numele este gol';
  //                         // }
  //                         return null;
  //                       },
  //                       keyboardType: TextInputType.text,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black,
  //                       ),
  //                       decoration: InputDecoration(
  //                         filled: true,
  //                         fillColor: accentColor,
  //                         hintText: 'introdu detaliile aici',
  //                         hintStyle:
  //                             TextStyle(color: Colors.grey.withOpacity(.75)),
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             vertical: 0.0, horizontal: 20.0),
  //                         border: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         focusedBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: secondaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         errorBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: errorColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         enabledBorder: const OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: primaryColor, width: 1.0),
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //       actions: <Widget>[
  //         Container(
  //           margin: const EdgeInsets.only(bottom: 20),
  //           child: Center(
  //             child: ElevatedButton.icon(
  //               onPressed: () async {
  //                 await submitForm();
  //               },
  //               icon: const Icon(Icons.save, size: 24),
  //               label: const Text('Salveaza Furnizor'),
  //               style: ButtonStyle(
  //                 backgroundColor:
  //                     MaterialStateProperty.all<Color>(kAccentColor),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //       elevation: 10,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     );
  //   },
  // );
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
