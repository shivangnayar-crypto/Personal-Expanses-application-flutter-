import 'package:flutter/material.dart';
import 'package:realtimeapp/chart_bar.dart';
import 'package:realtimeapp/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTranscations;
  Chart(this.recentTranscations);
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTranscations.length; i++) {
        if (recentTranscations[i].date.day == weekDay.day &&
            recentTranscations[i].date.month == weekDay.month &&
            recentTranscations[i].date.year == weekDay.year) {
          totalSum += recentTranscations[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupedTransactionValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              data['day']?.toString() ?? '',
              (data['amount'] as double),
              totalSpending == 0.0
                  ? 0.0
                  : (data['amount'] as double) / totalSpending,
            ),
          );
        }).toList(),
      ),
    );
  }
}
