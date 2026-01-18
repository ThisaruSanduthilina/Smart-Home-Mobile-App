import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatSidebar extends StatelessWidget {
  const ChatSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      color: const Color(0xFF0F1419),
      child: SafeArea(
        child: Column(
          children: [
            // Header with search
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // New chat button
                  _buildMenuItem(
                    context,
                    icon: Icons.edit_outlined,
                    label: 'New chat',
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<ChatProvider>(context, listen: false).clearChat();
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white12,
              height: 1,
            ),
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.image_outlined,
                    label: 'Images',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement images
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.grid_view_rounded,
                    label: 'Apps',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement apps
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.folder_outlined,
                    label: 'New project',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement new project
                    },
                  ),
                  const SizedBox(height: 16),
                  // Recent chats section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Recent',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildChatHistoryItem(
                    context,
                    'Fixing Indexing Errors',
                  ),
                  _buildChatHistoryItem(
                    context,
                    'Ngrok Authentication Error',
                  ),
                  _buildChatHistoryItem(
                    context,
                    'TensorFlow DLL Load Error',
                  ),
                  _buildChatHistoryItem(
                    context,
                    'GitHub Branch or Brace',
                  ),
                  _buildChatHistoryItem(
                    context,
                    'Java Server Client Analysis',
                  ),
                  _buildChatHistoryItem(
                    context,
                    'Concurrency vs Parallelism Exa...',
                  ),
                ],
              ),
            ),
            // Footer with user profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.red.shade700,
                    child: const Text(
                      'KC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'kaveen chamindu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Free plan',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.9),
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHistoryItem(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // TODO: Load chat history
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
