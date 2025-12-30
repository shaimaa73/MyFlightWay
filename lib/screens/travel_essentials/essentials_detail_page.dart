import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EssentialsDetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> initialItems;
  final String cardId;

  const EssentialsDetailPage({
    super.key,
    required this.title,
    required this.initialItems,
    required this.cardId,
  });

  @override
  State<EssentialsDetailPage> createState() => _EssentialsDetailPageState();
}

class _EssentialsDetailPageState extends State<EssentialsDetailPage> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // تحميل البيانات من Firestore
  Future<void> _loadItems() async {
    items = widget.initialItems
        .map((e) => e is String ? {"text": e, "done": false} : e)
        .toList();

    isLoading = false;
    setState(() {});
  }

  // حفظ التعديلات
  Future<void> _saveItems() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('travel_essentials')
        .doc(widget.cardId)
        .update({"items": items});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved successfully")));
  }

  // إضافة عنصر جديد
  void _addItem() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Add item",
          style: TextStyle(color: Color(0xFF26374D)),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Item name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF536D82),
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26374D),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (controller.text.isEmpty) return;

              setState(() {
                items.add({"text": controller.text, "done": false});
              });

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/skydialog.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // العنوان و زر رجوع
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF26374D),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF26374D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Add New
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InkWell(
                              onTap: _addItem,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF9DB2BF,
                                  ).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Color(0xFF26374D)),
                                    SizedBox(width: 6),
                                    Text(
                                      "Add New",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF26374D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // List
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: items.length + 1,
                              itemBuilder: (context, index) {
                                // زر Save
                                if (index == items.length) {
                                  return InkWell(
                                    onTap: _saveItems,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF26374D),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            "Save changes",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final item = items[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
  value: item["done"],
  activeColor: const Color(0xFF26374D), // لون لما يكون checked
  checkColor: Colors.white,             // لون علامة الصح
  side: const BorderSide(               // لون الإطار لما يكون unchecked
    color: Color(0xFF536D82),
    width: 1.5,
  ),
                                        onChanged: (val) {
                                          setState(() {
                                            item["done"] = val;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          item["text"],
                                         style: TextStyle(
  fontSize: 15,
  color: item["done"]
      ? Colors.grey          // لون لما يكون متعلم 
      : const Color(0xFF26374D), // لون طبيعي
  decoration: item["done"]
      ? TextDecoration.lineThrough
      : null,
),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            items.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
