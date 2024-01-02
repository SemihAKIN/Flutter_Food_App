import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsFunction extends StatefulWidget {
  const GoogleMapsFunction({super.key});

  @override
  State<GoogleMapsFunction> createState() => _GoogleMapsFunctionState();
}

class _GoogleMapsFunctionState extends State<GoogleMapsFunction> {
  Completer<GoogleMapController> haritaKontrol = Completer();
  Marker? userMarker;

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
        print("ERROR" + error.toString());
      },
    );
    return await Geolocator.getCurrentPosition();
  }

  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;

    Position position = await getUserCurrentLocation();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    // Konuma gitmeden önce kullanıcının anlık konumunu işaretleyelim
    if (userMarker != null) {
      // userMarker null değilse, mevcut işaretçiyi güncelle
      userMarker = userMarker!.copyWith(positionParam: currentLocation);
    } else {
      // userMarker null ise, yeni bir işaretçi oluştur
      userMarker = Marker(
        markerId: const MarkerId('user_marker'),
        position: currentLocation,
        infoWindow:
            const InfoWindow(title: 'Konumunuz', snippet: "Anlik Konumunuz"),
      );
    }

    // Kullanıcının konumunu işaretledikten sonra konuma git
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 15),
    ));

    setState(() {}); // State'i güncelleyerek işaretçiyi görüntüle
  }

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında anlık konumu göster
    konumaGit();
  }

  void showSpecificLocation() async {
    GoogleMapController controller = await haritaKontrol.future;
    // Belirli bir konumu haritada işaretle
    userMarker = const Marker(
      markerId: MarkerId('restoran_marker'),
      position: LatLng(39.9032599, 32.5979554),
      infoWindow: InfoWindow(
          title: 'Restoran Konumu', snippet: "Restoran Konum Taksim"),
    );

    // Belirli konuma git
    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(41.0370013, 28.974792),
      zoom: 15,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(target: LatLng(41.0370013, 28.974792), zoom: 15),
    ));

    // setState çağrılarak widget'ın güncellenmesi sağlanır.
    setState(() {
      // Harita üzerindeki değişiklikleri görmek için userMarker'ı güncelliyoruz.
      userMarker = userMarker!.copyWith(
        positionParam: const LatLng(41.0370013, 28.974792),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Restoran Harita",
              style: TextStyle(fontSize: 28),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 400,
                  width: 300,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0.0, 0.0),
                      zoom: 11,
                    ),
                    mapType: MapType.normal,
                    markers: userMarker != null ? {userMarker!} : {},
                    onMapCreated: (GoogleMapController controller) {
                      haritaKontrol.complete(controller);
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: showSpecificLocation,
              child: const Text("Konuma Git"),
            ),
          ],
        ),
      ),
    );
  }
}
