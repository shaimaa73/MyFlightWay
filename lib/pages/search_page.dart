import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/country_detail_page.dart';

class SearchPageScreen extends StatefulWidget {
  final bool autoFocus; // هل نفعل السيرش مباشرة؟

  const SearchPageScreen({super.key, this.autoFocus = false});

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? countryData;
  bool isLoading = false;
  String? error;
  final FocusNode _searchFocusNode = FocusNode();

@override
void initState() {
  super.initState();

  if (widget.autoFocus) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _searchFocusNode.requestFocus(); // يفتح الكيبورد ويحدد السيرش
    });
  }
}

  Future<void> _searchCountry() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      error = null;
      countryData = null;
    });

    try {
      final url =
          Uri.parse('https://restcountries.com/v3.1/name/$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          countryData = data.first;
        });
      } else {
        setState(() {
          error = "Country not found";
        });
      }
    } catch (e) {
      setState(() {
        error = "Something went wrong. Please try again.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        // Header Image 
        ClipPath(
          clipper: BottomCurveClipper(),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/searchheader.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: const Text(
                "Search Country",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Page Content 
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _searchFocusNode,
                  textInputAction: TextInputAction.search,
                 onSubmitted: (_) {
  FocusScope.of(context).unfocus(); // يسكر الكيبورد
  _searchCountry();
},
                  decoration: InputDecoration(
                    hintText: "Search for a country",
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFF536D82)),
                    filled: true,
                    fillColor: const Color(0xFFDDE6ED),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (isLoading)
                  const CircularProgressIndicator(
                      color: Color(0xFF26374D)),

                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (countryData != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: _countryCard(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _countryCard() {
    final name = countryData!["name"]["common"];
    final capital =
        (countryData!["capital"] != null && countryData!["capital"].isNotEmpty)
            ? countryData!["capital"][0]
            : "N/A";
    final population = countryData!["population"];
    final region = countryData!["region"];
    final flag = countryData!["flags"]["png"];

    return InkWell(
  borderRadius: BorderRadius.circular(18),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CountryDetailPage(countryData: countryData!),
      ),
    );
  },
  child: Container(
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Center(
    child: Image.network(
      flag,
      height: 80,
    ),
  ),
  const SizedBox(height: 16),
  Text(
    name,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFF26374D),
    ),
  ),
  const SizedBox(height: 8),
  _infoRow("Capital", capital),
  _infoRow("Region", region),
  _infoRow("Population", population.toString()),
],
    ),
  ),
);
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF536D82),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF26374D)),
            ),
          ),
        ],
      ),
    );
  }
}
//  مسؤول عن عمل الانحناء من الأسفل
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // بداية من الزاوية العلوية اليسار
    path.lineTo(0, size.height - 40);

    // منحنى  بالمنتصف
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 40,
    );

    // إغلاق الشكل
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}