import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/models/models.dart';
import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/screens/transactions_screen.dart';
import 'package:achizitii_cereale/test_print/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transactionsProvider.dart';
import '../widgets/show_dialogs_furnizor.dart';
import '../widgets/show_dialogs_transaction.dart';

class FurnizorScreen extends StatefulWidget {
  const FurnizorScreen({Key key}) : super(key: key);

  @override
  State<FurnizorScreen> createState() => _FurnizorScreenState();
}

class _FurnizorScreenState extends State<FurnizorScreen> {
  TextEditingController searchController;

  bool selectTransactions = false;
  bool selectAll = false;

  void changeSelectTransactions() {
    setState(() {
      selectTransactions = !selectTransactions;
      Provider.of<LoadTransactions>(
        context,
        listen: false,
      ).toggleAllTransactionForPrint(false);
      selectAll = false;
    });
  }

  void changeSelectAll() {
    setState(() {
      selectAll = !selectAll;
      // Provider.of<LoadTransactions>(
      //   context,
      //   listen: false,
      // ).toggleAllTransactionForPrint(false);
    });
  }

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
    final furnizori =
        Provider.of<LoadFurnizori>(context, listen: true).furnizori;

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ClientAddButton(controller: searchController),
          FurnizorPrint(
            selectTransactions: selectTransactions,
            changeSelectTransactions: changeSelectTransactions,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (searchController.text == '')
                    ...furnizori
                        .map((c) => ClientTile(
                              id: c.id,
                              selectTransactions: selectTransactions,
                              changeSelectAll: changeSelectAll,
                              selectAll: selectAll,
                            ))
                        .toList()
                  else if (searchController.text != '')
                    ...furnizori
                        .where((c) => (c.name.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            c.identifier
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase())))
                        .map((c) => ClientTile(
                              id: c.id,
                              selectTransactions: selectTransactions,
                              changeSelectAll: changeSelectAll,
                              selectAll: selectAll,
                            ))
                        .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FurnizorPrint extends StatelessWidget {
  const FurnizorPrint({
    Key key,
    this.changeSelectTransactions,
    this.selectTransactions,
  }) : super(key: key);

  final Function changeSelectTransactions;
  final bool selectTransactions;

  @override
  Widget build(BuildContext context) {
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
                  changeSelectTransactions();
                },
                icon: Icon(
                  selectTransactions ? Icons.close : Icons.add,
                  size: 24,
                ),
                label: Text(selectTransactions
                    ? 'Anulati selectia'
                    : 'Selecteaza tranzactii'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kAccentColor),
                ),
              ),
              const SizedBox(width: 20),
              if (selectTransactions)
                ElevatedButton.icon(
                  onPressed: () async {
                    final List<MyTransaction> selectedTx =
                        Provider.of<LoadTransactions>(context, listen: false)
                            .transactions
                            .where((e) => e.selectedForPrint)
                            .toList();

                    if (selectedTx != null && selectedTx.isNotEmpty) {
                      final selectedFurnizor = LoadFurnizori.getFurnizorById(
                          selectedTx.first.furnizorId);

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAppTest(
                            furnizor: selectedFurnizor,
                            transactions: selectedTx,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.print, size: 24),
                  label: const Text('Printeaza'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kAccentColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
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
                  await addFurnizor(context);
                },
                icon: const Icon(Icons.add, size: 24),
                label: const Text('Adauga furnizor'),
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

class ClientTile extends StatelessWidget {
  const ClientTile({
    Key key,
    this.id,
    this.selectTransactions,
    this.changeSelectAll,
    this.selectAll,
  }) : super(key: key);

  final String id;
  final bool selectTransactions;

  final Function changeSelectAll;
  final bool selectAll;

  @override
  Widget build(BuildContext context) {
    final f = LoadFurnizori.getFurnizorById(id);
    List<MyTransaction> transactions =
        Provider.of<LoadTransactions>(context, listen: true)
            .transactions
            .where((e) => e.furnizorId == f.id)
            .toList()
            .reversed
            .toList();

    final noOfTransactions =
        Provider.of<LoadTransactions>(context, listen: true)
                .transactions
                .where((e) => e.selectedForPrint && e.furnizorId == f.id)
                .length ??
            0;

    final textNoOfTransactions =
        noOfTransactions.toStringAsFixed(0) + ' selectate';

    final tx1 = transactions
        .map((e) => TransactionTileV2(
              id: e.id,
              from: 'furnizori',
            ))
        .toList();
    final tx2 = transactions
        .map((e) => TransactionTile(
              id: e.id,
              from: 'furnizori',
            ))
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.grey[350],
              child: InkWell(
                onTap: () {
                  print('here');
                  Provider.of<LoadFurnizori>(context, listen: false)
                      .toggleTransactions(f.id, f.showTransactions);
                  if (selectTransactions) {
                    Provider.of<LoadTransactions>(
                      context,
                      listen: false,
                    ).toggleAllTransactionForPrint(false);
                    if (selectAll) {
                      changeSelectAll();
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (f.showTransactions == true &&
                              selectTransactions &&
                              transactions != null &&
                              transactions.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<LoadTransactions>(
                                    context,
                                    listen: false,
                                  ).toggleAllTransactionForPrintForTx(
                                    f.id,
                                    !selectAll,
                                  );
                                  changeSelectAll();
                                },
                                child: Text(
                                    !selectAll ? 'Adauga tot' : 'Sterge tot'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kAccentColor),
                                ),
                              ),
                            ),
                          if (noOfTransactions != 0)
                            Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: const BoxDecoration(
                                color: kAccentColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Text(
                                textNoOfTransactions,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Text(
                            f.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(f.identifier),
                        ],
                      ),
                      FurnizorOptions(f: f),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        f.showTransactions == true
            ? (transactions != null && transactions.isNotEmpty)
                ? Container(
                    width: MediaQuery.of(context).size.width - 80,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (selectTransactions)
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tx1.length,
                              itemBuilder: (context, index) {
                                return tx1[index];
                              },
                            )
                          else
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tx2.length,
                              itemBuilder: (context, index) {
                                return tx2[index];
                              },
                            )
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 80,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('nu exista tranzactii'),
                      ],
                    ),
                  )
            : Container(),
      ],
    );
  }
}

class TransactionTileV2 extends StatelessWidget {
  const TransactionTileV2({Key key, this.id, this.from}) : super(key: key);

  final String id;
  final String from;

  @override
  Widget build(BuildContext context) {
    final t = LoadTransactions.getTransactionById(id);
    bool isIntrare = t.type == 'intrare';

    Contract contract;
    double quantity;

    Furnizor furnizor;

    if (isIntrare) {
      furnizor = LoadFurnizori.getFurnizorById(t.furnizorId);
    } else {
      contract = LoadClients.getContractById(t.clientId, t.contractId);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: (from == 'contracts' || from == 'furnizori')
                ? BorderRadius.circular(0)
                : BorderRadius.circular(10),
            child: Material(
              color: (from == 'contracts' || from == 'furnizori')
                  ? Colors.grey[200]
                  : Colors.grey[350],
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        (from == 'contracts' || from == 'furnizori') ? 0 : 20,
                    vertical:
                        (from == 'contracts' || from == 'furnizori') ? 0 : 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: t.selectedForPrint,
                          onChanged: (bool value) {
                            Provider.of<LoadTransactions>(
                              context,
                              listen: false,
                            ).toggleTransactionForPrint(id, value);
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (from == 'furnizori')
                                    Container(
                                      width: 70,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: kAccentColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        t.productType,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  if (from != 'contracts' &&
                                      from != 'furnizori')
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: from == 'furnizori' ? 10 : 0),
                                      width: from == 'furnizori' ? null : 250,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (isIntrare && furnizor != null)
                                            Text(furnizor.name),
                                          if (!isIntrare && contract != null)
                                            Text(contract.clientName +
                                                ' - ' +
                                                contract.number),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              // flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (t.date != null && t.date != '')
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(t.date),
                                    ),
                                  if (t.details != null && t.details != '')
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(t.details),
                                    ),
                                  if (t.carPlate != null && t.carPlate != '')
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(t.carPlate),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FurnizorOptionsV2(
                        t: t,
                        isIntrare: isIntrare,
                        c: contract,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FurnizorOptionsV2 extends StatelessWidget {
  const FurnizorOptionsV2({Key key, this.t, this.isIntrare, this.c})
      : super(key: key);

  final MyTransaction t;
  final bool isIntrare;
  final Contract c;

  @override
  Widget build(BuildContext context) {
    Map<String, double> params = cerealeParams[t.productType];
    bool showPenalized = t.type == 'intrare' && t.penalizedPrice != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (t.price != null)
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: const BoxDecoration(
              color: kGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Pret'),
                  if (showPenalized)
                    const TextSpan(text: ' / Penalizat: ')
                  else
                    const TextSpan(text: ': '),
                  TextSpan(
                    text: numberFormat.format(t.price),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (t.type == 'iesire' && c.currency != null)
                    TextSpan(
                      text: ' ' + (c.currency ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (t.currency != null)
                    TextSpan(
                      text: ' ' + (t.currency ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (showPenalized)
                    TextSpan(
                      text: t.penalizedPrice != null
                          ? (' / ' + numberFormat.format(t.penalizedPrice ?? 0))
                          : '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (showPenalized && t.currency != null)
                    TextSpan(
                      text: ' ' + (t.currency ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (t.type == 'intrare')
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: const BoxDecoration(
              color: kGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  if (params['humidity'] != null) const TextSpan(text: 'U '),
                  if (t.humidity != null)
                    TextSpan(
                      text: t.humidity.toStringAsFixed(2) + '%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (params['humidity'] != null)
                    const TextSpan(
                      text: '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (params['foreignObjects'] != null)
                    const TextSpan(text: ' | CS '),
                  if (t.foreignObjects != null)
                    TextSpan(
                      text: t.foreignObjects.toStringAsFixed(2) + '%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (params['foreignObjects'] != null)
                    const TextSpan(
                      text: '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (params['hectolitre'] != null)
                    const TextSpan(text: ' | H '),
                  if (t.hectolitre != null)
                    TextSpan(
                      text: t.hectolitre.toStringAsFixed(2) + '%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (params['hectolitre'] != null)
                    const TextSpan(
                      text: '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            // color: Color.fromRGBO(40, 79, 70, 1),
            color: isIntrare
                ? const Color.fromRGBO(40, 79, 70, 1)
                : Colors.redAccent,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Cantitate: ' + (isIntrare ? '+' : '-')),
                TextSpan(
                  text: numberFormat.format(t.quantity),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClientOptionsIcon(
          icon: Icons.edit_outlined,
          label: 'Modifica',
          onTap: () async {
            await modifyTransaction(context, t);
          },
        ),
        ClientOptionsIcon(
          icon: Icons.delete_outline,
          label: 'Sterge',
          onTap: () async {
            await deleteTransaction(context, t);
          },
        ),
      ],
    );
  }
}

class FurnizorOptions extends StatelessWidget {
  const FurnizorOptions({Key key, this.f}) : super(key: key);

  final Furnizor f;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FurnizorOptionsIcon(
          icon: Icons.edit_outlined,
          label: 'Modifica',
          onTap: () async {
            await modifyFurnizor(context, f);
          },
        ),
        FurnizorOptionsIcon(
          icon: Icons.delete_outline,
          label: 'Sterge',
          onTap: () async {
            await deleteFurnizor(context, f);
          },
        ),
      ],
    );
  }
}

class FurnizorOptionsIcon extends StatelessWidget {
  const FurnizorOptionsIcon({Key key, this.icon, this.onTap, this.label})
      : super(key: key);

  final IconData icon;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 5),
        ElevatedButton.icon(
          onPressed: () {
            onTap();
          },
          icon: Icon(icon, size: 24),
          label: Text(label),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kAccentColor),
          ),
        ),
      ],
    );
  }
}
