import 'package:delivery_app/contants/metinler.dart';
import 'package:delivery_app/data/entity/menus.dart';
import 'package:flutter/material.dart';

class UrunFiyatWidgeti extends StatelessWidget {
  const UrunFiyatWidgeti({
    super.key,
    required this.yemek,
    required this.yaziBuyuklugu,
  });

  final Yemekler yemek;
  final double yaziBuyuklugu;

  @override
  Widget build(BuildContext context) {
    return Text("₺${yemek.yemek_fiyat}",
        style: TextStyle(
          fontFamily: Metinler.fontAdi,
          fontSize: yaziBuyuklugu,
        ));
  }
}
