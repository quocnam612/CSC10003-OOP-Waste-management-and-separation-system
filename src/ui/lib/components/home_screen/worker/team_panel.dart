import 'package:flutter/material.dart';

class CleaningTeamPanel extends StatelessWidget {
  final String teamName;
  final List<Map<String, dynamic>> members;

  const CleaningTeamPanel({
    super.key,
    required this.teamName,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Thành viên',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (members.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text('Chưa có thành viên trong đội.'),
            )
          else
            Column(
              children: members
                  .map((member) => _buildMemberTile(context, member))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, Map<String, dynamic> member) {
    final theme = Theme.of(context);
    final displayName = (member['name'] ?? '') as String? ?? '---';
    final username = (member['username'] ?? '') as String? ?? '';
    final phone = (member['phone'] ?? '') as String? ?? '---';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Text(
              displayName.isNotEmpty ? displayName[0] : '?',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  username.isNotEmpty ? '@$username' : '',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(phone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
