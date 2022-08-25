import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/charts.dart';
import './models/transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 59.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New Shirt',
    //   amount: 39.99,
    //   date: DateTime.now(),
    // )
  ];

  List<Transaction> get _recentTransactions {
    // txn is used to get every element in the list of transactions.
    // Also where returns a iterable but since we need a list we use toList().
    return _userTransactions.where((txn) {
      return txn.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String txnTitle, double txnAmount, DateTime txnDate) {
    final newTxn = Transaction(
      id: DateTime.now().toString(),
      title: txnTitle,
      amount: txnAmount,
      date: txnDate,
    );
    setState(() {
      _userTransactions.add(newTxn);
    });
  }

  void _startAddNewTransaction(BuildContext bContext) {
    showModalBottomSheet(
      context: bContext,
      builder: ((_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction),
          // this is done to avoid closing the Modal Sheet when tapped on it.
          behavior: HitTestBehavior.opaque,
        );
      }),
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((txn) => txn.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses'),
        actions: [
          IconButton(
            onPressed: (() => _startAddNewTransaction(context)),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      //Since we want the app to be scrollable we can use SingleChildScrollView
      // but we can also have a ListView widget
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // ignore: missing_required_param
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          onPressed: (() => _startAddNewTransaction(context)),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
