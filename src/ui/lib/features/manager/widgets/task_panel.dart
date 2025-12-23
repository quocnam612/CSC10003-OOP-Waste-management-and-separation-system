import 'package:flutter/material.dart';

class TaskPanel extends StatelessWidget {
  const TaskPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Phần Map giả lập (Header)
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blue[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map_outlined, size: 60, color: Colors.blue),
              const SizedBox(height: 8),
              const Text("Bản đồ điều phối (RoutePlanner View)"),
              ElevatedButton.icon(
                onPressed: (){}, 
                icon: const Icon(Icons.refresh), 
                label: const Text("Tối ưu lộ trình")
              )
            ],
          ),
        ),

        // 2. Danh sách nhiệm vụ
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Danh sách lộ trình hôm nay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              _buildTaskCard(context, "Tuyến Quận 1 - Khu A", "Xe: 59A-123.45", "Tài xế: Nguyễn Văn A", 0.8),
              _buildTaskCard(context, "Tuyến Bình Thạnh - Khu B", "Chưa phân công", "--", 0.0),
              _buildTaskCard(context, "Tuyến Quận 3 - Khu C", "Xe: 59C-999.88", "Tài xế: Trần Văn C", 0.3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, String routeName, String vehicle, String driver, double progress) {
    bool isUnassigned = driver == "--";
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(routeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (isUnassigned)
                  const Chip(label: Text("Chưa gán"), backgroundColor: Colors.red, labelStyle: TextStyle(color: Colors.white, fontSize: 10))
                else
                  const Chip(label: Text("Đang chạy"), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white, fontSize: 10))
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.local_shipping, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(vehicle)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.person, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(driver)]),
            
            const SizedBox(height: 12),
            if (!isUnassigned) ...[
              const Text("Tiến độ thu gom:", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: Theme.of(context).colorScheme.primary),
            ] else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: (){}, child: const Text("Phân công ngay")),
              )
          ],
        ),
      ),
    );
  }
}