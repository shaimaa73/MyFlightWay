import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; 
import 'login_page.dart';
import 'profile_page.dart';
import '../screens/notification_page.dart';

class SettingsPageScreen extends StatefulWidget {
  const SettingsPageScreen({super.key});

  @override
  State<SettingsPageScreen> createState() => _SettingsPageScreenState();
}

class _SettingsPageScreenState extends State<SettingsPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF26374D),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  // _CustomListTile(
                  //   title: "Dark Mode",
                  //   icon: Icons.dark_mode_outlined,
                  //   trailing: ValueListenableBuilder<bool>(
                  //     valueListenable: isDarkMode,
                  //     builder: (context, isDark, _) {
                  //       return Switch(
                  //         value: isDark,
                  //         onChanged: (value) {
                  //           isDarkMode.value = value;
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                  _CustomListTile(
  title: "Notifications",
  icon: Icons.notifications_none_rounded,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TripsNotificationPage(),
      ),
    );
  },
),
                ],
              ),

              const Divider(),

              _SingleSection(
                title: "Organization",
                children: [
                  _CustomListTile(
                    title: "Profile",
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePageScreen(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Calendar",
                    icon: Icons.calendar_today_rounded,
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF26374D),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              const Divider(),

              _SingleSection(
                children: [
                  _CustomListTile(
                    title: "About",
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "About MyFlightWay",
                            style: TextStyle(
                              color: Color(0xFF26374D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "MyFlightWay is a mobile application created to help travelers during their airport journey by offering useful guidance and smart reminders.\n\nThis app makes traveling easier and more organized, especially for first-time flyers.",
                            style: TextStyle(
                              color: Color(0xFF536D82),
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Close",
                                style: TextStyle(
                                  color: Color(0xFF26374D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Sign out",
                    icon: Icons.exit_to_app_rounded,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF26374D)),
      ),
      leading: Icon(icon, color: const Color(0xFF536D82)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26374D),
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}