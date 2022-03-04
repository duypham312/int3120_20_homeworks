import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson18/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

Stream<QuerySnapshot> fetchItems() {
  return FirebaseFirestore.instance.collection('item').snapshots();
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
      home: const MyHomePage(
        title: 'Lesson 18',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dataSource = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
                title: const Text('Please select data source'),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.maybePop(context);
                      setState(() {
                        dataSource = 'SQLite';
                      });
                    },
                    child: const Text('SQLite DB'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.maybePop(context);
                      setState(() {
                        dataSource = 'Firestore';
                      });
                    },
                    child: const Text('Firestore'),
                  ),
                ]);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: dataSource == 'SQLite'
          ? FutureBuilder<List<Item>>(
              future: SQLiteDbProvider.db.getItems(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return ItemBox(
                              item: Item(
                                  item.id,
                                  item.title,
                                  '${item.desc}. Source: $dataSource',
                                  item.coverUrl,
                                  0),
                            );
                          },
                        ))
                    : const Center(child: CircularProgressIndicator());
              })
          : (dataSource == 'Firestore')
              ? (StreamBuilder<QuerySnapshot>(
                  stream: fetchItems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs;

                      List<Item> items = [];

                      for (var element in data) {
                        items.add(Item.fromMap(
                            element.data() as Map<dynamic, dynamic>));
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ItemBox(
                              item: Item(
                                  index,
                                  item.title,
                                  '${item.desc}. Source: $dataSource',
                                  item.coverUrl,
                                  0),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ))
              : const Center(child: CircularProgressIndicator()),
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
  final int id;
  final String title;
  final String desc;
  final String coverUrl;
  int rating;

  static final columns = ["id", "title", "desc", "coverUrl", "rating"];

  Item(this.id, this.title, this.desc, this.coverUrl, this.rating);

  factory Item.fromMap(Map<dynamic, dynamic> json) {
    return Item(json['id'], json['title'], json['desc'], json['coverUrl'], 0);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "desc": desc,
        "coverUrl": coverUrl,
        "rating": rating
      };

  void setRating(newRating) {
    rating = newRating;
    notifyListeners();
  }
}
