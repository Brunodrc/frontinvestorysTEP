import 'package:flutter/material.dart';

class CardStock extends StatelessWidget {
  final int id;
  final String code;
  final String nameEnterprise;
  final String cnpj;
  void Function()? onTap;

  CardStock(
      {super.key,
      required this.id,
      required this.code,
      required this.nameEnterprise,
      required this.cnpj,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              code,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(nameEnterprise),
        subtitle: Text(cnpj),
        onTap: onTap,
      ),
    );
  }
}
