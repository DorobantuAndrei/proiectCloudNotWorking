import 'package:achizitii_cereale/intermediary.dart';
import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/providers/ratesProvider.dart';
import 'package:achizitii_cereale/providers/transactionsProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'providers/clientsProvider.dart';
import 'providers/connectivity.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (consumerContext, model, child) {
        if (model.isOnline != null) {
          return model.isOnline ? const App() : const NoInternet();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadRates()),
        ChangeNotifierProvider(create: (_) => LoadClients()),
        ChangeNotifierProvider(create: (_) => LoadFurnizori()),
        ChangeNotifierProvider(create: (_) => LoadTransactions()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Achizitii Cereale',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          accentColor: kAccentColor,
          unselectedWidgetColor: Colors.white,
          fontFamily: 'OpenSans',
        ),
        home: const Intermediary(),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
