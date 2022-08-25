import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingAmountPrcnt;

  ChartBar({this.label, this.spendingAmount, this.spendingAmountPrcnt});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // here we are wrapping fitted box into container so that it does take
        // a range (height) to fit and does not effect the other widgets
        // alignment in the column.
        Container(
          height: 20,
          child: FittedBox(
            child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(220, 220, 220, 1),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingAmountPrcnt,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(label),
      ],
    );
  }
}
