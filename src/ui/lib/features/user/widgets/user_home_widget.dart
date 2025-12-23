import 'package:flutter/material.dart';

class UserHomeWidget extends StatelessWidget {
  final String userName;

  const UserHomeWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner chào mừng
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Xin chào, $userName!", 
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text("Hãy cùng giữ gìn môi trường xanh.", 
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Thông báo quan trọng (UserBUS - Thông báo phí/lịch)
          const Text("Thông báo mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange[100], shape: BoxShape.circle),
                child: const Icon(Icons.notification_important, color: Colors.orange),
              ),
              title: const Text("Phí thu gom tháng 12"),
              subtitle: const Text("Bạn chưa thanh toán 50.000đ"),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                child: const Text("Thanh toán"),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Thống kê nhanh (UserBUS - Lịch sử thu gom)
          const Text("Thống kê tháng này", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildStatCard(Icons.delete_outline, "12 kg", "Rác thải", Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(Icons.check_circle_outline, "4 lần", "Đã thu gom", Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}