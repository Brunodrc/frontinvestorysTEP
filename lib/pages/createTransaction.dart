import 'dart:convert';
import 'dart:io';
import 'package:validators/validators.dart' as validator;
import 'package:flutter/material.dart';
import 'package:front_investoryb3/db/db.dart';
import 'package:front_investoryb3/models/transactions.dart';
import 'package:front_investoryb3/pages/listTransaction.dart';
import 'package:http/http.dart' as http;

class CreateTransaction extends StatefulWidget {
  const CreateTransaction({super.key});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController stockInput = TextEditingController();
  TextEditingController quantityInput = TextEditingController();
  TextEditingController priceUnitteInput = TextEditingController();
  TextEditingController typeofInput = TextEditingController();
  TextEditingController brokerageInput = TextEditingController();

  Future<bool> createTransaction(Transaction transaction) async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();
    if (userlist.isNotEmpty) {
      var url = Uri.parse('http://10.0.2.2:8000/wallet/transactions/');
      var headers_local = "Bearer ${userlist[0].acessToken}";

      Map<String, dynamic> bodydata = {
        "stock_code": transaction.stockCode.toUpperCase(),
        "quantity_stock": transaction.quantity_stock.toString(),
        "unite_price": transaction.unite_price.toString(),
        "type_of": transaction.type_of.toUpperCase(),
        "brokerage": transaction.brokerage.toString(),
      };

      var res = await http.post(url,
          body: bodydata,
          headers: {HttpHeaders.authorizationHeader: headers_local});
      if (res.statusCode >= 200) {
        print('deu certo');
        return true;
      } else {
        print('Ocorreu um erro!');
        print('${res.body} o status code: ${res.statusCode}');
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicione uma nova Transação'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: stockInput,
                maxLength: 40,
                keyboardType: TextInputType.name,
                validator: (stock) {
                  if (stock == null || stock.isEmpty) {
                    return 'Por favor, preencha o campo';
                  } else {
                    try {
                      String pattern = r'^[A-Z]{4}\d{1,2}$';
                      String value = stock.toUpperCase();
                      if (!validator.matches(value, pattern)) {
                        throw Exception(
                            'O código deve ter 4 letras maiúsculas seguidas de um ou dois números.');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.pink,
                        ),
                      );
                    }
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Por exemplo: ITSA4',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: quantityInput,
                maxLength: 40,
                keyboardType: TextInputType.number,
                validator: (qtd) {
                  if (qtd == null || qtd.isEmpty) {
                    return 'Por favor, preencha o campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Quantidade de ações',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: priceUnitteInput,
                maxLength: 40,
                keyboardType: TextInputType.number,
                validator: (price) {
                  if (price == null || price.isEmpty) {
                    return 'Por favor, preencha o campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Preço de uma ação',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: typeofInput,
                maxLength: 40,
                keyboardType: TextInputType.name,
                validator: (type) {
                  if (type == null || type.isEmpty) {
                    return 'Por favor, preencha o campo';
                  } else if (type.toUpperCase() == 'C' ||
                      type.toUpperCase() == 'V') {
                    return null;
                  } else {
                    return 'Por favor, digite uma opção válida.';
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Tipo de operação: 'C' ='Compra','V'='Venda'",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: brokerageInput,
                maxLength: 40,
                keyboardType: TextInputType.number,
                validator: (brokerage) {
                  if (brokerage == null || brokerage.isEmpty) {
                    return 'Por favor, preencha o campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Taxa de corretagem B3',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (_formkey.currentState!.validate()) {
                    Transaction newTrasaction = Transaction(
                      id: 0,
                      stockCode: stockInput.text,
                      quantity_stock: int.parse(quantityInput.text),
                      unite_price: double.parse(priceUnitteInput.text),
                      type_of: typeofInput.text,
                      brokerage: double.parse(brokerageInput.text),
                      date_done: '',
                      total_operation: 0,
                    );
                    createTransaction(newTrasaction);
                    if (await createTransaction(newTrasaction)) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListTransactions(),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Transação Salva!",
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Erro, não foi possível salvar.",
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Cadastro não realizado, tente novamente",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.pink,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Salvar Transação',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
