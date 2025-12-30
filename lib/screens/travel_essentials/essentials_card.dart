import 'dart:ui';
import 'package:flutter/material.dart';

class EssentialsCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const EssentialsCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: data["id"], //  للأنيميشن
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // زر الحذف
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          data["onDelete"]
                              ?.call(); // نستدعي الحذف من الصفحة الرئيسية
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF536D82),
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          data["icon"],
                          size: 24,
                          color: const Color(0xFF26374D),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data["title"],
                          maxLines: null, //  يسمح بعدد غير محدود من الأسطر
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF26374D),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "${data["items"].length} items",
                          style: const TextStyle(
                            color: Color(0xFF536D82),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Expanded(
                          child: const Text(
                            "see your items",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A9BA8),
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
