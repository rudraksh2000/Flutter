// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTxn;

  TransactionList(this.userTransactions, this.deleteTxn);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: userTransactions.isEmpty
          ? Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                // it is considered as a container without child here it is
                // used as a spacing between text and image.
                SizedBox(
                  height: 20,
                ),
                // fit: BoxFit.cover this will adjust the image dynamics as per
                // its parent since earlier the parent of image widget is a column
                // and column just take all the height, that's why we are getting
                // the out of bounds but now since we wrapped it inside the
                // container and give it some height it is taking the space as
                // per that.
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              // since Transactions is not a widget we have to map the list of
              // transactions to some widget just like earlier,
              // here we map it with card.
              itemBuilder: (context, index) {
                return
                    // the given below is one way od getting the transaction
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
                    Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text('\$${userTransactions[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever_outlined),
                      iconSize: 30,
                      color: Theme.of(context).accentColor,
                      // here we are passing the function not as a reference
                      // because we need an argument with also.
                      onPressed: () => deleteTxn(userTransactions[index].id),
                    ),
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
