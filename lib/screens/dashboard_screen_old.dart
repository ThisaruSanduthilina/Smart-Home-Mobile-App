import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/firebase_service.dart';
import '../widgets/led_control_card.dart';
import '../widgets/curtain_control_card.dart';
import '../widgets/power_monitor_card.dart';
import 'chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.darkGrey,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risy',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Smart Automation',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.green),
            onPressed: () {
              // Settings screen can be added later
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: AppColors.green,
        backgroundColor: AppColors.darkGrey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Power Monitor Section
              StreamBuilder(
                stream: _firebaseService.getPowerMonitorStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return PowerMonitorCard(powerMonitor: snapshot.data!);
                },
              ),
              const SizedBox(height: 24),

              // Curtain Control Section
              StreamBuilder(
                stream: _firebaseService.getCurtainStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CurtainControlCard(
                    curtain: snapshot.data!,
                    onOpen: () => _firebaseService.openCurtain(),
                    onClose: () => _firebaseService.closeCurtain(),
                    onStop: () => _firebaseService.stopCurtain(),
                    onPositionChange: (position) =>
                        _firebaseService.setCurtainPosition(position),
                  );
                },
              ),
              const SizedBox(height: 24),

              // LED Controls Section
              Text(
                'Lighting Controls',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.green,
                    ),
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: _firebaseService.getLEDsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final leds = snapshot.data!;
                  final ledKeys = leds.keys.toList()..sort();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: ledKeys.length,
                    itemBuilder: (context, index) {
                      final ledName = ledKeys[index];
                      final led = leds[ledName]!;
                      return LedControlCard(
                        ledName: ledName,
                        led: led,
                        onToggle: (value) =>
                            _firebaseService.toggleLED(ledName, value),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.green,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'All Lights ON',
                      Icons.lightbulb,
                      () async {
                        final leds = await _firebaseService
                            .getLEDsStream()
                            .first;
                        for (final ledName in leds.keys) {
                          await _firebaseService.toggleLED(ledName, true);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionButton(
                      context,
                      'All Lights OFF',
                      Icons.lightbulb_outline,
                      () async {
                        final leds = await _firebaseService
                            .getLEDsStream()
                            .first;
                        for (final ledName in leds.keys) {
                          await _firebaseService.toggleLED(ledName, false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.black,
        icon: const Icon(Icons.chat),
        label: const Text('Chat Control'),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mediumGrey,
        foregroundColor: AppColors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.green, width: 1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
