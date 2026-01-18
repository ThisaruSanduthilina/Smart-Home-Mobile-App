import 'package:flutter/material.dart';
import 'rooms_card_inside.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rooms',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your rooms',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: isLargeScreen ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isLargeScreen ? 1.5 : 1.2,
                  children: [
                    _buildRoomCard(
                      context: context,
                      title: 'Living Room',
                      deviceCount: 6,
                      icon: Icons.weekend_rounded,
                      backgroundImage: 'assets/images/living.jpg',
                    ),
                    _buildRoomCard(
                      context: context,
                      title: 'Bedroom',
                      deviceCount: 4,
                      icon: Icons.bed_rounded,
                      backgroundImage: 'assets/images/bedroom.webp',
                    ),
                    _buildRoomCard(
                      context: context,
                      title: 'Kitchen',
                      deviceCount: 3,
                      icon: Icons.kitchen_rounded,
                      backgroundImage: 'assets/images/kitchen.jpg',
                    ),
                    _buildRoomCard(
                      context: context,
                      title: 'Office',
                      deviceCount: 5,
                      icon: Icons.desk_rounded,
                      backgroundImage: 'assets/images/office.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard({
    required BuildContext context,
    required String title,
    required int deviceCount,
    required IconData icon,
    String? backgroundImage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomCardInside(
              roomName: title,
              roomImage: backgroundImage ?? '',
              deviceCount: deviceCount,
              icon: icon,
            ),
          ),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            if (backgroundImage != null)
              Positioned.fill(
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1C1C1E),
                    );
                  },
                ),
              ),

            // Dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: const Color(0xFF00CC66),
                    size: 32,
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$deviceCount devices',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
