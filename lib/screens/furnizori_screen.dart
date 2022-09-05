import 'package:achizitii_cereale/constants.dart';
import 'package:achizitii_cereale/models/models.dart';
import 'package:achizitii_cereale/providers/clientsProvider.dart';
import 'package:achizitii_cereale/providers/furnizoriProvider.dart';
import 'package:achizitii_cereale/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactionsProvider.dart';
import '../widgets/show_dialogs.dart';
import '../widgets/show_dialogs_furnizor.dart';

class FurnizorScreen extends StatefulWidget {
  const FurnizorScreen({Key key}) : super(key: key);

  @override
  State<FurnizorScreen> createState() => _FurnizorScreenState();
}

class _FurnizorScreenState extends State<FurnizorScreen> {
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (searchController.text == '')
                    ...furnizori.map((c) => ClientTile(id: c.id)).toList()
                  else if (searchController.text != '')
                    ...furnizori
                        .where((c) => (c.name.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            c.identifier
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase())))
                        .map((c) => ClientTile(id: c.id))
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
  const ClientTile({Key key, this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    final f = LoadFurnizori.getFurnizorById(id);
    final transactions = Provider.of<LoadTransactions>(context, listen: true)
        .transactions
        .where((e) => e.furnizorId == f.id);

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
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(f.name),
                          const SizedBox(width: 10),
                          Text(f.identifier),
                        ],
                      ),
                      ClientOptions(f: f),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        ...transactions
                            .map((e) => TransactionTile(
                                  id: e.id,
                                  from: 'furnizori',
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

class ClientOptions extends StatelessWidget {
  const ClientOptions({Key key, this.f}) : super(key: key);

  final Furnizor f;

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
            await modifyFurnizor(context, f);
          },
        ),
        ClientOptionsIcon(
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

// class ContractTile extends StatelessWidget {
//   const ContractTile({Key key, this.e, this.c}) : super(key: key);

//   final Contract e;
//   final Client c;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(e.id),
//                     const SizedBox(width: 10),
//                     Text(e.number),
//                     const SizedBox(width: 10),
//                     Text(e.productType),
//                     const SizedBox(width: 10),
//                     Text(e.quantity.toStringAsFixed(0)),
//                     const SizedBox(width: 10),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       decoration: const BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.all(Radius.circular(5)),
//                       ),
//                       child: Text(
//                         e.active ? 'activ' : 'inactiv',
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // ContractOptions(
//                 //   client: c,
//                 //   contract: e,
//                 // ),
//               ],
//             ),
//           ),
//           // const Divider(color: Colors.grey),
//         ],
//       ),
//     );
//   }
// }

// class ContractOptions extends StatelessWidget {
//   const ContractOptions({Key key, this.client, this.contract})
//       : super(key: key);

//   final Client client;
//   final Contract contract;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         ClientOptionsIcon(
//           icon: Icons.edit_outlined,
//           label: 'Modifica',
//           onTap: () async {
//             await modifyContract(context, client, contract);
//           },
//         ),
//         ClientOptionsIcon(
//           icon: Icons.delete_outline,
//           label: 'Sterge',
//           onTap: () async {
//             await deleteContract(context, client, contract);
//           },
//         ),
//       ],
//     );
//   }
// }

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
