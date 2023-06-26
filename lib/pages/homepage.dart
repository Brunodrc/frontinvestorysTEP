import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_investoryb3/componets/home/cardTransaction.dart';
import 'package:front_investoryb3/models/transactions.dart';
import 'package:front_investoryb3/pages/createTransaction.dart';
import 'package:front_investoryb3/pages/listTransaction.dart';
import 'package:front_investoryb3/pages/stocklist.dart';
import 'package:http/http.dart' as http;
import '../db/db.dart';
import '../repository/userrepo.dart';
import 'landinpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _userrepo = UserRepository();
  List<Transaction> transactionlist = [];
  String nameUser = '';

  @override
  void initState() {
    super.initState();
    listAllTrasaction();
  }

  Future<void> listAllTrasaction() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();

    if (userlist.isNotEmpty) {
      nameUser = userlist[0].name;
      var url = Uri.parse('http://10.0.2.2:8000/wallet/transactions/');
      var headers_local = "Bearer ${userlist[0].acessToken}";
      var res = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: headers_local});

      if (res.statusCode == 200) {
        final jsonResData = jsonDecode(res.body);

        List<Transaction> fetchedTransactionList = List<Transaction>.from(
            jsonResData.map((t) => Transaction.fromMap(t)));
        setState(() {
          transactionlist = fetchedTransactionList;
        });
      } else {
        final resErro = res.body;
        print('Resposta: ${res.body} status code: ${res.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Seus investimentos"),
        actions: [
          IconButton(
            onPressed: () async {
              bool isLogout = await _userrepo.logout();
              if (isLogout) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.output_rounded),
            tooltip: 'Sair',
            color: Colors.red,
            iconSize: 38,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nameUser,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueAccent,
              child: ListTile(
                title: const Text(
                  'Lista de ações',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Stocklist()));
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.cyan,
              child: ListTile(
                title: const Text(
                  'Transações',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListTransactions()));
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Seus últimos investimentos:',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (transactionlist.isEmpty)
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Você ainda não possui transações, clique no botão abaixo:',
                style: TextStyle(
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 30),
          if (!transactionlist.isEmpty)
            Expanded(
              child: ListView.builder(
                itemCount:
                    transactionlist.length < 4 ? transactionlist.length : 4,
                itemBuilder: (context, index) {
                  Transaction trasaction = transactionlist[index];
                  return CardTransaction(
                      id: trasaction.id,
                      stockCode: trasaction.stockCode,
                      quantity_stock: trasaction.quantity_stock,
                      unite_price: trasaction.unite_price,
                      type_of: trasaction.type_of,
                      brokerage: trasaction.brokerage,
                      date_done: trasaction.date_done,
                      total_operation: trasaction.total_operation);
                },
              ),
            ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateTransaction()));
              },
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Adicione uma nova transação',
                  style: TextStyle(fontSize: 23),
                ),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
            ),
          ),
          const SizedBox(height: 20),
          if (!transactionlist.isEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListTransactions()));
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Todas as transações',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
