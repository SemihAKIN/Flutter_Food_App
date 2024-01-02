import 'package:delivery_app/data/entity/menus.dart';
import 'package:delivery_app/data/repo/menudao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UrunBilgileriCubit {
  int secilenAdetSayisi;
  int toplamFiyat;

  UrunBilgileriCubit(
      {required this.secilenAdetSayisi, required this.toplamFiyat});
}

class DetaySayfaCubit extends Cubit<UrunBilgileriCubit> {
  DetaySayfaCubit()
      : super(UrunBilgileriCubit(secilenAdetSayisi: 0, toplamFiyat: 0));

  var repo = YemeklerDaoRepository();

  int urunFiyat = 0;

  //var email = AuthService.getSavedEmail();

  Future<void> sepeteEkle(Yemekler yemek) async {
    //var kullaniciAdi = "$email";
    if (state.secilenAdetSayisi == 0) {
      print("0 adet satin alinmamis demektir");
    } else {
      for (var i = 0; i < state.secilenAdetSayisi; i++) {
        await repo.sepeteYemekEkle(
            yemek: yemek,
            kullaniciAdi: "semihakin",
            adet: 1,
            yemek_resim_adi: yemek.yemek_resim_adi,
            yemek_adi: yemek.yemek_adi,
            yemek_fiyat: int.parse(yemek.yemek_fiyat));
      }
    }
  }

  void urunFiyatiniYollaIslemSoyle(int urunFiyati, int islem) {
    if (islem == 1) {
      print("arttir seçildi");
      urunFiyat = urunFiyati;
      arttir();
    } else {
      print("azalt seçildi");
      urunFiyat = urunFiyati;
      azalt();
    }
    urunFiyati = urunFiyati;
  }

  void degerleriSifirla() {
    state.toplamFiyat = 0;
    state.secilenAdetSayisi = 0;
  }

  void arttir() {
    state.secilenAdetSayisi += 1;
    state.toplamFiyat = state.secilenAdetSayisi * urunFiyat;

    emit(UrunBilgileriCubit(
        secilenAdetSayisi: state.secilenAdetSayisi,
        toplamFiyat: state.toplamFiyat));
  }

  void azalt() {
    if (state.secilenAdetSayisi <= 0) {
      print("adet 0'dan kucuk olamaz");
    } else {
      state.secilenAdetSayisi -= 1;
      state.toplamFiyat = state.secilenAdetSayisi * urunFiyat;
      emit(UrunBilgileriCubit(
          secilenAdetSayisi: state.secilenAdetSayisi,
          toplamFiyat: state.toplamFiyat));
    }
  }
}
