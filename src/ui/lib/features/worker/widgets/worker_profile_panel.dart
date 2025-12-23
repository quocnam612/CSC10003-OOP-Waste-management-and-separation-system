import 'package:flutter/material.dart';

class WorkerProfilePanel extends StatelessWidget {
  const WorkerProfilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=12"), // Ảnh giả
          ),
          const SizedBox(height: 16),
          const Text("Trần Văn B", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Nhân viên thu gom - ID: W002", style: TextStyle(color: Colors.grey)),
          
          const SizedBox(height: 30),
          
          // Thông tin chi tiết
          _buildInfoTile(Icons.phone, "Số điện thoại", "0909 123 456"),
          _buildInfoTile(Icons.local_shipping, "Phương tiện phụ trách", "Xe tải nhỏ: 59C-123.45"),
          _buildInfoTile(Icons.badge, "Khu vực hoạt động", "Quận 1, Quận 3"),
          _buildInfoTile(Icons.calendar_today, "Ca làm việc", "Ca sáng (06:00 - 14:00)"),
          
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.report_problem),
              label: const Text("Báo cáo sự cố xe"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      ),
    );
  }
}