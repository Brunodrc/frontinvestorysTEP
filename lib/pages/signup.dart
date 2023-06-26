import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_investoryb3/pages/stocklist.dart';

import 'package:front_investoryb3/pages/signin.dart';
import 'package:front_investoryb3/repository/userrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../db/db.dart';
import '../models/user.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final userrepo = UserRepository();
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameInput = TextEditingController();
  TextEditingController riskpInput = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  var textvisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: TextFormField(
                    controller: nameInput,
                    maxLength: 40,
                    keyboardType: TextInputType.name,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Por favor, preencha o campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text("Indique o seu perfil de investidor:"),
                ),
                const SizedBox(
                  height: 7,
                ),
                const Center(
                  child: Text(
                      "C' ='Conservador','M'='Moderado' ou 'A'= 'Arrojado'"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextFormField(
                    controller: riskpInput,
                    maxLength: 1,
                    keyboardType: TextInputType.name,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Por favor, preencha o campo';
                      } else if (input.toLowerCase() == 'c' ||
                          input.toLowerCase() == 'm' ||
                          input.toLowerCase() == 'a') {
                        return null;
                      }
                      return 'Por favor, digite uma opção válida.';
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.savings_sharp),
                      labelText: 'Perfil de Investidor',
                      hintText: 'Indique o seu perfil:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailInput,
                  maxLength: 40,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Por favor, preencha o campo com seu e-mail';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(emailInput.text)) {
                      return 'Por favor, digite um e-mail válido';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordInput,
                  maxLength: 40,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Por favor, preencha o campo com uma senha';
                    } else if (password.length < 6) {
                      return 'Por favor, digite uma senha maior que 6 caracteres';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          textvisible = true;
                        });
                      },
                      icon: Icon(textvisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (_formkey.currentState!.validate()) {
                        bool islogin = await userrepo.createLogin(
                            nameInput.text,
                            emailInput.text,
                            passwordInput.text,
                            riskpInput.text);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (islogin) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Stocklist(),
                            ),
                          );
                        }
                      } else {
                        passwordInput.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Cadastro não realizado, tente novamente",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.pink,
                          ),
                        );
                      }
                    },
                    child: const Text('Cadastre-se'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
