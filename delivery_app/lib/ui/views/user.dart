import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  late PageController _pageController;
  int indirim = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChange);
  }

  void _onPageChange() {
    setState(() {
      indirim = (_pageController.page ?? 0).toInt() * 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İndirimler"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Container(
                    color: Colors.deepPurple[300],
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'İndirim: $indirim%',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text("Kartları Kaydırın"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
