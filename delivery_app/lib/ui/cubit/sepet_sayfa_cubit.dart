// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app/data/entity/depet.dart';
import 'package:delivery_app/data/repo/menudao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SepetSayfaCubit extends Cubit<List<Sepet>> {
  SepetSayfaCubit() : super(<Sepet>[]);

  var repo = YemeklerDaoRepository();

  Future<void> sepettekiUrunleriCek(String kullaniciAdi) async {
    try {
      var sepetListesi = await repo.sepettekiUrunleriCek(kullaniciAdi);
      if (sepetListesi.isNotEmpty) {
        emit(sepetListesi);
      } else {
        print("Sepet boş geldi");
        emit([]);
      }
    } catch (e) {
      print("Hata oluştu: $e");
      print("Sepet boş geldi");
      emit([]);
    }
  }

  Future<bool> sepetUrunSil(int sepetYemekId, String kullaniciAdi) async {
    try {
      await repo.sepetUrunSil(sepetYemekId, kullaniciAdi);
      await sepettekiUrunleriCek(kullaniciAdi);
      return true;
    } catch (e) {
      print("Hata oluştu: $e");
      return false;
    }
  }
}
