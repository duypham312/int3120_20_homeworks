import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Lesson 12'),
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
  final list = [
    {
      'title': 'Anh Đếch Cần Gì Nhiều Ngoài Em',
      'desc': 'Đen, Vũ',
      'coverUrl': 'assets/Anh Dech Can Gi Nhieu Ngoai Em - Den_ Vu.jpg',
    },
    {
      'title': 'Cảm ơn',
      'desc': 'Đen, Biên',
      'coverUrl': 'assets/Cam On - Den_ Bien.jpg',
    },
    {
      'title': 'Cho Tôi Lang Thang',
      'desc': 'Ngọt, Đen',
      'coverUrl': 'assets/Cho Toi Lang Thang - Ngot_ Den.jpg',
    },
    {
      'title': 'Đi Về Nhà',
      'desc': 'Đen, JustaTee',
      'coverUrl': 'assets/Di Ve Nha - Den_ JustaTee.jpg',
    },
    {
      'title': 'Hai Triệu Năm',
      'desc': 'Đen, Biên',
      'coverUrl': 'assets/Hai Trieu Nam - Den_ Bien.jpg',
    },
    {
      'title': 'một triệu like',
      'desc': 'Đen, Thành Đồng',
      'coverUrl': 'assets/Mot Trieu Like - Den_ Thanh Dong.jpg',
    },
    {
      'title': 'Tình Đắng Như Ly Cà Phê',
      'desc': 'Nân, Ngơ',
      'coverUrl': 'assets/Tinh Dang Nhu Ly Ca Phe - Nan_ Ngo.jpg',
    },
    {
      'title': 'Trời hôm nay nhiều mây cực!',
      'desc': 'Đen',
      'coverUrl': 'assets/Troi Hom Nay Nhieu May Cuc_ - Den.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final itemData = list[index];
            final item = Item(itemData['title']!, itemData['desc']!,
                itemData['coverUrl']!, 0);
            return GestureDetector(
              child: ItemBox(
                item: item,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemPage(item: item)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: ScopedModel(
        model: item,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                child: Image.asset(item.coverUrl),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                item.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              item.desc,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ScopedModelDescendant<Item>(builder: (context, child, model) {
                return RatingBox(item: model);
              }),
            )
          ],
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
            padding: const EdgeInsets.only(left: 20),
            child:
                ScopedModelDescendant<Item>(builder: (context, child, model) {
              return RatingBox(item: model);
            }),
          ),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
