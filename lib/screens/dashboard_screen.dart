import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../providers/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.home_rounded,
                color: isDark ? Colors.black : Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risy',
                  style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Smart Automation',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Power Control & Monitoring
              _buildSectionHeader(
                context,
                'Power Control & Monitoring',
                Icons.electrical_services,
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: _firebaseService.getPowerMonitorStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return PowerMonitorCard(powerMonitor: snapshot.data!);
                },
              ),
              const SizedBox(height: 32),

              // Section 2: Curtain Control
              _buildSectionHeader(
                context,
                'Curtain Control',
                Icons.curtains,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 32),

              // Section 3: Light Control
              _buildSectionHeader(
                context,
                'Light Control',
                Icons.lightbulb,
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

                  return Column(
                    children: [
                      // LED Grid
                      GridView.builder(
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
                      ),
                      const SizedBox(height: 16),
                      // Quick Actions
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                for (final ledName in leds.keys) {
                                  await _firebaseService.toggleLED(ledName, true);
                                }
                              },
                              icon: const Icon(Icons.lightbulb),
                              label: const Text('All ON'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                for (final ledName in leds.keys) {
                                  await _firebaseService.toggleLED(ledName, false);
                                }
                              },
                              icon: const Icon(Icons.lightbulb_outline),
                              label: const Text('All OFF'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: theme.colorScheme.surface,
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
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
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.black : Colors.black,
        icon: const Icon(Icons.chat),
        label: const Text('Chat Control'),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
