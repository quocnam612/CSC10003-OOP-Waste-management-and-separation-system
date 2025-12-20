import 'package:flutter/material.dart';

class CheckinPanel extends StatelessWidget {
  final VoidCallback onCheckIn;

  const CheckinPanel({super.key, required this.onCheckIn});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = "Ngày ${now.day}/${now.month}/${now.year}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.timer_outlined, size: 80, color: Colors.orange[400]),
          ),
          const SizedBox(height: 24),
          Text(dateStr, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          Text(timeStr, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 40),
          
          SizedBox(
            width: 250,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: onCheckIn,
              icon: const Icon(Icons.fingerprint, size: 32),
              label: const Text("ĐIỂM DANH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Vui lòng bật GPS để điểm danh chính xác", style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}