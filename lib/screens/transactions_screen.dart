import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/main.dart';
import 'package:achizitii_cereale/models/models.dart';
import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/providers/transactionsProvider.dart';
import 'package:achizitii_cereale/widgets/show_dialogs_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key key, this.productType}) : super(key: key);

  final String productType;

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
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
    final transactions = Provider.of<LoadTransactions>(context, listen: true)
        .transactions
        .reversed;

    final stock = Provider.of<LoadTransactions>(context, listen: true)
        .getStockByType(widget.productType);

    final clients = Provider.of<LoadClients>(context, listen: true).clients;
    final furnizori =
        Provider.of<LoadFurnizori>(context, listen: true).furnizori;

    final tx1 = transactions
        .where((c) => (c.productType == widget.productType))
        .map((c) => TransactionTile(
              id: c.id,
              from: 'tranzactions',
            ))
        .toList();
    final tx2 = transactions
        .where((c) => ((c.type
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                (c.type == 'intrare'
                    ? furnizori.any((fur) => (fur.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) &&
                        fur.id == c.furnizorId))
                    : clients.any((cli) => (cli.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) &&
                        cli.id == c.clientId)))) &&
            c.productType == widget.productType))
        .map((c) => TransactionTile(id: c.id, from: 'tranzactions'))
        .toList();

    // print('refresh');

    // tx2.forEach(((element) {
    //   var xx = LoadTransactions.getTransactionById(element.id);
    //   if (xx.furnizorId != null) {
    //     var furnizor = LoadFurnizori.getFurnizorById(xx.furnizorId);
    //     print(furnizor.name);
    //   }
    // }));

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ClientAddButton(
            controller: searchController,
            productType: widget.productType,
            stock: stock,
          ),
          Expanded(
            child: (searchController.text == '')
                ?
                // ...transactions
                //     .where((c) => (c.productType == widget.productType))
                //     .map((c) => TransactionTile(
                //           id: c.id,
                //           from: 'tranzactions',
                //         ))
                //     .toList()
                ListView.builder(
                    itemCount: tx1.length,
                    itemBuilder: (context, index) {
                      return tx1[index];
                    },
                  )
                :
                //  (searchController.text != '')
                // ...transactions
                //     .where((c) => ((c.type.toLowerCase().contains(
                //                 searchController.text.toLowerCase()) ||
                //             (c.type == 'intrare'
                //                 ? furnizori.any((fur) => fur.name
                //                     .toLowerCase()
                //                     .contains(searchController.text
                //                         .toLowerCase()))
                //                 : clients.any((cli) => cli.name
                //                     .toLowerCase()
                //                     .contains(searchController.text
                //                         .toLowerCase())))) &&
                //         c.productType == widget.productType))
                //     .map((c) => TransactionTile(id: c.id, from: 'tranzactions'))
                //     .toList(),
                ListView.builder(
                    itemCount: tx2.length,
                    itemBuilder: (context, index) {
                      return tx2[index];
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ClientAddButton extends StatelessWidget {
  const ClientAddButton({
    Key key,
    this.controller,
    this.productType,
    this.stock,
  }) : super(key: key);

  final TextEditingController controller;
  final String productType;
  final double stock;

  @override
  Widget build(BuildContext context) {
    const primaryColor = kPrimaryColor;
    const secondaryColor = kAccentColor;
    const accentColor = Color(0xffffffff);
    const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.symmetric(vertical: 4),
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
                  await addTranzactie(context, productType);
                },
                icon: const Icon(Icons.add, size: 24),
                label: const Text('Adauga tranzactie'),
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
              // const SizedBox(width: 20),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(50),
              //   child: Material(
              //     color: Colors.grey[350],
              //     child: InkWell(
              //       onTap: () => controller.text = '',
              //       child: Container(
              //         padding: const EdgeInsets.all(8),
              //         child: const Icon(
              //           Icons.close,
              //           color: kPrimaryColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                // width: 70,
                height: 32,
                margin: const EdgeInsets.only(left: 20),
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
                child: Center(
                  child: Text(
                    'Total ' +
                        productType.toTitleCase() +
                        ': ' +
                        numberFormat.format(stock),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

class TransactionTile extends StatelessWidget {
  const TransactionTile({Key key, this.id, this.from}) : super(key: key);

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

    return Container(
      child: Column(
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
                  // onTap: () {
                  //   // print('here');
                  //   // Provider.of<LoadFurnizori>(context, listen: false)
                  //   //     .toggleTransactions(f.id, f.showTransactions);
                  // },
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
                                        margin:
                                            const EdgeInsets.only(right: 10),
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
                                            right:
                                                from == 'furnizori' ? 10 : 0),
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
                        ClientOptions(
                          t: t,
                          isIntrare: isIntrare,
                          from: from,
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
      ),
    );
  }
}

class ClientOptions extends StatelessWidget {
  const ClientOptions({Key key, this.t, this.isIntrare, this.from, this.c})
      : super(key: key);

  final MyTransaction t;
  final bool isIntrare;
  final String from;
  final Contract c;

  @override
  Widget build(BuildContext context) {
    Map<String, double> params = cerealeParams[t.productType];

    bool showPenalized =
        t.type == 'intrare' && from != 'contracts' && t.penalizedPrice != null;

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
        // if (showPenalized)
        //   Container(
        //     margin: const EdgeInsets.only(right: 20),
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 5,
        //       horizontal: 10,
        //     ),
        //     decoration: const BoxDecoration(
        //       color: kGrey,
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(5),
        //       ),
        //     ),
        //     child: RichText(
        //       text: TextSpan(
        //         style: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.normal,
        //           color: Colors.white,
        //         ),
        //         children: <TextSpan>[
        //           const TextSpan(text: 'Pret penalizat: '),
        //           TextSpan(
        //             text: t.penalizedPrice != null
        //                 ? numberFormat.format(t.penalizedPrice ?? 0)
        //                 : '-',
        //             style: const TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           if (t.currency != null)
        //             TextSpan(
        //               text: ' ' + (t.currency ?? ''),
        //               style: const TextStyle(
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //         ],
        //       ),
        //     ),
        //   ),
        if (t.type == 'intrare' && from != 'contracts')
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

class ClientOptionsIcon extends StatelessWidget {
  const ClientOptionsIcon({Key key, this.icon, this.onTap, this.label})
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
