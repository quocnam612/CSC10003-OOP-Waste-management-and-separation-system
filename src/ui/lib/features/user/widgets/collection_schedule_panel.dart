import 'package:flutter/material.dart';

class CollectionSchedulePanel extends StatelessWidget {
  const CollectionSchedulePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Mô phỏng Map (PathFinder)
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 50, color: Colors.grey),
                const SizedBox(height: 8),
                const Text("Bản đồ lộ trình thu gom (PathFinder View)"),
                Text("Xe rác đang cách bạn: 2km", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        const Text("Lịch thu gom dự kiến", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // Danh sách lịch (RoutePlanner data)
        _buildScheduleItem("Hôm nay (23/12)", "17:00 - 17:30", true),
        _buildScheduleItem("Thứ tư (25/12)", "17:00 - 17:30", false),
        _buildScheduleItem("Thứ sáu (27/12)", "17:00 - 17:30", false),
      ],
    );
  }

  Widget _buildScheduleItem(String date, String time, bool isToday) {
    return Card(
      color: isToday ? Colors.green[50] : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.calendar_month, color: isToday ? Colors.green : Colors.grey),
        title: Text(date, style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text("Giờ thu gom: $time"),
        trailing: isToday 
          ? Chip(label: const Text("Sắp đến"), backgroundColor: Colors.orange.withOpacity(0.2), labelStyle: const TextStyle(color: Colors.orange))
          : null,
      ),
    );
  }
}