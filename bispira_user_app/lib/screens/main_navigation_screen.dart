import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/curved_nav_bar.dart';
import 'home_screen.dart';
import 'ride_screen.dart';
import 'food_screen.dart';
import 'send_screen.dart';
import 'health_screen.dart';
import 'expert_screen.dart';
import 'kost_screen.dart';
import 'donation_screen.dart';
import 'evoting_screen.dart';
import 'mart_screen.dart';
import 'tax_screen.dart';
import 'tickets_screen.dart';
import 'profile_screen.dart';
import 'eo_screen.dart';
import 'apotek_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String? _activeSubService;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
      _activeSubService = null;
    });
  }

  void _openService(String serviceKey) {
    setState(() => _activeSubService = serviceKey);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_activeSubService == 'ride') {
      bodyContent = RideScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'food') {
      bodyContent = FoodScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'send') {
      bodyContent = SendScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'health') {
      bodyContent = HealthScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'jasa' || _activeSubService == 'expert') {
      bodyContent = ExpertScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'tickets') {
      bodyContent = TicketsScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'kost') {
      bodyContent = KostScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'donation' || _activeSubService == 'donasi') {
      bodyContent = DonationScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'vote' || _activeSubService == 'evoting' || _activeSubService == 'evoting_cabang' || _activeSubService == 'evoting_pusat') {
      bodyContent = EVotingScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'eo' || _activeSubService == 'eo_cabang') {
      bodyContent = EOScreen(onBackPressed: () => setState(() => _activeSubService = null), initialIsPusat: false);
    } else if (_activeSubService == 'eo_pusat') {
      bodyContent = EOScreen(onBackPressed: () => setState(() => _activeSubService = null), initialIsPusat: true);
    } else if (_activeSubService == 'tax' || _activeSubService == 'pajak') {
      bodyContent = TaxScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'mart' || _activeSubService == 'belanja') {
      bodyContent = MartScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else if (_activeSubService == 'apotek' || _activeSubService == 'pharmacy') {
      bodyContent = ApotekScreen(onBackPressed: () => setState(() => _activeSubService = null));
    } else {
      switch (_currentIndex) {
        case 0:
          bodyContent = HomeScreen(onNavigateTab: _navigateToTab, onOpenService: _openService);
          break;
        case 1:
          bodyContent = const TicketsScreen();
          break;
        case 2:
          bodyContent = const EVotingScreen();
          break;
        case 3:
          bodyContent = const ProfileScreen();
          break;
        default:
          bodyContent = HomeScreen(onNavigateTab: _navigateToTab, onOpenService: _openService);
      }
    }

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: bodyContent,
      extendBody: true,
      bottomNavigationBar: AnimatedCurvedNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _activeSubService = null;
          });
        },
        items: [
          CurvedNavItem(emoji: '🏠', label: 'Home'),
          CurvedNavItem(emoji: '📜', label: 'Activity'),
          CurvedNavItem(emoji: '🗳️', label: 'Voting'),
          CurvedNavItem(emoji: '👑', label: 'Profile'),
        ],
      ),
    );
  }
}
