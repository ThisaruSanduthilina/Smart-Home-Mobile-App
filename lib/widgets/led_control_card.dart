import 'package:flutter/material.dart';
import '../models/led_model.dart';

class LedControlCard extends StatelessWidget {
  final String ledName;
  final LedModel led;
  final Function(bool) onToggle;

  const LedControlCard({
    super.key,
    required this.ledName,
    required this.led,
    required this.onToggle,
  });

  String get displayName {
    if (ledName.contains('LOBBY')) {
      return ledName.replaceAll('_', ' ');
    }
    return ledName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final surfaceColor = theme.colorScheme.surface;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: led.isOn
              ? LinearGradient(
                  colors: isDark
                      ? [
                          surfaceColor,
                          surfaceColor.withValues(alpha: 0.8),
                        ]
                      : [
                          primaryColor.withValues(alpha: 0.05),
                          primaryColor.withValues(alpha: 0.1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: led.isOn
              ? Border.all(color: primaryColor, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 40,
                    color: led.isOn
                        ? primaryColor
                        : onSurfaceColor.withValues(alpha: 0.4),
                  ),
                  Switch(
                    value: led.isOn,
                    onChanged: onToggle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: theme.textTheme.titleLarge?.copyWith(
                      color: led.isOn ? primaryColor : onSurfaceColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                led.isOn ? 'ON' : 'OFF',
                style: theme.textTheme.bodySmall?.copyWith(
                      color: led.isOn
                          ? primaryColor
                          : onSurfaceColor.withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
