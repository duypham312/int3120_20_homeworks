import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Animation<double>? animation;

  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller!);
    controller!.forward();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller!.forward();
    return MaterialApp(
      title: 'INT3120 20',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lesson 13', animation: animation),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.animation})
      : super(key: key);

  final String title;

  final Animation<double>? animation;

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
      body: FadeTransition(
        opacity: widget.animation!,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: AssetImage(list[index]['coverUrl']!)),
                      ),
                    ),
                    title: Text(list[index]['title']!),
                    subtitle: Text(list[index]['desc']!),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 80),
                    child: RatingBox(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({Key? key}) : super(key: key);

  @override
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3, 4, 5]
          .map(
            (i) => IconButton(
              onPressed: () {
                setState(() {
                  _rating = i;
                });
              },
              icon: _rating >= i
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              color: Colors.amber,
            ),
          )
          .toList(),
    );
  }
}
