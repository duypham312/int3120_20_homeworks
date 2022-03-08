import 'package:flutter/material.dart';
import 'package:lesson23/expense_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'form.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final expense = ExpenseModel();

  runApp(ScopedModel<ExpenseModel>(model: expense, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INT3120 20',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lesson 23'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ScopedModelDescendant<ExpenseModel>(
          builder: (context, child, model) {
            return ListView.separated(
              itemCount: model.items == null ? 1 : model.items.length + 1,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text(
                      "Total expenses: " + model.totalExpense.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  index = index - 1;
                  return Dismissible(
                    key: Key(model.items[index].id.toString()),
                    onDismissed: (direction) {
                      model.delete(model.items[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Item with id, " +
                              model.items[index].id.toString() +
                              " is dismissed"),
                        ),
                      );
                    },
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormPage(
                              id: model.items[index].id,
                              expense: model,
                            ),
                          ),
                        );
                      },
                      leading: const Icon(Icons.monetization_on),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      title: Text(
                        model.items[index].category +
                            ": " +
                            model.items[index].amount.toString() +
                            " \nspent on " +
                            model.items[index].formattedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: ScopedModelDescendant<ExpenseModel>(
        builder: (context, child, expenses) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScopedModelDescendant<ExpenseModel>(
                    builder: (context, child, expenses) {
                      return FormPage(
                        id: 0,
                        expense: expenses,
                      );
                    },
                  ),
                ),
              );
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
