import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import '../providers/ratesProvider.dart';

Future<void> addRate(
  BuildContext context,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final tipRataController = TextEditingController(text: 'lunara');
  final dataEmitereController = TextEditingController();
  final zileScadenteController = TextEditingController();
  final sumaController = TextEditingController();

  var dataInitiala = DateTime.now();

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadRates>(context, listen: false).addRate(Rate(
        name: nameController.text,
        type: tipRataController.text,
        issueDate: dataInitiala,
        dueDays: zileScadenteController.text == ''
            ? null
            : int.tryParse(zileScadenteController.text),
        amount: sumaController.text == '' ? null : sumaController.text,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adaugare rata...'),
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
              'Adauga rata noua',
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
                          'Nume',
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

                        // tip
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const PopupTitle(text: 'Tip rata'),
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
                                value: tipRataController.text,
                                elevation: 16,
                                style: const TextStyle(color: kAccentColor),
                                underline: Container(),
                                onChanged: (String newValue) {
                                  tipRataController.text = newValue;
                                  setState(() {});
                                },
                                items: rateTypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        // rand
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 2),
                                  const PopupTitle(text: 'Data emitere'),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final chosenDate = await showDatePicker(
                                        context: context,
                                        initialDate: dataInitiala,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                        selectableDayPredicate:
                                            (DateTime dateTime) {
                                          return true;
                                        },
                                        helpText: 'Selectare data',
                                        cancelText: 'Inapoi',
                                        confirmText: 'Continua',
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                      primary: kAccentColor),
                                              buttonTheme:
                                                  const ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary,
                                              ),
                                            ),
                                            child: child,
                                          );
                                        },
                                      );
                                      if (chosenDate != null) {
                                        setState(() {
                                          dataInitiala = chosenDate;
                                          dataEmitereController.text =
                                              dataInitiala.toIso8601String();
                                        });
                                        print(chosenDate.toIso8601String());
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kPrimaryColor),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 13,
                                      ),
                                      child: Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(dataInitiala),
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
                                  const PopupTitle(text: 'Zile scadente'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: zileScadenteController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      if (value.contains(RegExp(r'[a-z]'))) {
                                        return 'Ziua trebuie sa aiba doar cifre';
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
                                      hintText: 'introdu zilele aici',
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
                          ],
                        ),
                        // details
                        const Text(
                          'Suma',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: sumaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
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
                            hintText: 'introdu suma aici',
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
                  label: const Text('Salveaza Rata'),
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

Future<void> modifyRate(
  BuildContext context,
  Rate r,
) async {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: r.name);
  final tipRataController = TextEditingController(text: r.type);
  final dataEmitereController =
      TextEditingController(text: r.returnDate(r.issueDate));
  final zileScadenteController = TextEditingController(
      text: r.dueDays != null ? r.dueDays.toString() : '');
  final sumaController = TextEditingController(text: r.amount ?? '');

  var dataInitiala = r.issueDate;

  Future<void> submitForm() {
    if (_formKey.currentState.validate()) {
      Provider.of<LoadRates>(context, listen: false).modifyRate(Rate(
        id: r.id,
        name: nameController.text,
        type: tipRataController.text,
        issueDate: dataInitiala,
        dueDays: zileScadenteController.text == ''
            ? null
            : int.tryParse(zileScadenteController.text),
        amount: sumaController.text == '' ? null : sumaController.text,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Modificare rata...'),
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
              'Modificare rata',
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
                          'Nume',
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

                        // tip
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const PopupTitle(text: 'Tip rata'),
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
                                value: tipRataController.text,
                                elevation: 16,
                                style: const TextStyle(color: kAccentColor),
                                underline: Container(),
                                onChanged: (String newValue) {
                                  tipRataController.text = newValue;
                                  setState(() {});
                                },
                                items: rateTypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        // rand
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 2),
                                  const PopupTitle(text: 'Data emitere'),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final chosenDate = await showDatePicker(
                                        context: context,
                                        initialDate: dataInitiala,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                        selectableDayPredicate:
                                            (DateTime dateTime) {
                                          return true;
                                        },
                                        helpText: 'Selectare data',
                                        cancelText: 'Inapoi',
                                        confirmText: 'Continua',
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                      primary: kAccentColor),
                                              buttonTheme:
                                                  const ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary,
                                              ),
                                            ),
                                            child: child,
                                          );
                                        },
                                      );
                                      if (chosenDate != null) {
                                        setState(() {
                                          dataInitiala = chosenDate;
                                          dataEmitereController.text =
                                              dataInitiala.toIso8601String();
                                        });
                                        print(chosenDate.toIso8601String());
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kPrimaryColor),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 13,
                                      ),
                                      child: Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(dataInitiala),
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
                                  const PopupTitle(text: 'Zile scadenta'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: zileScadenteController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      if (value.contains(RegExp(r'[a-z]'))) {
                                        return 'Ziua trebuie sa aiba doar cifre';
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
                                      hintText: 'introdu zilele aici',
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
                          ],
                        ),
                        // details
                        const Text(
                          'Suma',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: sumaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
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
                            hintText: 'introdu suma aici',
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
                  label: const Text('Salveaza Rata'),
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

Future<String> deleteRate(
  BuildContext context,
  Rate rate,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ești sigur că vrei să stergi aceasta rata?',
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
                  await Provider.of<LoadRates>(context, listen: false)
                      .deleteRate(rate.id);
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

Future<String> nextDateRate(
  BuildContext context,
  Rate rate,
) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Ai achitat aceasta rata?',
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
                label: const Text('Nu'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              const SizedBox(width: 25),
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<LoadRates>(context, listen: false)
                      .nextDate(rate.id);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check, size: 24),
                label: const Text('Da'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kAccentColor),
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
