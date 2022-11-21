import 'package:achizitii_cereale/providers/ratesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/models.dart';
import '../widgets/show_dialogs_rates.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({Key key}) : super(key: key);

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  TextEditingController searchController;

  void searchUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(searchUpdate);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Rate> rates = Provider.of<LoadRates>(context, listen: true).rates;
    rates.sort(((a, b) => a.issueDate.compareTo(b.issueDate)));

    final ratesSearch = rates
        .where((e) => (e.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            e
                .returnDate(e.issueDate)
                .contains(searchController.text.toLowerCase()) ||
            e.type.contains(searchController.text.toLowerCase())))
        .toList();

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ClientAddButton(controller: searchController),
          Container(
            width: double.infinity,
            child: DataTable(
              headingTextStyle: const TextStyle(fontWeight: FontWeight.w600),
              columns: const [
                DataColumn(label: Text('Nume')),
                DataColumn(label: Text('Tip Rata')),
                DataColumn(label: Text('Data Emitere')),
                DataColumn(label: Text('Zile pana la scadenta')),
                DataColumn(label: Text('Data scadenta')),
                DataColumn(label: Text('Suma')),
                DataColumn(label: Text('Achitat')),
                DataColumn(label: Text('Modifica')),
                DataColumn(label: Text('Sterge')),
              ],
              rows: searchController.text == ''
                  ? rates.map((e) => e.returnTableRow(context)).toList()
                  : ratesSearch.map((e) => e.returnTableRow(context)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientAddButton extends StatelessWidget {
  const ClientAddButton({Key key, this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const primaryColor = kPrimaryColor;
    const secondaryColor = kAccentColor;
    const accentColor = Color(0xffffffff);
    const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await addRate(context);
                },
                icon: const Icon(Icons.add, size: 24),
                label: const Text('Adauga rata'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kAccentColor),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 32,
                  child: TextFormField(
                    controller: controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Numele este gol';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: accentColor,
                      prefixIcon: const Icon(Icons.search, color: kAccentColor),
                      hintText: 'Cauta aici...',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: secondaryColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: errorColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.grey[350],
                  child: InkWell(
                    onTap: () => controller.text = '',
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RateOptionsIcon extends StatelessWidget {
  const RateOptionsIcon({Key key, this.icon, this.onTap, this.label})
      : super(key: key);

  final IconData icon;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kAccentColor),
      ),
    );
  }
}
