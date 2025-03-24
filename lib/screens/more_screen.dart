import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 3,
      title: 'Settings',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildGridItems(context),
            const SizedBox(height: 20),
            _buildViewsSection(),
            const SizedBox(height: 20),
            _buildSettingsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guest User',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.security, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItems(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: [
        _buildGridItem(
          icon: Icons.list,
          title: 'Transactions',
          color: Colors.grey[800]!,
          onTap: () {
            Navigator.pushNamed(context, '/all_expenses');
          },
        ),
        _buildGridItem(
          icon: Icons.calendar_today,
          title: 'Scheduled Txns',
          color: Colors.pink[800]!,
          onTap: () {
            Navigator.pushNamed(context, '/all_accounts');
          },
        ),
        _buildGridItem(
          icon: Icons.category,
          title: 'Categories',
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/all_categories');
          },
        ),
        _buildGridItem(
          icon: Icons.tag,
          title: 'Tags',
          color: const Color.fromARGB(255, 109, 99, 99),
          onTap: () {
            print('Tags tapped!');
          },
        ),
      ],
    );
  }

  Widget _buildGridItem(
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap, // Call the onTap function passed as a parameter
      borderRadius:
          BorderRadius.circular(10), // Optional, for a custom splash radius
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildViewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Views', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: _buildViewButton(
                    icon: Icons.calendar_view_day, title: 'Day')),
            const SizedBox(width: 10),
            Expanded(
                child: _buildViewButton(
                    icon: Icons.calendar_month, title: 'Calendar')),
            const SizedBox(width: 10),
            Expanded(
                child: _buildViewButton(icon: Icons.tune, title: 'Custom')),
          ],
        ),
      ],
    );
  }

  Widget _buildViewButton({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return InkWell(
      onTap: () {},
      child: const Row(
        children: [
          Icon(Icons.settings, color: Colors.grey),
          SizedBox(width: 10),
          Text('Settings', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
