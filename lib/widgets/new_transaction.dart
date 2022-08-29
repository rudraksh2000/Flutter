import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_addtxn_button.dart';
import './adaptive_date_flat_button.dart';

// ignore_for_file: deprecated_member_use
class NewTransaction extends StatefulWidget {
  final Function addNewTxnHandler;

  NewTransaction(this.addNewTxnHandler);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // please note we are using theses variables inside the State class not in
  // NewTransaction class since we are not giving permanant values to these
  // parameters.
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _txnSubmission() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addNewTxnHandler(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    // here it is used to close the modal sheet after pressing add transaction
    // button.
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((datePicker) {
      if (datePicker == null) {
        return;
      }
      setState(() {
        _selectedDate = datePicker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView is used here so that we can scroll our modal sheet
    // without ristricting the pixel boundary.
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              // here it allows to detect that whether it ristrict the
              // keyboard and adjust accordingly.
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                // we have to pass a value here since the value is not needed it
                // is just a dummy value we can use _ to remember or using a
                // nomenclature for that. Also note that since we are calling a
                // function inside a function we are passing the function () not
                // just a reference i.e without ().
                onSubmitted: (_) => _txnSubmission(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _txnSubmission(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    // so that text widget can take as much space as it can have.
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Dates Chosen!'
                            : 'Picked Date : ${DateFormat().add_yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveDateFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              AdaptiveAddTxnButton('Add Transaction', _txnSubmission),
            ],
          ),
        ),
      ),
    );
  }
}
