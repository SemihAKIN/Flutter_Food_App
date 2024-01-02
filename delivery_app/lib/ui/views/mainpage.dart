import 'package:delivery_app/data/entity/menus.dart';
import 'package:delivery_app/ui/cubit/mainpage_cubit.dart';
import 'package:delivery_app/ui/views/Map.dart';
import 'package:delivery_app/ui/views/menu_detail.dart';
import 'package:delivery_app/ui/views/sepet.dart';
import 'package:delivery_app/ui/views/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        backgroundColor: Colors.deepPurple[500],
        actions: const [
          Icon(
            Icons.home,
            size: 45,
            color: Colors.black,
          )
        ],
        title: const Text("Yemekler"),
      ),
      body: BlocBuilder<AnasayfaCubit, List<Yemekler>>(
        builder: (context, menusList) {
          if (menusList.isNotEmpty) {
            return GridView.builder(
              itemCount: menusList.length, //6
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1 / 1.8),
              itemBuilder: (context, indeks) {
                //0,1,2,3,4,5
                var menu = menusList[indeks];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetaySayfa(
                                  yemek: menu,
                                )));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.network(
                              "http://kasimadalan.pe.hu/yemekler/resimler/${menu.yemek_resim_adi}"),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer_sharp),
                            Text("15 dk teslimat suresi"),
                          ],
                        ),
                        Text(menu.yemek_adi),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${menu.yemek_fiyat} ₺",
                              style: const TextStyle(fontSize: 24),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepPurple),
                              ),
                              onPressed: () {
                                print("${menu.yemek_adi} sepete eklendi");
                              },
                              child: const Text(
                                "Sepet",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Yemek Yok"));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: Row(
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.home),
              ),
              const Spacer(),
              IconButton(
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GoogleMapsFunction()));
                },
                icon: const Icon(Icons.info_outline_rounded),
              ),
              const Spacer(),
              IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserName()));
                  });
                },
                icon: const Icon(Icons.person),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SepetSayfa()));
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
