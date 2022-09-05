import 'package:achizitii_cereale/constants.dart';
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
    final clients = Provider.of<LoadClients>(context, listen: true).contracts;

    List<String> options = ['toate', 'active', 'inactive'];
    List<Container> selectArray = options
        .map(
          (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(e, style: const TextStyle(fontSize: 14)),
          ),
        )
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
                    ...clients
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
                    ...clients
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
              // ElevatedButton.icon(
              //   onPressed: () async {
              //     await addClient(context);
              //   },
              //   icon: const Icon(Icons.add, size: 24),
              //   label: const Text('Adauga client'),
              //   style: ButtonStyle(
              //     backgroundColor:
              //         MaterialStateProperty.all<Color>(kAccentColor),
              //   ),
              // ),
              // const SizedBox(width: 20),
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

// class ClientTile extends StatelessWidget {
//   const ClientTile({Key key, this.id, this.clientId}) : super(key: key);

//   final String id;
//   final String clientId;

//   @override
//   Widget build(BuildContext context) {
//     final c = LoadClients.getContractById(clientId, id);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width - 40,
//           margin: const EdgeInsets.only(bottom: 10),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Material(
//               color: Colors.grey[350],
//               child: InkWell(
//                 onTap: () {
//                   // print('here');
//                   // Provider.of<LoadClients>(context, listen: false)
//                   //     .toggleContracts(c.id, c.showContracts);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 20,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(c.name),
//                           const SizedBox(width: 10),
//                           Text(c.identifier),
//                           // const SizedBox(width: 10),
//                         ],
//                       ),
//                       ClientOptions(c: c),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // c.showContracts == true ?
//         // (c.contracts != null && c.contracts.isNotEmpty)
//         //     ? Container(
//         //         width: MediaQuery.of(context).size.width - 40,
//         //         margin: const EdgeInsets.only(bottom: 10),
//         //         padding: const EdgeInsets.symmetric(
//         //           horizontal: 20,
//         //           vertical: 10,
//         //         ),
//         //         decoration: BoxDecoration(
//         //           borderRadius: const BorderRadius.all(Radius.circular(10)),
//         //           color: Colors.grey[350],
//         //         ),
//         //         child: Column(
//         //           children: [
//         //             ...c.contracts
//         //                 .map((e) => ContractTile(c: c, e: e))
//         //                 .toList(),
//         //           ],
//         //         ),
//         //       )
//         //     : Container(),
//         // : Container(
//         //     width: MediaQuery.of(context).size.width - 80,
//         //     margin: const EdgeInsets.only(bottom: 10),
//         //     padding:
//         //         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         //     decoration: BoxDecoration(
//         //       borderRadius: const BorderRadius.all(Radius.circular(10)),
//         //       color: Colors.grey[200],
//         //     ),
//         //     child: Column(
//         //       mainAxisAlignment: MainAxisAlignment.start,
//         //       crossAxisAlignment: CrossAxisAlignment.center,
//         //       children: const [
//         //         Text('nu exista contracte'),
//         //       ],
//         //     ),
//         //   ),
//       ],
//     );
//   }
// }

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
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      margin: const EdgeInsets.only(right: 10),
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
                      margin: const EdgeInsets.only(right: 10),
                      child: Text(c.name),
                    ),
                    if (e.number != null && e.number != '')
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(e.number ?? '-'),
                      ),
                    // if (e.productType != null && e.productType != '')
                    //   Container(
                    //     margin: const EdgeInsets.only(right: 10),
                    //     child: Text(e.productType ?? '-'),
                    //   ),
                    // Container(
                    //   margin: const EdgeInsets.only(right: 10),
                    //   child: Text(numberFormat.format(all ?? 0) +
                    //       ' / ' +
                    //       numberFormat.format(e.quantity ?? 0)),
                    // ),
                    if (e.price != null)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(e.price != null
                            ? (numberFormat.format(e.price ?? 0) + ' lei')
                            : ''),
                      ),
                    if (e.date != null && e.date != '')
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(e.date ?? '-'),
                      ),
                    if (e.details != null && e.details != '')
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(e.details ?? '-'),
                      ),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(40, 79, 70, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        numberFormat.format(all ?? 0) +
                            ' / ' +
                            numberFormat.format(e.quantity ?? 0),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                ContractOptions(
                  client: c,
                  contract: e,
                ),
              ],
            ),
          ),
          // ...transactions.map((e) => TransactionTile(id: e.id)).toList(),
        ],
      ),
    );
  }
}

class ContractOptions extends StatelessWidget {
  const ContractOptions({Key key, this.client, this.contract})
      : super(key: key);

  final Client client;
  final Contract contract;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
