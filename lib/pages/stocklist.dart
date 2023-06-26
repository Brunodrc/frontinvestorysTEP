import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_investoryb3/pages/landinpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componets/home/cardStock.dart';
import '../db/db.dart';
import '../models/stock.dart';

class Stocklist extends StatefulWidget {
  const Stocklist({super.key});

  @override
  State<Stocklist> createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  List<Stock> stockList = [];

  @override
  void initState() {
    super.initState();
    listAllStock();
  }

  Future<void> listAllStock() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();

    if (userlist.isNotEmpty) {
      print(userlist[0]);

      var url = Uri.parse('http://10.0.2.2:8000/wallet/stocks/');
      var headers_local = "Bearer ${userlist[0].acessToken}";
      var res = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: headers_local});
      print('variavel headers: ${headers_local}');
      if (res.statusCode == 200) {
        final jsonResData = jsonDecode(res.body);
        List<Stock> fetchedStockList =
            List<Stock>.from(jsonResData.map((s) => Stock.fromMap(s)));

        setState(() {
          stockList = fetchedStockList;
        });
      } else {
        // Trate erros de acordo com a resposta do servidor
        print('Erro: ${res.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Seus investimentos"),
        actions: [
          IconButton(
            onPressed: () async {
              bool islogout = await logout();
              if (islogout) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LandingPage(),
                  ),
                );
              }
            },
            icon: Icon(Icons.output_rounded),
            tooltip: 'Sair',
            color: Colors.red,
            iconSize: 38,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: stockList.length,
        itemBuilder: (context, index) {
          Stock stock = stockList[index];
          return CardStock(
            id: stock.id,
            code: stock.code,
            nameEnterprise: stock.nameEnterprise,
            cnpj: stock.cnpj,
            onTap: () {
              // Lógica para tratar o evento de toque no card
            },
          );
        },
      ),
    );
  }

  Future<bool> logout() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();
    await db.deleteToken(userlist[0].id);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
    return true;
  }
}
