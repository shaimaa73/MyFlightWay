import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailPage extends StatelessWidget {
  final Map<String, dynamic> countryData;

  const CountryDetailPage({super.key, required this.countryData});

  @override
  Widget build(BuildContext context) {
    final name = countryData["name"]["common"];
    final nativeName =
        countryData["name"]["nativeName"]?.values.first["common"] ?? "N/A";
    final population = countryData["population"];
    final region = countryData["region"];
    final subRegion = countryData["subregion"] ?? "N/A";
    final capital =
        countryData["capital"] != null ? countryData["capital"][0] : "N/A";
    final tld =
        countryData["tld"] != null ? countryData["tld"][0] : "N/A";

    final currencies = countryData["currencies"] != null
        ? countryData["currencies"].values
            .map((c) => c["name"])
            .join(", ")
        : "N/A";

    final languages = countryData["languages"] != null
        ? countryData["languages"].values.join(", ")
        : "N/A";

    final latlng = countryData["latlng"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(color: Color(0xFF26374D)),
        ),
        backgroundColor: const Color(0xFFDDE6ED),
        iconTheme: const IconThemeData(color: Color(0xFF26374D)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _info("Native Name", nativeName),
              _info("Population", population.toString()),
              _info("Region", region),
              _info("Sub Region", subRegion),
              _info("Capital", capital),
              _info("Top Level Domain", tld),
              _info("Currencies", currencies),
              _info("Languages", languages),
              const SizedBox(height: 20),

              // Google Maps
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26374D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    final url =
                        "https://www.google.com/maps/search/?api=1&query=${latlng[0]},${latlng[1]}";
                    launchUrl(Uri.parse(url));
                  },
                  icon: const Icon(Icons.location_on, color: Colors.white),
                  label: const Text(
                    "Point at Map (Google)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF536D82),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF26374D),
            ),
          ),
        ],
      ),
    );
  }
}