import 'package:flutter/material.dart';
import 'package:front_investoryb3/pages/homepage.dart';
import 'package:front_investoryb3/pages/signin.dart';
import 'package:front_investoryb3/pages/signup.dart';

import '../db/db.dart';
import 'stocklist.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    tokenverify().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninPage(),
                    ),
                  );
                },
                child: const Text('login'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text('Realize seu cadastro!'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signup(),
                    ),
                  );
                },
                child: const Text('Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> tokenverify() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();
    print('Lista de user: ${userlist}');
    if (userlist.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
