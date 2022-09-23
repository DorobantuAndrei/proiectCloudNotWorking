import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/main.dart';
import 'package:achizitii_cereale/models/models.dart';
import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactionsProvider.dart';
import '../widgets/show_dialogs.dart';
import 'transactions_screen.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({Key key}) : super(key: key);

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
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

  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    List<Contract> contracts =
        Provider.of<LoadClients>(context, listen: true).contracts;
    contracts.sort(((a, b) => a.active ? 0 : 1));

    // List<String> options = ['toate', 'active', 'inactive'];
    // List<Container> selectArray = options
    //     .map(
    //       (e) => Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //         child: Text(e, style: const TextStyle(fontSize: 14)),
    //       ),
    //     )
    //     .toList();

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ClientAddButton(controller: searchController),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     const Text('Contracte: '),
          //     const SizedBox(width: 10),
          //     ToggleButtons(
          //       fillColor: kAccentColor,
          //       selectedColor: Colors.white,
          //       color: Colors.black,
          //       children: selectArray,
          //       isSelected: isSelected,
          //       onPressed: (int newIndex) {
          //         print(newIndex);
          //         setState(() {
          //           for (int i = 0; i < isSelected.length; i++) {
          //             isSelected[i] = i == newIndex;
          //           }
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (searchController.text == '')
                    ...contracts
                        .where((e) => (isSelected[0]
                            ? true
                            : (isSelected[1]
                                ? e.active == true
                                : (isSelected[2] ? e.active == false : false))))
                        .map((c) => ContractTile(
                              e: c,
                              c: LoadClients.getClientById(c.clientId),
                            ))
                        .toList()
                  else if (searchController.text != '')
                    ...contracts
                        .where((e) => ((isSelected[0]
                                ? true
                                : (isSelected[1]
                                    ? e.active == true
                                    : (isSelected[2]
                                        ? e.active == false
                                        : false))) &&
                            (e.number.toLowerCase().contains(
                                    searchController.text.toLowerCase()) ||
                                e.clientName.toLowerCase().contains(
                                    searchController.text.toLowerCase()))))
                        .map((c) => ContractTile(
                              e: c,
                              c: LoadClients.getClientById(c.clientId),
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

class ClientOptions extends StatelessWidget {
  const ClientOptions({Key key, this.c}) : super(key: key);

  final Client c;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClientOptionsIcon(
          icon: Icons.add,
          label: 'Contract',
          onTap: () async {
            await addContract(context, c);
          },
        ),
        ClientOptionsIcon(
          icon: Icons.edit_outlined,
          label: 'Modifica',
          onTap: () async {
            await modifyClient(context, c);
          },
        ),
        ClientOptionsIcon(
          icon: Icons.delete_outline,
          label: 'Sterge',
          onTap: () async {
            await deleteClient(context, c);
          },
        ),
      ],
    );
  }
}

class ContractTile extends StatelessWidget {
  const ContractTile({Key key, this.e, this.c}) : super(key: key);

  final Contract e;
  final Client c;

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<LoadTransactions>(context, listen: true)
        .transactions
        .where((elem) => elem.contractId == e.id);
    double all = 0;
    transactions.forEach((element) {
      all += element.quantity;
    });

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
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
                    Provider.of<LoadClients>(context, listen: false)
                        .toggleTransactions(c.id, e.id, e.showTransactions);
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
                        Container(
                          width: 70,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: e.active ? Colors.green : Colors.redAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            e.active ? 'activ' : 'inactiv',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                            e.productType.toTitleCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(c.name),
                                ),
                                if (e.number != null && e.number != '')
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(e.number ?? '-'),
                                  ),
                              ],
                            ),
                            if (e.date != null && e.date != '')
                              Container(
                                width: 2,
                                height: 30,
                                margin: const EdgeInsets.only(right: 10),
                                color: kGrey,
                              ),
                            if (e.date != null && e.date != '')
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(e.date ?? '-'),
                              ),
                            if (e.details != null && e.details != '')
                              Container(
                                width: 2,
                                height: 30,
                                margin: const EdgeInsets.only(right: 10),
                                color: kGrey,
                              ),
                            if (e.details != null && e.details != '')
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(e.details ?? '-'),
                              ),
                          ],
                        ),
                        ContractOptions(
                          client: c,
                          contract: e,
                          all: all,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          e.showTransactions == true
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        children: [
                          ...transactions
                              .map((e) => TransactionTile(
                                    id: e.id,
                                    from: 'contracts',
                                  ))
                              .toList(),
                        ],
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 80,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
      ),
    );
  }
}

class ContractOptions extends StatelessWidget {
  const ContractOptions({Key key, this.client, this.contract, this.all})
      : super(key: key);

  final Client client;
  final Contract contract;
  final double all;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 5,
        children: [
          // Container(
          //   width: 70,
          //   margin: const EdgeInsets.only(left: 10),
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 5,
          //     horizontal: 10,
          //   ),
          //   decoration: const BoxDecoration(
          //     color: kAccentColor,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(5),
          //     ),
          //   ),
          //   child: Text(
          //     contract.productType.toTitleCase(),
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          if (contract.price != null)
            Container(
              margin: const EdgeInsets.only(left: 10),
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
                    const TextSpan(text: 'Pret: '),
                    TextSpan(
                      text: numberFormat.format(contract.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ' + (contract.currency ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
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
                  const TextSpan(text: 'Cantitate: '),
                  TextSpan(
                    text: numberFormat.format(all),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: numberFormat.format(contract.quantity),
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
              await modifyContract(context, client, contract);
            },
          ),
          ClientOptionsIcon(
            icon: Icons.delete_outline,
            label: 'Sterge',
            onTap: () async {
              await deleteContract(context, client, contract);
            },
          ),
        ],
      ),
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
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          onTap();
        },
        icon: Icon(icon, size: 24),
        label: Text(label),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kAccentColor),
        ),
      ),
    );
  }
}
