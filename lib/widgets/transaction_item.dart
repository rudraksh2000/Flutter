// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionItem extends StatefulWidget {
  // You only need to have key at root level widget in this case is
  // TransactionItem.
  const TransactionItem({
    Key key,
    @required this.userTransaction,
    @required this.deleteTxn,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function deleteTxn;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const avaialbleColors = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.pink,
    ];
    _bgColor = avaialbleColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$${widget.userTransaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.userTransaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.userTransaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                onPressed: () => widget.deleteTxn(widget.userTransaction.id),
                icon: Icon(Icons.delete),
                // this is for red color.
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete'),
              )
            : IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                iconSize: 30,
                color: Theme.of(context).accentColor,
                // here we are passing the function not as a reference
                // because we need an argument with also.
                onPressed: () => widget.deleteTxn(widget.userTransaction.id),
              ),
      ),
    );
    // the given above is one way od getting the transaction
    // the other way is to use ListView.

    // Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         margin:
    //             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             width: 2,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ),
    //         // here we can see that margin is taking space outside of
    //         // the border but padding it taking the inside space around
    //         // the child.
    //         padding: EdgeInsets.all(10),
    //         child: Text(
    //           // toStringAsFixed for fixed decimal values
    //           '\$${userTransactions[index].amount.toStringAsFixed(2)}',
    //           style: Theme.of(context).textTheme.headline6,
    //         ),
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             userTransactions[index].title,
    //             style: Theme.of(context).textTheme.headline6,
    //           ),
    //           Text(
    //             DateFormat.yMMMd()
    //                 .format(userTransactions[index].date),
    //             style: TextStyle(
    //               color: Colors.blueGrey,
    //               fontSize: 10,
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
