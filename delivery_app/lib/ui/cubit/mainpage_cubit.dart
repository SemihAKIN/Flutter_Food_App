import 'package:delivery_app/data/entity/menus.dart';
import 'package:delivery_app/data/repo/menudao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnasayfaCubit extends Cubit<List<Yemekler>> {
  AnasayfaCubit() : super([]);
  var repo = YemeklerDaoRepository();

  Future<void> yemekleriYukle() async {
    var liste = await repo.yemekleriYukle();
    emit(liste);
  }
}
