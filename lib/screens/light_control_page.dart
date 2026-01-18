import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/led_control_card.dart';

class LightControlPage extends StatefulWidget {
  const LightControlPage({super.key});

  @override
  State<LightControlPage> createState() => _LightControlPageState();
}

class _LightControlPageState extends State<LightControlPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lightbulb,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Light Control',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
              Text(
                'Smart Lighting System',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Control all lights in your home',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder(
                stream: _firebaseService.getLEDsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading lights...',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
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
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 2.5,
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
                      const SizedBox(height: 24),
                      // Quick Actions
                      _buildQuickActions(context, leds.keys.toList()),
                      const SizedBox(height: 24),
                      // Statistics Card
                      _buildStatisticsCard(context, leds),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                context,
                'Light Control Tips',
                'Toggle individual lights by tapping their switches. Use Quick Actions for bulk operations. '
                'The green glow indicates an active light. You can also control lights using voice commands in the Chat section.',
                Icons.tips_and_updates,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, List<String> ledNames) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      for (final ledName in ledNames) {
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
                      for (final ledName in ledNames) {
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Turn on main lights (LED1-4)
                      for (var i = 1; i <= 4; i++) {
                        await _firebaseService.toggleLED('LED$i', true);
                      }
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Main Lights'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Turn on lobby lights
                      await _firebaseService.toggleLED('LOBBY_LED1', true);
                      await _firebaseService.toggleLED('LOBBY_LED2', true);
                    },
                    icon: const Icon(Icons.meeting_room),
                    label: const Text('Lobby Lights'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, Map<String, dynamic> leds) {
    final theme = Theme.of(context);
    final onLights = leds.values.where((led) => led.isOn).length;
    final totalLights = leds.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                context,
                'Total Lights',
                totalLights.toString(),
                Icons.lightbulb_outline,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: theme.dividerColor,
            ),
            Expanded(
              child: _buildStatItem(
                context,
                'Lights ON',
                onLights.toString(),
                Icons.lightbulb,
                color: theme.colorScheme.primary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: theme.dividerColor,
            ),
            Expanded(
              child: _buildStatItem(
                context,
                'Lights OFF',
                (totalLights - onLights).toString(),
                Icons.lightbulb_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
