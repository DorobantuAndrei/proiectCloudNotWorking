import 'dart:async';

import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/getData/firebase_realtime_database.dart';
import 'package:achizitii_cereale/http_client.dart';
import 'package:achizitii_cereale/widgets/input_widgets.dart';
import 'package:flutter/material.dart';

class Intermediary extends StatefulWidget {
  const Intermediary({Key key}) : super(key: key);

  @override
  State<Intermediary> createState() => _IntermediaryState();
}

class _IntermediaryState extends State<Intermediary> {
  bool canSee = kCanSee;

  void changeBool() {
    setState(() {
      canSee = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (canSee) {
      return const FirebaseRealtimeDatabase();
    } else {
      return PinCodeVerificationScreen(change: changeBool);
    }
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final Function change;

  const PinCodeVerificationScreen({
    Key key,
    this.change,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController telefonController = TextEditingController();
  TextEditingController codSmsController = TextEditingController();

  bool hasError = false;
  final formKey = GlobalKey<FormState>();

  String requestId;
  bool hasSend = false;
  bool isOk = false;

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool validateForm() {
    return formKey.currentState.validate();
  }

  Future<void> submit() async {
    if (!validateForm()) {
      return;
    }

    print('start');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-as-apikey': 'a61ef09b-fe42-4a12-ae57-b00bb1f087d9',
    };

    Map body = {
      "messageFormat":
          "Hello, this is your OTP. Please do not share it with anyone",
      "phoneNumber": telefonController.text,
      "otpLength": 6,
      "otpValidityInSeconds": 240,
    };

    HttpClient client = HttpClient();
    String serverUrl = 'www.getapistack.com';

    try {
      Map response = await client.post(
          Uri.https(serverUrl, '/api/v1/otp/send'), body, headers);
      setState(() {
        requestId = response['data']['data']['requestId'];
        hasSend = true;
        hasError = false;
      });
    } catch (e) {
      print(e.toString());
      print('hellooo');
      setState(() {
        hasSend = false;
        requestId = null;
        hasError = true;
      });
    }
  }

  Future<void> submit2() async {
    if (!validateForm()) {
      return;
    }

    print('start 2');
    print(codSmsController.text ?? 'e cam gol cod sms');
    print(requestId ?? 'e cam gol request id');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-as-apikey': 'a61ef09b-fe42-4a12-ae57-b00bb1f087d9',
    };

    Map body = {
      "otp": codSmsController.text,
      "requestId": requestId,
    };

    HttpClient client = HttpClient();
    String serverUrl = 'www.getapistack.com';

    try {
      Map response = await client.post(
          Uri.https(serverUrl, '/api/v1/otp/verify'), body, headers);
      setState(() {
        isOk = response['data']['data']['isOtpValid'];

        if (isOk) {
          hasError = false;
          widget.change();
        }
      });
    } catch (e) {
      setState(() {
        isOk = false;
        hasError = true;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('dasdsadass ' + (hasError ? 'eroare' : 'nu e eroare'));
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Verificare nr. telefon',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Text(requestId ?? 'null momentan'),
                // Text(hasSend ? 's-a trimis' : 'nu s-a trimis'),
                // Text(isOk ? 'e ok' : 'nu e ok'),
                // const SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputField(
                        label: 'Numar telefon',
                        hint: 'introdu nr telefon',
                        isRequired: true,
                        inputController: telefonController,
                        textInputType: TextInputType.text,
                        onChangeFunction: () {},
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return 'introdu o valoare';
                          }
                          return null;
                        },
                      ),
                      if (hasSend) const SizedBox(height: 10),
                      if (hasSend)
                        InputField(
                          label: 'Cod sms',
                          hint: 'introdu cod sms',
                          isRequired: true,
                          inputController: codSmsController,
                          textInputType: TextInputType.text,
                          onChangeFunction: () {},
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'introdu o valoare';
                            }
                            return null;
                          },
                        ),
                      if (hasError) const SizedBox(height: 10),
                      if (hasError) Text('Eroare!!!'),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (hasSend) {
                      await submit2();
                    } else {
                      await submit();
                    }
                  },
                  icon: const Icon(Icons.check, size: 24),
                  label: Text(hasSend ? 'Verifica cod SMS' : 'Trimite SMS'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kAccentColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
