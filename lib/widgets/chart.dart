import 'package:flutter/material.dart';
import 'package:userexpensesapp/models/transaction.dart';
import 'package:userexpensesapp/widgets/chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recTransactions;
  Chart(this.recTransactions);

  List<Map<String, Object>> get gpTransactionVals {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double tSum = 0.0;

      for (var i = 0; i < recTransactions.length; i++) {
        if (recTransactions[i].date.day == weekday.day &&
            recTransactions[i].date.month == weekday.month &&
            recTransactions[i].date.year == weekday.year) {
          tSum += recTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': tSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return gpTransactionVals.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(gpTransactionVals);
    return Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: gpTransactionVals.map((data) {
              return Flexible(
                fit: FlexFit.tight ,
                child: ChartBar(
                data['day'],
                data['amount'],
                maxSpending == 0.0 ? 0.0 :  (data['amount'] as double) / maxSpending),
              );
            }).toList(),
          ),
        ),
        elevation: 6,
    );
  }
}
