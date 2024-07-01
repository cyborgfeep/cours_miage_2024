import 'package:cours_miage/models/transaction.dart';
import 'package:cours_miage/screens/credit_screen.dart';
import 'package:cours_miage/screens/scan_screen.dart';
import 'package:cours_miage/utils/constants.dart';
import 'package:cours_miage/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVisible = true;

  setVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    initJiffy();
  }

  initJiffy() async {
    await Jiffy.setLocale('fr_ca');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: kPrimaryColor,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isVisible ? "10.000F" : "••••••••",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        setVisible();
                      },
                      child: Icon(
                        !isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 2000,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    margin: const EdgeInsets.only(top: 150),
                  ),
                  Column(
                    children: [
                      const CardWidget(
                        isClickable: true,
                      ),
                      GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          optionWidget(
                              icon: Icons.person,
                              text: "Transfert",
                              color: kPrimaryColor),
                          optionWidget(
                              icon: Icons.shopping_cart_outlined,
                              text: "Paiements",
                              color: Colors.orangeAccent),
                          optionWidget(
                              icon: Icons.phone_android,
                              text: "Crédit",
                              color: Colors.blue,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return const CreditScreen();
                                  },
                                ));
                              }),
                          optionWidget(
                              icon: Icons.account_balance,
                              text: "Banque",
                              color: Colors.red),
                          optionWidget(
                              icon: Icons.card_giftcard_outlined,
                              text: "Cadeaux",
                              color: Colors.green),
                        ],
                      ),
                      Divider(
                        thickness: 8,
                        color: Colors.grey.shade200,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: Transaction.getList().length,
                        itemBuilder: (context, index) {
                          Transaction t = Transaction.getList()[index];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${t.type == TransactionType.transfertE ? "De " : t.type == TransactionType.transfertS ? "À " : ""}${t.title}",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "${t.type == TransactionType.depot || t.type == TransactionType.transfertE ? "" : "-"}${t.amount}F",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Jiffy.parseFromDateTime(t.dateTime)
                                      .format(pattern: "dd MMMM yyyy à HH:mm"),
                                  style: TextStyle(color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget optionWidget(
      {required IconData icon,
      required String text,
      required Color color,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(60)),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text)
        ],
      ),
    );
  }
}
