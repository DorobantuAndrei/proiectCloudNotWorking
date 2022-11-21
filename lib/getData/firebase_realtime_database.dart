import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:achizitii_cereale/providers/ratesProvider.dart';
import 'package:achizitii_cereale/providers/transactionsProvider.dart';
import 'package:achizitii_cereale/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/furnizoriProvider.dart';
import '../widgets/loading_screen.dart';

class FirebaseRealtimeDatabase extends StatelessWidget {
  const FirebaseRealtimeDatabase({Key key}) : super(key: key);

  Future<void> getData(BuildContext context) async {
    await Provider.of<LoadRates>(context, listen: false).getRates();
    await Provider.of<LoadClients>(context, listen: false).getClients();
    await Provider.of<LoadFurnizori>(context, listen: false).getFurnizori();
    await Provider.of<LoadTransactions>(context, listen: false).getStock();
    await Provider.of<LoadTransactions>(context, listen: false)
        .getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingScreen();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const TabsScreen();
            }
        }
      },
    );
  }
}
