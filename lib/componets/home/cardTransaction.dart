import 'package:flutter/material.dart';

class CardTransaction extends StatelessWidget {
  final int id;
  final String stockCode;
  final int? investor;
  final int quantity_stock;
  final double unite_price;
  final String type_of;
  final double brokerage;
  final String date_done;
  final double total_operation;
  final double? average_price;
  final double? profit_loss;

  const CardTransaction(
      {Key? key,
      required this.id,
      required this.stockCode,
      required this.quantity_stock,
      required this.unite_price,
      required this.type_of,
      required this.brokerage,
      required this.date_done,
      required this.total_operation,
      this.average_price,
      this.profit_loss,
      this.investor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 60,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF14405D),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    stockCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total gasto R\$ $total_operation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Dia: $date_done'),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Quantidade de ações: $quantity_stock',
              ),
              Text(
                'Preço unitário: R\$ $unite_price',
              ),
              Text(
                'Tipo de operação: ${type_of == 'C' ? 'compra' : 'venda'}',
              ),
              Text('Brokerage: $brokerage'),
              if (average_price != null && profit_loss != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Preço médio: $average_price'),
                    Text('Lucro/Prejuízo: $profit_loss'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
