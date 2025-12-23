import 'package:flutter/material.dart';

class WorkerHistoryPanel extends StatelessWidget {
  const WorkerHistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập
    final List<Map<String, String>> history = [
      {"date": "22/12/2025", "route": "Tuyến Quận 1", "status": "Hoàn thành", "kg": "450kg"},
      {"date": "21/12/2025", "route": "Tuyến Quận 3", "status": "Hoàn thành", "kg": "380kg"},
      {"date": "20/12/2025", "route": "Tuyến Bình Thạnh", "status": "Nghỉ phép", "kg": "0kg"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final isLeave = item['status'] == "Nghỉ phép";

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isLeave ? Colors.grey[300] : Colors.green[100],
              child: Icon(
                isLeave ? Icons.block : Icons.check, 
                color: isLeave ? Colors.grey : Colors.green
              ),
            ),
            title: Text(item['date']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${item['route']} - ${item['status']}"),
            trailing: Text(
              item['kg']!, 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary
              )
            ),
          ),
        );
      },
    );
  }
}