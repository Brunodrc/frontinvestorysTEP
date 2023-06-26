import 'dart:convert';

import 'package:front_investoryb3/db/db.dart';
import 'package:front_investoryb3/models/user.dart';
import 'package:front_investoryb3/pages/homepage.dart';
import 'package:front_investoryb3/pages/stocklist.dart';
import 'package:front_investoryb3/pages/signup.dart';
import 'package:front_investoryb3/repository/userrepo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final userepo = UserRepository();

  final _formkey = GlobalKey<FormState>();

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
                  obscureText: textvisible,
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
                      icon: const Icon(Icons.vaccines_outlined),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (_formkey.currentState!.validate()) {
                        bool islogin = await userepo.login(
                            emailInput.text, passwordInput.text);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (islogin) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ),
                          );
                        }
                      } else {
                        passwordInput.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Senha ou e-mail inválidos, tente novamente",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.pink,
                          ),
                        );
                      }
                    },
                    child: Text('Login')),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup(),
                      ),
                    );
                  },
                  child: Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
