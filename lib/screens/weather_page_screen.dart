import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPageScreen extends StatefulWidget {
  const WeatherPageScreen({super.key});

  @override
  State<WeatherPageScreen> createState() => _WeatherPageScreenState();
}

class _WeatherPageScreenState extends State<WeatherPageScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  String? error;

  double? temperature;
  double? windSpeed;
  String? cityName;

  Future<void> _fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // تحويل اسم المدينة لإحداثيات
      final geoUrl = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1');

      final geoRes = await http.get(geoUrl);
      final geoData = json.decode(geoRes.body);

      if (geoData['results'] == null) {
        throw 'City not found';
      }

      final lat = geoData['results'][0]['latitude'];
      final lon = geoData['results'][0]['longitude'];
      cityName = geoData['results'][0]['name'];

      // جلب الطقس
      final weatherUrl = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');

      final weatherRes = await http.get(weatherUrl);
      final weatherData = json.decode(weatherRes.body);

      setState(() {
        temperature = weatherData['current_weather']['temperature'];
        windSpeed = weatherData['current_weather']['windspeed'];
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

      appBar: AppBar(
        title: const Text("Weather"),
        backgroundColor: const Color(0xFF536D82),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER (GIF)
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE6ED),
              ),
              child:Container(
  height: 220,
  width: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("images/weather_header.gif"),
      fit: BoxFit.cover,
    ),
  ),
  child: Container(
    padding: const EdgeInsets.all(16),
    alignment: Alignment.bottomLeft,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.25),
    ),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Plan your journey with confidence",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Explore the weather of your next destination",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  ),
),
            ),

            const SizedBox(height: 24),

            // SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter city or country",
                  filled: true,
                  fillColor: const Color(0xFFDDE6ED),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: _fetchWeather,
              ),
            ),

            const SizedBox(height: 24),

            // RESULT
            if (isLoading)
              const CircularProgressIndicator(),

            if (error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            if (temperature != null && !isLoading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26374D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        cityName ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "$temperature°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Wind speed: $windSpeed km/h",
                        style: const TextStyle(
                          color: Color(0xFF9DB2BF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}