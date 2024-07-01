import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _permissionDenied = false;

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
      });
    }
  }

  _filter(String text) {
    print("Recherch $text");
    setState(() {
      if (text.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts
            .where((element) =>
                element.displayName
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                (element.phones.isNotEmpty &&
                    element.phones[0].normalizedNumber
                        .replaceAll("+221", "")
                        .toLowerCase()
                        .startsWith(text.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achat Crédit"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "À",
                ),
                onChanged: (text) {
                  _filter(text);
                },
                onSubmitted: (text) {
                  print("Afficher $text");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    itemCount: _filteredContacts
                        .length/*< 20 ? _filteredContacts.length : 20*/,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, i) {
                      Contact c = _filteredContacts[i];
                      String num = c.phones.isNotEmpty
                          ? c.phones[0].normalizedNumber.startsWith('+221')
                              ? c.phones[0].normalizedNumber
                                  .replaceAll("+221", "")
                              : ""
                          : "";
                      String finalNum = num.startsWith("7") ? num : "";
                      return finalNum.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: finalNum.startsWith("77") ||
                                                finalNum.startsWith("78")
                                            ? Colors.orange
                                            : finalNum.startsWith("76")
                                                ? Colors.red
                                                : Colors.deepPurpleAccent,
                                        borderRadius:
                                            BorderRadius.circular(45)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.displayName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        finalNum,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
