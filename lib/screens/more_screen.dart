import 'package:flutter/material.dart';
import 'package:pennywise/screens/auth_screen.dart';
import 'package:pennywise/services/auth_service.dart';
import 'package:pennywise/services/backup_service.dart';
import '../widgets/base_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BackupService _backupService = BackupService();
  final AuthService _authService = AuthService();
  bool _isBackingUp = false;

  Future<void> _handleBackup() async {
    setState(() {
      _isBackingUp = true;
    });

    try {
      await _backupService.backupToFirebase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Backup completed!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Backup failed: $e")),
      );
    } finally {
      setState(() {
        _isBackingUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    return BaseScreen(
      currentIndex: 3,
      title: 'Settings',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user == null)
                    Container(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Sign In"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuthScreen()),
                          ).then((_) => setState(() {})); // Refresh after returning
                        },
                      ),
                    ),
                    
              
              if (user != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    Column(
                  children: [
                    Text("Hello, ${user.displayName ?? user.email}",
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _authService.signOut();
                        setState(() {}); // Refresh UI
                      },
                      child: Text("Sign Out"),
                    ),
                  ],
                ),
                Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: _isBackingUp
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.cloud_upload, color: Colors.white),
                  onPressed: _isBackingUp ? null : _handleBackup,
                ),
              )
                ],
              )
                ,
              const SizedBox(height: 20),
              _buildGridItems(context),
              const SizedBox(height: 20),
              _buildViewsSection(),
              const SizedBox(height: 20),
              _buildSettingsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, user) {
    return Text("Hello");
  }

  Widget _buildGridItems(BuildContext context) {
    return Container(
      // Ensuring grid items have proper constraints
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.0, // Adjusted for smaller grid items
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
              Navigator.pushNamed(context, '/debug');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8), // Add padding to prevent cramped content
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
    return GestureDetector(
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
