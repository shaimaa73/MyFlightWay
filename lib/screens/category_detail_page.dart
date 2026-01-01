import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const CategoryDetailPage({
    super.key,
    required this.title,
    required this.items,
  });

  // اختيار أيقونة حسب اسم القسم
  IconData _getCategoryIcon() {
    switch (title) {
      case "Food & Drinks":
        return Icons.fastfood;
      case "Medical":
        return Icons.medical_services;
      case "Household & Tools":
        return Icons.home_repair_service;
      case "Sport & Camping":
        return Icons.sports_soccer;
      case "Sharp Objects":
        return Icons.content_cut;
      default:
        return Icons.category;
    }
  }

  // تحديد إذا العنصر مسموح Carry-on / Checked 
  Map<String, bool> _baggageRules(String item) {
    final lower = item.toLowerCase();

    if (lower.contains("liquid") ||
        lower.contains("knife") ||
        lower.contains("scissors") ||
        lower.contains("razor") ||
        lower.contains("tool")) {
      return {"carryOn": false, "checked": true};
    }

    if (lower.contains("medicine") ||
        lower.contains("medical") ||
        lower.contains("passport")) {
      return {"carryOn": true, "checked": true};
    }

    return {"carryOn": true, "checked": true};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6ED),
      body: Column(
        children: [
          // HEADER
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF536D82),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getCategoryIcon(),
                            size: 56, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Check what you can bring with you",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // TABLE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _tableHeader(),
                const SizedBox(height: 8),

                ...items.map((item) {
                  final rules = _baggageRules(item);
                  return _tableRow(
                    item,
                    carryOn: rules["carryOn"]!,
                    checked: rules["checked"]!,
                  );
                }),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TABLE HEADER
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF26374D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              "Item",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text("Carry-on", style: TextStyle(color: Colors.white)),
          SizedBox(width: 24),
          Text("Checked", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  //TABLE ROW
  Widget _tableRow(
    String name, {
    required bool carryOn,
    required bool checked,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF26374D),
              ),
            ),
          ),
          Icon(
            carryOn ? Icons.check_circle : Icons.cancel,
            color: carryOn
                ? const Color(0xFF26374D)
                : const Color(0xFF8B2E2E),
          ),
          const SizedBox(width: 24),
          Icon(
            checked ? Icons.check_circle : Icons.cancel,
            color: checked
                ? const Color(0xFF26374D)
                : const Color(0xFF8B2E2E),
          ),
        ],
      ),
    );
  }
}