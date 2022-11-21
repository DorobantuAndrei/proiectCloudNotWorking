import 'package:achizitii_cereale/providers/ratesProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import '../providers/clientsProvider.dart';

Future<void> addClient(
  BuildContext context,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final identifierController = TextEditingController();
  final detailsController = TextEditingController();

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadClients>(context, listen: false).addClient(Client(
        name: nameController.text,
        identifier: identifierController.text,
        details: detailsController.text,
        contracts: [],
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adaugare client...'),
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
            'Adauga client nou',
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
                        'Nume client',
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
                        'Identificator client',
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
                        'Detalii client',
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
                label: const Text('Salveaza Client'),
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

Future<void> modifyClient(
  BuildContext context,
  Client c,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: c.name);
  final identifierController = TextEditingController(text: c.identifier);
  final detailsController = TextEditingController(text: c.details);

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadClients>(context, listen: false).modifyClient(
        id: c.id,
        name: nameController.text,
        identifier: identifierController.text,
        details: detailsController.text,
        contracts: c.contracts,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modificare client...'),
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
            'Modifica client',
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
                        'Nume client',
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
                        'Identificator client',
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
                        'Detalii client',
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
                label: const Text('Salveaza Client'),
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

Future<String> deleteClient(
  BuildContext context,
  Client client,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ești sigur că vrei să stergi acest client?',
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
                  await Provider.of<LoadClients>(context, listen: false)
                      .deleteClient(client.id);
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

Future<void> addContract(
  BuildContext context,
  Client c,
) async {
  final _formKey = GlobalKey<FormState>();

  final clientName = c.name;
  final numberController = TextEditingController();
  final productTypeController = TextEditingController(text: 'grau');
  final quantityController = TextEditingController();
  bool isActive = true;
  final priceController = TextEditingController();
  final currencyController = TextEditingController(text: 'ron');
  final dateController = TextEditingController();
  final detailsController = TextEditingController();

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadClients>(context, listen: false).addContract(
        id: c.id,
        contract: Contract(
          clientId: c.id,
          number: numberController.text,
          productType: productTypeController.text,
          quantity: double.parse(quantityController.text),
          active: isActive,
          price: priceController.text == ''
              ? null
              : double.parse(priceController.text),
          currency: priceController.text == '' ? null : currencyController.text,
          date: dateController.text,
          details: detailsController.text,
          clientName: c.name,
          clientIdentifier: c.identifier,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adaugare contract...'),
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
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Adauga contract nou',
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
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'Nume client: '),
                              TextSpan(
                                text: clientName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Numar', isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: numberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Numarul este gol';
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
                            hintText: 'introdu numarul aici',
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Tip produs', isRequired: true),
                        const SizedBox(height: 3),
                        Container(
                          // width: MediaQuery.of(context).size.width * 0.4,
                          width: 250,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: productTypeController.text,
                            // icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: kAccentColor),
                            underline:
                                Container(height: 2, color: kPrimaryColor),
                            onChanged: (String newValue) {
                              productTypeController.text = newValue;
                              setState(() {});
                            },
                            items: cereale
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Cantitate', isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: quantityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cantitatea este goala';
                            }
                            if (value.contains(RegExp(r'[a-z]'))) {
                              return 'Cantitatea trebuie sa aiba doar cifre';
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Activ', isRequired: true),
                        // const SizedBox(height: 8),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          activeTrackColor: kPrimaryColor,
                          activeColor: kAccentColor,
                        ),
                        // const SizedBox(height: 8),

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
                                  const PopupTitle(text: 'Pret'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: priceController,
                                    validator: (value) {
                                      if (value.contains(RegExp(r'[a-z]'))) {
                                        return 'Pretul trebuie sa aiba doar cifre';
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
                                      hintText: 'introdu pretul aici',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.withOpacity(.75)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryColor, width: 1.0),
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
                                  const SizedBox(height: 8),
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
                                  const PopupTitle(text: 'Moneda'),
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
                                      style:
                                          const TextStyle(color: kAccentColor),
                                      underline: Container(),
                                      onChanged: (String newValue) {
                                        currencyController.text = newValue;
                                        setState(() {});
                                      },
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
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const PopupTitle(text: 'Data expirare'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          validator: (value) {
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: accentColor,
                            hintText: 'introdu data aici',
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Detalii'),
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
                  label: const Text('Adauga contract'),
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
      });
    },
  );
}

Future<void> modifyContract(
  BuildContext context,
  Client client,
  Contract contract,
) async {
  final _formKey = GlobalKey<FormState>();

  final clientName = client.name;
  final numberController = TextEditingController(text: contract.number);
  final productTypeController =
      TextEditingController(text: contract.productType);
  final quantityController =
      TextEditingController(text: contract.quantity.toStringAsFixed(2));
  bool isActive = contract.active;
  final priceController = TextEditingController(
      text: contract.price != null ? contract.price.toStringAsFixed(2) : '');
  final currencyController =
      TextEditingController(text: contract.currency ?? 'ron');
  final dateController = TextEditingController(text: contract.date ?? '');
  final detailsController = TextEditingController(text: contract.details);

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadClients>(context, listen: false).modifyContract(
        id: client.id,
        contract: Contract(
          id: contract.id,
          clientId: client.id,
          number: numberController.text,
          productType: productTypeController.text,
          quantity: double.parse(quantityController.text),
          active: isActive,
          price: priceController.text == ''
              ? null
              : double.parse(priceController.text),
          currency:
              currencyController.text == '' ? null : currencyController.text,
          date: dateController.text,
          details: detailsController.text,
          clientName: client.name,
          clientIdentifier: client.identifier,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modificare contract...'),
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

  bool button1 = true;
  bool button2 = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Modificare contract',
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
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'Nume client: '),
                              TextSpan(
                                text: clientName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Numar', isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: numberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Numarul este gol';
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
                            hintText: 'introdu numarul aici',
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Tip produs', isRequired: true),
                        const SizedBox(height: 3),
                        Container(
                          width: 250,
                          child: DropdownButton<String>(
                            value: productTypeController.text,
                            // icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: kAccentColor),
                            underline:
                                Container(height: 2, color: kPrimaryColor),
                            onChanged: (String newValue) {
                              productTypeController.text = newValue;
                              setState(() {});
                            },
                            items: cereale
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Cantitate', isRequired: true),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: quantityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cantitatea este goala';
                            }
                            if (value.contains(RegExp(r'[a-z]'))) {
                              return 'Cantitatea trebuie sa aiba doar cifre';
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Activ', isRequired: true),
                        // const SizedBox(height: 8),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          activeTrackColor: kPrimaryColor,
                          activeColor: kAccentColor,
                        ),
                        // const SizedBox(height: 8),

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
                                  const PopupTitle(text: 'Pret'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: priceController,
                                    validator: (value) {
                                      if (value.contains(RegExp(r'[a-z]'))) {
                                        return 'Pretul trebuie sa aiba doar cifre';
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
                                      hintText: 'introdu pretul aici',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.withOpacity(.75)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: secondaryColor, width: 1.0),
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
                                  const SizedBox(height: 8),
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
                                  const PopupTitle(text: 'Moneda'),
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
                                      style:
                                          const TextStyle(color: kAccentColor),
                                      // underline: Container(
                                      //     height: 2, color: kPrimaryColor),
                                      underline: Container(),
                                      onChanged: (String newValue) {
                                        currencyController.text = newValue;
                                        setState(() {});
                                      },
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
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const PopupTitle(text: 'Data expirare'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          validator: (value) {
                            return null;
                          },
                          keyboardType: TextInputType.datetime,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: accentColor,
                            hintText: 'introdu data aici',
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
                        const SizedBox(height: 8),
                        const PopupTitle(text: 'Detalii'),
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
                  label: const Text('Modifica contract'),
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
      });
    },
  );
}

Future<String> deleteContract(
  BuildContext context,
  Client client,
  Contract contract,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ești sigur că vrei să stergi acest contract?',
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
                  await Provider.of<LoadClients>(context, listen: false)
                      .deleteContract(client.id, contract.id);
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

class PopupTitle extends StatelessWidget {
  const PopupTitle({Key key, this.text, this.isRequired = false})
      : super(key: key);

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: text),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
