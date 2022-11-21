import 'package:achizitii_cereale/main.dart';
import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/providers/transactionsProvider.dart';
import 'package:achizitii_cereale/screens/contracts_screen.dart';
import 'package:achizitii_cereale/screens/furnizori_screen.dart';
import 'package:achizitii_cereale/screens/rates_screen.dart';
import 'package:achizitii_cereale/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'screens/clients_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    Key key,
    this.changeCityFirebase,
  }) : super(key: key);

  final Function changeCityFirebase;

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = kSelectedPage;

  @override
  void initState() {
    _pages = [
      {
        'page': const RatesScreen(),
        'title': 'Rate Lunare',
        'bottom': 'Rate lunare',
        'icon': Icons.attach_money,
      },
      {
        'page': const ClientScreen(),
        'title': 'Clienti',
        'bottom': 'Clienti',
        'icon': Icons.people,
      },
      {
        'page': const ContractsScreen(),
        'title': 'Contracte',
        'bottom': 'Contracte',
        'icon': Icons.book
      },
      {
        'page': const FurnizorScreen(),
        'title': 'Furnizori',
        'bottom': 'Furnizori',
        'icon': Icons.business_outlined,
      },
      ...cereale
          .map(
            (e) => {
              'page': TransactionsScreen(productType: e),
              'title': e.toTitleCase(),
              // + ' - ' +
              // (cerealeParams[e]['humidity'] != null
              //     ? ('U ' +
              //         cerealeParams[e]['humidity'].toStringAsFixed(0) +
              //         ' ')
              //     : '') +
              // (cerealeParams[e]['foreignObjects'] != null
              //     ? ('CS ' +
              //         cerealeParams[e]['foreignObjects']
              //             .toStringAsFixed(0) +
              //         ' ')
              //     : '') +
              // (cerealeParams[e]['hectolitre'] != null
              //     ? ('H ' +
              //         cerealeParams[e]['hectolitre'].toStringAsFixed(0))
              //     : ''),
              'bottom': e.toTitleCase(),
              'icon': Icons.agriculture,
            },
          )
          .toList(),
    ];

    super.initState();
  }

  void _selectPage(int index) {
    Provider.of<LoadClients>(context, listen: false).toggleAllContracts();
    Provider.of<LoadClients>(context, listen: false).toggleAllTransactions();
    Provider.of<LoadFurnizori>(context, listen: false).toggleAllTransactions();
    Provider.of<LoadTransactions>(context, listen: false)
        .toggleAllTransactionForPrint(false);

    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar bottomBar = BottomNavigationBar(
      currentIndex: _selectedPageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
      iconSize: 24,
      selectedIconTheme: const IconThemeData(size: 30),
      onTap: _selectPage,
      items: _pages
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e['icon']),
              label: e['bottom'],
            ),
          )
          .toList(),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _pages[_selectedPageIndex]['title'] == 'Bella Italia'
          ? null
          : AppBar(
              toolbarHeight: 45,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              title: Text(
                _pages[_selectedPageIndex]['title'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: bottomBar,
    );
  }
}
