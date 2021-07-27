import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_flat_button.dart';

class NewTrans extends StatefulWidget {
  final Function newTxn;
  NewTrans(this.newTxn);

  @override
  _NewTransState createState() => _NewTransState();
}

class _NewTransState extends State<NewTrans> {
  final _txtController = TextEditingController();
  DateTime _selectedDate;
  final _amountController = TextEditingController();

  void _sumbitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _txtController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.newTxn(
      enteredTitle,
     enteredAmount,
     _selectedDate
     );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Card(
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _txtController,
                    onSubmitted: (_) => _sumbitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _sumbitData(),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen!'
                                : 'PickedDate: ${DateFormat.yMd().format(_selectedDate)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(width: double.infinity),
                        ),
                        Expanded(
                          flex: 5,
                          child: AdaptiveFlatButton('Choose Date', _presentDatePicker)
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      _sumbitData();
                    },
                    child: Text(
                      'Add Transaction',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
