// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app/contants/metinler.dart';
import 'package:delivery_app/contants/sayilar.dart';
import 'package:delivery_app/data/entity/fav_urun.dart';
import 'package:delivery_app/data/entity/menus.dart';
import 'package:delivery_app/ui/cubit/favories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class FavSayfa extends StatefulWidget {
  List<Yemekler> favlananUrunler = [];

  FavSayfa({
    Key? key,
  }) : super(key: key);

  @override
  State<FavSayfa> createState() => _FavSayfaState();
}

class _FavSayfaState extends State<FavSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<FavSayfaCubit>().urunleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Metinler.favorilerim,
            style: TextStyle(fontFamily: Metinler.fontAdi)),
      ),
      body: BlocBuilder<FavSayfaCubit, List<FavlananUrun>>(
          builder: (context, favlananUrunlerListesi) {
        if (favlananUrunlerListesi.isNotEmpty) {
          return ListView.builder(
            itemCount: favlananUrunlerListesi.length,
            itemBuilder: (context, indeks) {
              var urun = favlananUrunlerListesi[indeks];
              return Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: favUrunResmi(urun),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: Sayilar.beslikPad,
                        child: Text(urun.urun_adi,
                            style: const TextStyle(
                                fontFamily: Metinler.fontAdi,
                                fontSize: Sayilar.sized20)),
                      ),
                      Text(
                        "${Metinler.fiyatT}${urun.urun_fiyati}",
                        style: const TextStyle(
                            fontFamily: Metinler.fontAdi,
                            fontSize: Sayilar.onaltim),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        try {
                          context.read<FavSayfaCubit>().sqliteSil(urun.urun_id);
                        } catch (e) {
                          print("$e");
                        }
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ));
            },
          );
        } else {
          return const Center(child: Text("Fav Urun Yok"));
        }
      }),
    );
  }

  ClipOval favUrunResmi(FavlananUrun urun) {
    return ClipOval(
        child: Image.network(
      "${Metinler.temelResimUrl}${urun.urun_resim_adi}",
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          // Resim yüklendiğinde
          return child;
        } else {
          // Resim henüz yüklenmediğinde
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
