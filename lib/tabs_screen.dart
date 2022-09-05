import 'package:achizitii_cereale/main.dart';
import 'package:achizitii_cereale/screens/contracts_screen.dart';
import 'package:achizitii_cereale/screens/furnizori_screen.dart';
import 'package:achizitii_cereale/screens/transactions_screen.dart';
import 'package:flutter/material.dart';

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
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': const ClientScreen(),
        'title': 'Clienti',
        'icon': Icons.people,
      },
      {
        'page': const ContractsScreen(),
        'title': 'Contracte',
        'icon': Icons.book
      },
      {
        'page': const FurnizorScreen(),
        'title': 'Furnizori',
        'icon': Icons.business_outlined,
      },
      ...cereale
          .map(
            (e) => {
              'page': TransactionsScreen(productType: e),
              'title': e.toTitleCase(),
              'icon': Icons.agriculture,
            },
          )
          .toList(),
    ];

    super.initState();
  }

  void _selectPage(int index) {
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
              label: e['title'],
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
