import 'package:delivery_app/contants/metinler.dart';
import 'package:delivery_app/data/entity/menus.dart';
import 'package:flutter/material.dart';

class YemekAdiWidget extends StatelessWidget {
  const YemekAdiWidget(
      {super.key, required this.yemek, required this.yaziBuyuklugu});

  final Yemekler yemek;
  final double yaziBuyuklugu;

  @override
  Widget build(BuildContext context) {
    return Text(
      yemek.yemek_adi,
      style: TextStyle(
        fontSize: yaziBuyuklugu,
        fontFamily: Metinler.fontAdi,
      ),
    );
  }
}
