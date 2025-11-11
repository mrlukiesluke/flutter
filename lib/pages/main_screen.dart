import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/pages/history_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/language_switcher.dart';
import 'package:flutter_application_1/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const MainScreen({super.key, required this.onLocaleChange});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Navigation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          MyHomePage(title: "Home", onNavigate: _onNavTapped),
          ProfilePage(),
          HistoryPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: local.home),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: local.profile,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: local.history,
          ),
        ],
      ),
    );
  }
}
