import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/charts.dart';
import './models/transactions.dart';
// ignore_for_file: deprecated_member_use
// ignore_for_file: missing_required_param

void main() {
  // we need WidgetsFlutterBinding.ensureInitialized() otherwise in some devices
  // it may not work
  //WidgetsFlutterBinding.ensureInitialized();

  // it is used to add some specific orientations used to run the app.
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

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

  bool _showChart = false;

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
    // we store MediaQuery.of(context) into a variable to use it often avoiding
    // unneceassry re rendering of the screen.
    final mediaQuery = MediaQuery.of(context);
    // for different UI in portrait and landscape
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    // we are storing AppBar in appBar object because now it has the information
    // about the height(and other info also) of the Appbar widget which we gonna
    // need.

    // here we are using PreferredSizeWidget as name because flutter is not able
    // to get that both AppBar and CupertinoNavigationBar are using same
    // preferredSize property therefore we can have PreferredSizeWidget
    // varaiable.
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // we cannot use IconButton here since IconButton is from
                // material.dart but it cannot be used here in
                // CupertinoNavigationBar therefore we can design our own button
                // using GestureDectector.

                // IconButton(
                //   onPressed: () => _startAddNewTransaction(context),
                //   icon: Icon(Icons.add),
                // ),
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                onPressed: (() => _startAddNewTransaction(context)),
                icon: Icon(Icons.add),
              ),
            ],
          );
    // this is to avoid code rewrite
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    // since we are using two differnt IOS type design and to use the code in
    // different IOS we are storing the app body in a variable.

    // SafeArea is used to avoid OS interface overlapping in our app.
    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // this is new flutter feature to use if statement please note
            // here like this we cannot use {} as it will be taken as list it
            // just takes the below code.
            // also here we need to have switch only for landscape mode so we
            // are rendering it for only landscape

            // if statement here is used to get the requirements as per the
            // orientation.
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart : ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // for different ios.
                  Switch.adaptive(
                      value: _showChart,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                // here we are using MediaQuery to get the device information
                // and getting the height accordingly and using appBar variable
                // we are deducting the height of AppBar widget please note that
                // we are using this for both Chart and TransactionList.

                // preferredSize is used th get the size of the AppBar.

                //  MediaQuery.of(context).padding.top this is also deducted for
                // status bar that comes at the top by default and padding widget
                // get us the additional device padding that flutter provides us.
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.25,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            //Since we want the app to be scrollable we can use SingleChildScrollView
            // but we can also have a ListView widget
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            // we don't have floating button for IOS as per default theme
            // configurations therefore we can also don't take it here/
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: IconButton(
                      onPressed: (() => _startAddNewTransaction(context)),
                      icon: Icon(Icons.add),
                    ),
                  ),
          );
  }
}
