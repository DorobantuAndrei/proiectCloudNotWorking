import 'dart:async';

import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/getData/firebase_realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Verifica cod pin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        // blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length != 6) {
                            return 'pin-ul trebuie sa aiba 6 caractere';
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          errorBorderColor: Colors.red,
                          activeColor: kPrimaryColor,
                          selectedColor: kPrimaryColor,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    formKey.currentState.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "123321") {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                    } else {
                      setState(
                        () {
                          hasError = false;
                        },
                      );
                      widget.change();
                    }
                  },
                  icon: const Icon(Icons.check, size: 24),
                  label: const Text('Verifica'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kAccentColor),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: TextButton(
                        child: const Text("Sterge"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(kAccentColor),
                        ),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
