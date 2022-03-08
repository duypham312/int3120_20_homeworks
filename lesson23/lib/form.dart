import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'expense.dart';
import 'expense_model.dart';

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
    required this.id,
    required this.expense,
  }) : super(key: key);

  final int id;
  final ExpenseModel expense;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _category = '';

  final dateController = TextEditingController();

  getInitDate() {
    return widget.id == 0 ? '' : widget.expense.find(widget.id)?.formattedDate;
  }

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (widget.id == 0) {
        widget.expense.add(Expense(0, _amount, _date, _category));
      } else {
        widget.expense.update(Expense(widget.id, _amount, _date, _category));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    dateController.text = getInitDate();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Enter expense details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                validator: (val) {
                  Pattern pattern = r'^[1-9]\d*(\.\d+)?$';
                  RegExp regex = RegExp(pattern.toString());
                  if (!regex.hasMatch(val!)) {
                    return 'Enter a valid number';
                  } else {
                    return null;
                  }
                },
                initialValue: widget.id == 0
                    ? ''
                    : widget.expense.find(widget.id)!.amount.toString(),
                onSaved: (val) => _amount = double.parse(val!),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              TextFormField(
                controller: dateController,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Enter date',
                  labelText: 'Date',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                onSaved: (val) => _date = DateTime.parse(val!),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  dateController.text = DateFormat('yyyy-MM-dd').format(date!);
                },
              ),
              TextFormField(
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  icon: Icon(Icons.category),
                  labelText: 'Category',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                onSaved: (val) => _category = val!,
                initialValue: widget.id == 0
                    ? ''
                    : widget.expense.find(widget.id)?.category.toString(),
              ),
              TextButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
