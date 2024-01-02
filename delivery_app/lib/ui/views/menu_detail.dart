// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:delivery_app/contants/metinler.dart';
import 'package:delivery_app/contants/sayilar.dart';
import 'package:delivery_app/data/entity/menus.dart';
import 'package:delivery_app/ui/cubit/mainpage_cubit.dart';
import 'package:delivery_app/ui/cubit/menu_detail_cubit.dart';
import 'package:delivery_app/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:delivery_app/ui/views/sepet.dart';
import 'package:delivery_app/widgets/fiyat_text_widget.dart';
import 'package:delivery_app/widgets/yemek_adi_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetaySayfa extends StatefulWidget {
  final Yemekler yemek;

  const DetaySayfa({super.key, required this.yemek});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa>
    with SingleTickerProviderStateMixin {
  var favlandi = false;
  var gizlebunu = true;
  var tutucu = Sayilar.bir;

  @override
  void initState() {
    super.initState();
    context.read<DetaySayfaCubit>().degerleriSifirla();
    context
        .read<DetaySayfaCubit>()
        .urunFiyatiniYollaIslemSoyle(int.parse(widget.yemek.yemek_fiyat), 1);
  }

  var favlanmisMi = false;
  final Map<int, AnimationController> _animationControllers = {};
  List<bool> favDurumListesi =
      List.generate(Sayilar.favlanilabilirUzunluk, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(Metinler.urunDetayi,
              style: TextStyle(fontFamily: Metinler.fontAdi)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(
                  Icons.home,
                ))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ))),
      body: BlocBuilder<DetaySayfaCubit, UrunBilgileriCubit>(
          builder: (context, gelenUrunBilgisi) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bosluk35lik(),
              Stack(alignment: Alignment.bottomCenter, children: [
                resimUstuKartDetay(context),
              ]),
              bosluk20(),
              urunFiyatWidgeti(),
              bosluk10(),
              yemekAdiWidget(),
              bosluk10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  adetSecmeCard(context, gelenUrunBilgisi),
                  sepeteEkleButonu(context),
                ],
              ),
              bosluk10(),
              toplamTutarOzelWidget(gelenUrunBilgisi, context),
              Padding(
                padding: const EdgeInsets.only(top: Sayilar.basBosluk),
                child: digerUrunlerimiziIncele(),
              ),
              Expanded(
                child: BlocBuilder<AnasayfaCubit, List<Yemekler>>(
                    builder: (context, liste) {
                  if (liste.isNotEmpty) {
                    return Padding(
                      padding: Sayilar.onbesLik,
                      child: ListView.builder(
                        itemCount: liste.length,
                        itemBuilder: (context, indeks) {
                          if (liste[indeks].yemek_adi ==
                              widget.yemek.yemek_adi) {
                            return const SizedBox.shrink();
                          }
                          return Card(
                            color: Colors.deepPurple[100],
                            child: Padding(
                              padding: Sayilar.defaultPad,
                              child: Column(
                                children: [
                                  YemekAdiWidget(
                                      yemek: liste[indeks],
                                      yaziBuyuklugu: Sayilar.basBosluk),
                                  GestureDetector(
                                    onTap: () {
                                      detaySayfadanBaskaUruneGec(
                                          context, liste, indeks);
                                    },
                                    child: detaySayfaOzelResim(
                                        context, liste, indeks),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
              ),
            ],
          ),
        );
      }),
      //floatingActionButton: sepeteEkleButonu(context),
    );
  }

  Text digerUrunlerimiziIncele() => const Text("Yaninda iyi gider.",
      style: TextStyle(fontFamily: Metinler.fontAdi));

  Text toplamTutarOzelWidget(
      UrunBilgileriCubit gelenUrunBilgisi, BuildContext context) {
    return Text(
      "${Metinler.tutar}₺${gelenUrunBilgisi.toplamFiyat.toString()}",
    );
  }

  SizedBox detaySayfaOzelResim(
      BuildContext context, List<Yemekler> liste, int indeks) {
    return SizedBox(
      height: 150,
      width: 150,
      child: ClipOval(
        child: Image.network(
          '${Metinler.temelResimUrl}${liste[indeks].yemek_resim_adi}',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void detaySayfadanBaskaUruneGec(
      BuildContext context, List<Yemekler> liste, int indeks) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetaySayfa(yemek: liste[indeks]),
        ));
  }

  ElevatedButton sepeteEkleButonu(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: Sayilar.defaultCircular)),
      onPressed: () {
        sepeteEkleOnePressed(context);
      },
      child: Padding(
        padding: EdgeInsets.all(18),
        child: sepeteEkleYazisi(context),
      ),
    );
  }

  //!
  Future<void> sepeteEkleOnePressed(BuildContext context) async {
    if (tutucu == Sayilar.kZeros) {
      print("0 adet girdiniz");
    } else {
      await context.read<DetaySayfaCubit>().sepeteEkle(widget.yemek);
      // ignore: use_build_context_synchronously

      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SepetSayfa(resimAdi: widget.yemek.yemek_resim_adi),
              ))
          .then((value) => context
              .read<SepetSayfaCubit>()
              .sepettekiUrunleriCek("semihakin"));
    }
  }

  Text sepeteEkleYazisi(BuildContext context) {
    return const Text(
      Metinler.sepeteEkle,
      style: TextStyle(color: Colors.white),
    );
  }

  SizedBox bosluk35lik() {
    return const SizedBox(
      height: Sayilar.ozelOtuzBeslik,
    );
  }

  Card adetSecmeCard(
      BuildContext context, UrunBilgileriCubit gelenUrunBilgisi) {
    return Card(
      child: Padding(
        padding: Sayilar.detayCardPad,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
                child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                foregroundColor:
                    MaterialStateProperty.all(Colors.black), // Icon rengi
              ),
              onPressed: () {
                context.read<DetaySayfaCubit>().urunFiyatiniYollaIslemSoyle(
                      int.parse(widget.yemek.yemek_fiyat),
                      Sayilar.kZeros,
                    );
                tutucu = gelenUrunBilgisi.secilenAdetSayisi;
              },
              icon: const Icon(Icons.remove),
            )),
            Padding(
              padding: Sayilar.defaultPad,
              child: Text(
                gelenUrunBilgisi.secilenAdetSayisi.toString(),
                style: const TextStyle(
                    fontFamily: Metinler.fontAdi, fontSize: Sayilar.sized20),
              ),
            ),
            CircleAvatar(
              child: IconButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey[300]),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.black), // Icon rengi
                  ),
                  onPressed: () {
                    context.read<DetaySayfaCubit>().urunFiyatiniYollaIslemSoyle(
                        int.parse(widget.yemek.yemek_fiyat), Sayilar.bir);
                    tutucu = gelenUrunBilgisi.secilenAdetSayisi;
                  },
                  icon: const Icon(Icons.add)),
            ),
          ],
        ),
      ),
    );
  }

  YemekAdiWidget yemekAdiWidget() => YemekAdiWidget(
      yemek: widget.yemek, yaziBuyuklugu: Sayilar.yemekAdiBuyukluguDetay);

  SizedBox bosluk10() {
    return const SizedBox(
      height: Sayilar.sized10,
    );
  }

  SizedBox bosluk20() {
    return const SizedBox(
      height: Sayilar.sized20,
    );
  }

  UrunFiyatWidgeti urunFiyatWidgeti() {
    return UrunFiyatWidgeti(
      yemek: widget.yemek,
      yaziBuyuklugu: Sayilar.detayYaziBuyuklugu,
    );
  }

  Card resimUstuKartDetay(BuildContext context) {
    return Card(
        color: Colors.deepPurple[100],
        child: SizedBox(
            height: 250,
            width: 250,
            child: Center(
              child: ClipOval(
                child: Image.network(
                  '${Metinler.temelResimUrl}${widget.yemek.yemek_resim_adi}',
                  fit: BoxFit.cover,
                ),
              ),
            )));
  }
}
