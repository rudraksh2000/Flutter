// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTxn;

  const TransactionList(this.userTransactions, this.deleteTxn);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                // it is considered as a container without child here it is
                // used as a spacing between text and image.
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                // fit: BoxFit.cover this will adjust the image dynamics as per
                // its parent since earlier the parent of image widget is a column
                // and column just take all the height, that's why we are getting
                // the out of bounds but now since we wrapped it inside the
                // container and give it some height it is taking the space as
                // per that.
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        // since Transactions is not a widget we have to map the list of
        // transactions to some widget just like earlier,
        // here we map it with card.

        // we cannot use key: ValueKey(userTransactions[index].id) with
        // ListView.builder though because of a bug but we can use it
        // with ListView (children : [])

        // ListView.builder(
        // itemBuilder: (context, index) {
        //   return TransactionItem(
        //       key: ValueKey(userTransactions[index].id),
        //       userTransaction: userTransactions[index],
        //       deleteTxn: deleteTxn);
        // },

        : ListView(
            children: userTransactions
                .map((txn) => TransactionItem(
                    key: ValueKey(txn.id),
                    userTransaction: txn,
                    deleteTxn: deleteTxn))
                .toList(),
          );
  }
}
