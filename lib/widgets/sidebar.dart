import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSidebarItem(Icons.search, ""),
          _buildSidebarItem(Icons.home, ""),
          _buildSidebarItem(Icons.movie, ""),
          _buildSidebarItem(Icons.tv, ""),
          _buildSidebarItem(Icons.sports, ""),
          _buildSidebarItem(Icons.settings, ""),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
