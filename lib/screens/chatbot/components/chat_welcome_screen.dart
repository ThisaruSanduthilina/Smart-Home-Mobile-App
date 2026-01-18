import 'package:flutter/material.dart';

class ChatWelcomeScreen extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const ChatWelcomeScreen({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Main heading
            const Text(
              'What can I help with?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Suggestion buttons grid
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSuggestionChip(
                  icon: Icons.lightbulb_outline,
                  iconColor: Colors.orange,
                  label: 'Control lights',
                  onTap: () => onSuggestionTap('Turn on living room lights'),
                ),
                _buildSuggestionChip(
                  icon: Icons.power,
                  iconColor: Colors.green,
                  label: 'Check power usage',
                  onTap: () => onSuggestionTap('Show me the power consumption'),
                ),
                _buildSuggestionChip(
                  icon: Icons.curtains_outlined,
                  iconColor: Colors.blue,
                  label: 'Manage curtains',
                  onTap: () => onSuggestionTap('Open the curtains'),
                ),
                _buildSuggestionChip(
                  icon: Icons.wb_sunny_outlined,
                  iconColor: Colors.amber,
                  label: 'Solar status',
                  onTap: () => onSuggestionTap('How much solar power am I generating?'),
                ),
                _buildSuggestionChip(
                  icon: Icons.home_outlined,
                  iconColor: Colors.teal,
                  label: 'Room status',
                  onTap: () => onSuggestionTap('Show all room devices status'),
                ),
                _buildSuggestionChip(
                  icon: Icons.more_horiz,
                  iconColor: Colors.grey,
                  label: 'More',
                  onTap: () => onSuggestionTap('What else can you help me with?'),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
