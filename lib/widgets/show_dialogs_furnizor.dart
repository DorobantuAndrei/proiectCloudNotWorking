import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import '../providers/clientsProvider.dart';

Future<void> addFurnizor(
  BuildContext context,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final identifierController = TextEditingController();
  final detailsController = TextEditingController();

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadFurnizori>(context, listen: false).addFurnizor(Furnizor(
        name: nameController.text,
        identifier: identifierController.text,
        details: detailsController.text,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adaugare furnizor...'),
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  const primaryColor = kPrimaryColor;
  const secondaryColor = kAccentColor;
  const accentColor = Color(0xffffffff);
  const backgroundColor = Color(0xffffffff);
  const errorColor = Color(0xffEF4444);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Adauga furnizor nou',
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
                      // nume
                      const Text(
                        'Nume furnizor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Numele este gol';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: accentColor,
                          hintText: 'introdu numele aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                      // identifier
                      const SizedBox(height: 8),
                      const Text(
                        'Identificator furnizor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: identifierController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Identificatorul este gol';
                          }
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
                          hintText: 'introdu identificatorul aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                        'Detalii furnizor',
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
                          // if (value == null || value.isEmpty) {
                          //   return 'Numele este gol';
                          // }
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
                          hintText: 'introdu detaliile aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                label: const Text('Salveaza Furnizor'),
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
}

Future<void> modifyFurnizor(
  BuildContext context,
  Furnizor f,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: f.name);
  final identifierController = TextEditingController(text: f.identifier);
  final detailsController = TextEditingController(text: f.details);

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadFurnizori>(context, listen: false).modifyFurnizor(
        id: f.id,
        name: nameController.text,
        identifier: identifierController.text,
        details: detailsController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modificare furnizor...'),
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  const primaryColor = kPrimaryColor;
  const secondaryColor = kAccentColor;
  const accentColor = Color(0xffffffff);
  const backgroundColor = Color(0xffffffff);
  const errorColor = Color(0xffEF4444);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Modifica furnizor',
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
                      // nume
                      const Text(
                        'Nume furnizor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Numele este gol';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: accentColor,
                          hintText: 'introdu numele aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                      // identifier
                      const SizedBox(height: 8),
                      const Text(
                        'Identificator furnizor',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: identifierController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Identificatorul este gol';
                          }
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
                          hintText: 'introdu identificatorul aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                        'Detalii furnizor',
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
                          // if (value == null || value.isEmpty) {
                          //   return 'Numele este gol';
                          // }
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
                          hintText: 'introdu detaliile aici',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
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
                label: const Text('Salveaza Furnizor'),
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
}

Future<String> deleteFurnizor(
  BuildContext context,
  Furnizor furnizor,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ești sigur că vrei să stergi acest furnizor?',
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
                  await Provider.of<LoadFurnizori>(context, listen: false)
                      .deleteFurnizor(furnizor.id);
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
