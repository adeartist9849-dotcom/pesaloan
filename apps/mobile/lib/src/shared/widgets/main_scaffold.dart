import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  
  const MainScaffold({super.key, required this.child});
  
  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;
  
  static const List<_NavigationItem> _navItems = [
    _NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    _NavigationItem(
      icon: Icons.credit_card_outlined,
      activeIcon: Icons.credit_card,
      label: 'Loans',
      route: '/loans/history',
    ),
    _NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];
  
  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    context.go(_navItems[index].route);
  }
  
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    _currentIndex = _navItems.indexWhere((item) => location.startsWith(item.route));
    if (_currentIndex == -1) _currentIndex = 0;
    
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: _navItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  
  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}