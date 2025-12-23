import 'package:flutter/material.dart';

class TaskPanel extends StatelessWidget {
  // Nhận danh sách công việc từ Dashboard
  final List<Map<String, dynamic>> tasks;
  
  // --- ĐÂY LÀ THAM SỐ BẠN ĐANG THIẾU ---
  // Hàm callback để báo cho Dashboard biết cần cập nhật trạng thái
  final Function(int id, String newStatus) onStatusChanged;

  const TaskPanel({
    super.key,
    required this.tasks,
    // --- BẮT BUỘC PHẢI CÓ DÒNG NÀY ---
    required this.onStatusChanged,
  });

  // Helper: Chọn màu dựa trên trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hoàn thành': return Colors.green;
      case 'Đang làm': return Colors.blue;
      default: return Colors.orange; // 'Chưa làm'
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Không có công việc nào hôm nay!", style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final statusColor = _getStatusColor(task['status']);

        return Card(
          elevation: 3,
          shadowColor: Colors.black12,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- DÒNG 1: HEADER (ID & NÚT TRẠNG THÁI) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "#${task['id']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    
                    // Dropdown chọn trạng thái (Sử dụng onStatusChanged tại đây)
                    PopupMenuButton<String>(
                      onSelected: (value) => onStatusChanged(task['id'], value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Chưa làm', child: Text('Chưa làm')),
                        const PopupMenuItem(value: 'Đang làm', child: Text('Đang làm')),
                        const PopupMenuItem(value: 'Hoàn thành', child: Text('Hoàn thành', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 10, color: statusColor),
                            const SizedBox(width: 8),
                            Text(
                              task['status'],
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, size: 18, color: statusColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),

                // --- DÒNG 2: KHU VỰC (ĐỊA CHỈ) ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task['area'] ?? 'Chưa có địa chỉ',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),

                // --- DÒNG 3: THỜI GIAN ---
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeBox(
                        "Giờ giao việc", 
                        task['assignedTime'] ?? "--:--", 
                        Colors.blue, 
                        Colors.blue[50]!
                      )
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeBox(
                        "Hoàn thành lúc", 
                        task['completedTime'] ?? "--:--", 
                        task['completedTime'] != null ? Colors.green : Colors.grey, 
                        task['completedTime'] != null ? Colors.green[50]! : Colors.grey[100]!
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeBox(String label, String time, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(label.contains("Hoàn thành") ? Icons.check_circle_outline : Icons.access_time, 
                   size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(time, style: TextStyle(fontWeight: FontWeight.bold, color: iconColor == Colors.grey ? Colors.grey : Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}