import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userexpensesapp/widgets/chart.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transactions.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(Userexapp());
}

class Userexapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Expenses',
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [
    // Transaction(id: 'ex1', title: 'New Bag', amount: 20, date: DateTime.now()),
    // Transaction(
    //     id: 'ex2', title: 'Shopping', amount: 100, date: DateTime.now()),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTrans {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTrans(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _transactions.add(newTx);
    });
  }

  void startAddNewTrans(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTrans(_addNewTrans),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
    mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS?
    CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => startAddNewTrans(context),
                ),
              ],
            ),
          )
    :AppBar(
      title: Text('my expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add), onPressed: () => startAddNewTrans(context)),
      ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_recentTrans, _deleteTransaction),
    );


    final pageBody = SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    }),
              ],
            ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTrans),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTrans),
                  )
                : txListWidget
          ],
        ),
      ),
);
      return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
      appBar: appBar,
      body:  pageBody,
 

            // _showChart?
            // Container(
            //     height: (mediaQuery.size.height -
            //             appBar.preferredSize.height -
            //             mediaQuery.padding.top) *
            //         0.7,
            //     child: Chart(_recentTrans),
            //     )
            // : Container(
            //     height: (mediaQuery.size.height -
            //             appBar.preferredSize.height -
            //             mediaQuery.padding.top) *
            //         0.77,
            //     child: TransactionList(_transactions, _deleteTransaction)
            //     ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: 
      Platform.isIOS? Container()
       :
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTrans(context),
      ),
    );
  }
}
