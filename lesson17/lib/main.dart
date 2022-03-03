import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp(
    items: fetchItems(),
  ));
}

List<Item> parseItems(http.Response response) {
  final parsed =
      json.decode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();

  return parsed.map<Item>((json) => Item.fromMap(json)).toList();
}

Future<List<Item>> fetchItems() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.2:8000/data.json'));

  if (response.statusCode == 200) {
    return parseItems(response);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.items}) : super(key: key);

  final Future<List<Item>> items;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INT3120 20',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Item>>(
          future: items,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? MyHomePage(
                    title: 'Lesson 17',
                    items: snapshot.data!,
                  )
                : const Center(child: CircularProgressIndicator());
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.items})
      : super(key: key);

  final String title;

  final List<Item> items;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return ItemBox(
              item: Item(item.title, item.desc, item.coverUrl, 0),
            );
          },
        ),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  const ItemBox({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: item,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(image: AssetImage(item.coverUrl)),
              ),
            ),
            title: Text(item.title),
            subtitle: Text(item.desc),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 80),
              child:
                  ScopedModelDescendant<Item>(builder: (context, child, model) {
                return RatingBox(item: model);
              })),
        ],
      ),
    );
  }
}

class RatingBox extends StatelessWidget {
  const RatingBox({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3, 4, 5]
          .map(
            (i) => IconButton(
              onPressed: () {
                item.setRating(i);
              },
              icon: item.rating >= i
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              color: Colors.amber,
            ),
          )
          .toList(),
    );
  }
}

class Item extends Model {
  final String title;
  final String desc;
  final String coverUrl;
  int rating;

  Item(this.title, this.desc, this.coverUrl, this.rating);

  factory Item.fromMap(Map<String, dynamic> json) {
    return Item(json['title'], json['desc'], json['coverUrl'], 0);
  }

  void setRating(newRating) {
    rating = newRating;
    notifyListeners();
  }
}
