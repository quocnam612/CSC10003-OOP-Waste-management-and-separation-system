import 'package:flutter/material.dart';

class ManagerHomeWidget extends StatelessWidget {
  const ManagerHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hướng dẫn phân loại rác",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Quy định phân loại rác thải tại nguồn",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 20),

          // --- 1. RÁC HỮU CƠ ---
          _buildWasteTypeCard(
            context,
            title: "RÁC HỮU CƠ",
            subtitle: "Dễ phân hủy",
            description: "Thức ăn thừa, rau củ quả hư hỏng, bã trà, bã cà phê, lá cây, cỏ...",
            color: Colors.green,
            icon: Icons.compost, // Hoặc thay bằng Image.asset('assets/huuco.png')
            examples: ["Vỏ trái cây", "Xương động vật", "Cơm thừa"],
          ),

          const SizedBox(height: 16),

          // --- 2. RÁC VÔ CƠ (TÁI CHẾ) ---
          _buildWasteTypeCard(
            context,
            title: "RÁC VÔ CƠ (TÁI CHẾ)",
            subtitle: "Có thể tái sử dụng",
            description: "Các loại rác có thể tái chế như giấy, nhựa, kim loại, cao su, ni lông...",
            color: Colors.blue,
            icon: Icons.recycling, // Hoặc thay bằng Image.asset('assets/voco.png')
            examples: ["Chai nhựa", "Vỏ lon", "Giấy báo cũ"],
          ),

          const SizedBox(height: 16),

          // --- 3. RÁC KHÁC (CÒN LẠI) ---
          _buildWasteTypeCard(
            context,
            title: "RÁC THẢI KHÁC",
            subtitle: "Không tái chế được",
            description: "Rác không thuộc nhóm hữu cơ và tái chế. Cần xử lý chôn lấp hoặc đốt.",
            color: Colors.orange, // Hoặc màu xám đậm
            icon: Icons.delete_outline, // Hoặc thay bằng Image.asset('assets/khac.png')
            examples: ["Túi nilon bẩn", "Sành sứ vỡ", "Giấy ăn đã dùng"],
          ),
        ],
      ),
    );
  }

  Widget _buildWasteTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
    required List<String> examples,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header của Card (Màu nền đậm)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nội dung chi tiết
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mô tả
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                
                // Ví dụ minh họa (Hình ảnh nhỏ / Chip)
                const Text("Ví dụ điển hình:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: examples.map((ex) => Chip(
                    label: Text(ex),
                    backgroundColor: color.withOpacity(0.1),
                    labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                    avatar: CircleAvatar(
                      backgroundColor: color,
                      radius: 8,
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  )).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}