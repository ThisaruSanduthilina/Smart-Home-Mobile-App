import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/curtain_model.dart';

class CurtainControlCard extends StatelessWidget {
  final CurtainModel curtain;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final VoidCallback onStop;
  final Function(int) onPositionChange;

  const CurtainControlCard({
    super.key,
    required this.curtain,
    required this.onOpen,
    required this.onClose,
    required this.onStop,
    required this.onPositionChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.curtains,
                  size: 32,
                  color: primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Curtain Control',
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'State',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: curtain.isOpen
                              ? primaryColor.withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          curtain.state.toUpperCase(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: curtain.isOpen
                                    ? primaryColor
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: curtain.isMoving
                              ? AppColors.warning.withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          curtain.status.toUpperCase(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: curtain.isMoving
                                    ? AppColors.warning
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Position: ${curtain.position}%',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              ),
              child: Slider(
                value: curtain.position.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: '${curtain.position}%',
                onChanged: (value) {
                  onPositionChange(value.toInt());
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Open'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStop,
                    icon: const Icon(Icons.pause),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onClose,
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
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
}
