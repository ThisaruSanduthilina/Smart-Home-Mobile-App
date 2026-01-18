import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'power_control_page.dart';
import 'curtain_control_page.dart';
import 'light_control_page.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final FirebaseService _firebaseService = FirebaseService();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/images/RiseLogo.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 20,
                    );
                  },
                ),
              ),
              Text(
                '9:41',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/RiseLogo.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 20,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Quick Control Cards at top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Controls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickControlCard(
                      icon: Icons.electrical_services,
                      title: 'Power',
                      subtitle: 'Monitor',
                      color: const Color(0xFF00AA55),
                      imagePath: 'assets/images/pexels-brett-sayles-11153721.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PowerControlPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildQuickControlCard(
                      icon: Icons.curtains,
                      title: 'Curtains',
                      subtitle: 'Control',
                      color: Colors.blue.shade400,
                      imagePath: 'assets/images/pexels-alexeydemidov-11065733.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CurtainControlPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildQuickControlCard(
                      icon: Icons.lightbulb,
                      title: 'Lights',
                      subtitle: 'Manage',
                      color: Colors.orange.shade400,
                      imagePath: 'assets/images/pexels-nascimento-jr-1451812733-29974719.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LightControlPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Main Content - Cards with PageView
        Expanded(
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildRoomCard(
                    context: context,
                    title: 'Living Room',
                    deviceCount: 6,
                    icon: Icons.weekend_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    backgroundImage: 'assets/images/living.jpg',
                  ),
                  _buildRoomCard(
                    context: context,
                    title: 'Bedroom',
                    deviceCount: 4,
                    icon: Icons.bed_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    backgroundImage: 'assets/images/bedroom.webp',
                  ),
                  _buildRoomCard(
                    context: context,
                    title: 'Kitchen',
                    deviceCount: 3,
                    icon: Icons.kitchen_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    backgroundImage: 'assets/images/kitchen.jpg',
                  ),
                ],
              ),

              // Page indicators
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF00CC66)
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/RiseLogo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                          size: 48,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Risy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Quick Controls Section
            const Text(
              'Quick Controls',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildQuickControlCard(
                    icon: Icons.electrical_services,
                    title: 'Power',
                    subtitle: 'Monitor',
                    color: const Color(0xFF00AA55),
                    imagePath: 'assets/images/pexels-brett-sayles-11153721.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PowerControlPage(),
                        ),
                      );
                    },
                    isDesktop: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildQuickControlCard(
                    icon: Icons.curtains,
                    title: 'Curtains',
                    subtitle: 'Control',
                    color: Colors.blue.shade400,
                    imagePath: 'assets/images/pexels-alexeydemidov-11065733.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CurtainControlPage(),
                        ),
                      );
                    },
                    isDesktop: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildQuickControlCard(
                    icon: Icons.lightbulb,
                    title: 'Lights',
                    subtitle: 'Manage',
                    color: Colors.orange.shade400,
                    imagePath: 'assets/images/pexels-nascimento-jr-1451812733-29974719.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LightControlPage(),
                        ),
                      );
                    },
                    isDesktop: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Rooms Section
            const Text(
              'Rooms',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildRoomCard(
                    context: context,
                    title: 'Living Room',
                    deviceCount: 6,
                    icon: Icons.weekend_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    isDesktop: true,
                    backgroundImage: 'assets/images/living.jpg',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildRoomCard(
                    context: context,
                    title: 'Bedroom',
                    deviceCount: 4,
                    icon: Icons.bed_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    isDesktop: true,
                    backgroundImage: 'assets/images/bedroom.webp',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildRoomCard(
                    context: context,
                    title: 'Kitchen',
                    deviceCount: 3,
                    icon: Icons.kitchen_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D2D30), Color(0xFF1A1A1C)],
                    ),
                    isDesktop: true,
                    backgroundImage: 'assets/images/kitchen.jpg',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard({
    required BuildContext context,
    required String title,
    required int deviceCount,
    required IconData icon,
    required Gradient gradient,
    bool isDesktop = false,
    String? backgroundImage,
  }) {
    return Padding(
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: isDesktop ? 320 : null,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
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
                        decoration: BoxDecoration(gradient: gradient),
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
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                  child: Column(
                children: [
                  // Temperature/Status indicator
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thermostat_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '24°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Room icon in center
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFF1C1C1E),
                        size: 36,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // User avatars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatar(),
                      _buildAvatar(),
                      _buildAvatar(),
                      const SizedBox(width: 4),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00CC66),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade800,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildQuickControlCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    String? imagePath,
    bool isDesktop = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isDesktop ? null : 140,
        height: isDesktop ? 200 : 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          color: const Color(0xFF1C1C1E),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              if (imagePath != null)
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to solid color if image fails to load
                      return Container(
                        color: const Color(0xFF1C1C1E),
                      );
                    },
                  ),
                ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Text content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
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
