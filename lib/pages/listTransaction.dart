import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_investoryb3/componets/home/cardTransaction.dart';
import 'package:front_investoryb3/models/transactions.dart';
import 'package:http/http.dart' as http;
import '../db/db.dart';
import '../repository/userrepo.dart';
import 'landinpage.dart';

class ListTransactions extends StatefulWidget {
  const ListTransactions({Key? key}) : super(key: key);

  @override
  State<ListTransactions> createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  final _userrepo = UserRepository();
  List<Transaction> transactionlist = [];
  String nameuser = '';

  @override
  void initState() {
    super.initState();
    listAllTrasaction();
  }

  Future<void> listAllTrasaction() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();
    print('Listuser: ${userlist}');
    if (userlist.isNotEmpty) {
      var url = Uri.parse('http://10.0.2.2:8000/wallet/transactions-summary/');
      var headers_local = "Bearer ${userlist[0].acessToken}";
      var res = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: headers_local});
      print('variavel headers: ${headers_local}');
      if (res.statusCode == 200) {
        final jsonResData = jsonDecode(res.body);
        print('Response: ${jsonResData}');
        List<Transaction> fetchedTransactionList = List<Transaction>.from(
            jsonResData.map((t) => Transaction.fromMap(t)));
        setState(() {
          transactionlist = fetchedTransactionList;
          nameuser = userlist[0].name;
        });
        print('lista de transações: ${transactionlist}');
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
        title: const Text("Suas Transações"),
        actions: [
          IconButton(
            onPressed: () async {
              bool isLogout = await _userrepo.logout();
              if (isLogout) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
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
                    nameuser,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Lista de ações'),
              onTap: () {
                // ir para stocklist
              },
            ),
            ListTile(
              title: const Text('Transações'),
              onTap: () {
                // ir para página de trasações
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
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
                itemCount: transactionlist.length,
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
                    total_operation: trasaction.total_operation,
                    average_price: trasaction.average_price,
                    profit_loss: trasaction.profit_loss,
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Ir para  'Todas as transações' button tap
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
                // Ir para  'Todas as transações' button tap
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
