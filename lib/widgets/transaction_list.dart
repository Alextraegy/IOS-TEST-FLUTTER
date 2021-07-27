import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    'there\'s no transactions',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/welcome.png')),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          textColor: Theme.of(context).errorColor,
                          onPressed: () {
                            deleteTx(transactions[index].id);
                          })
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            deleteTx(transactions[index].id);
                          },
                        ),
                ),
              );
              // Card(
              //   child: Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(3),
              //       decoration: BoxDecoration(
              //           border: Border.all(width: 3, color: Theme.of(context).primaryColor)),
              //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //       child: Text(
              //         '\$${transactions[index].amount.toStringAsFixed(2)}',
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: 'Quicksand',
              //             fontSize: 18),
              //       ),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           transactions[index].title,
              //           style: Theme.of(context).textTheme.headline6,
              //         ),
              //         Text(
              //           DateFormat.yMMMd().format(transactions[index].date),
              //           style: TextStyle(
              //               color: Colors.grey,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     )
              //   ],
              // )
              // );
            },
            itemCount: transactions.length,
          );
  }
}
