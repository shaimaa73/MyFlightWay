import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({super.key});

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  LatLng? userLocation;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // جلب موقع اليوزر 
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission denied forever';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //  AppBar 
      appBar: AppBar(
  title: const Text(
    "My Location",
    style: TextStyle(color: Colors.white),
  ),
  backgroundColor: const Color(0xFF536D82),
  foregroundColor: Colors.white, // عشان لون زر الرجوع
),

      body: Column(
        children: [
          //  Header Image 
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/map_header.jpg"), 
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              color: Colors.black.withOpacity(0.1),
              child: const Text(
                "Track your flight route live",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  shadows:  [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black, // Color of the shadow
        offset: Offset(5, 5), // Displacement of the shadow (x, y)
      ),
    ],
                ),
              ),
            ),
          ),

          //  Map Section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: userLocation!,
                          initialZoom: 13,
                        ),
                        children: [
                          // خريطة OpenStreetMap 
                         TileLayer(
  urlTemplate:
      'https://api.maptiler.com/maps/base-v4/256/{z}/{x}/{y}.png?key=aC5ROT3gyok46yJBfyzl',
  userAgentPackageName: 'com.example.myflightway',
),

                          // مؤشر موقع اليوزر
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: userLocation!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}