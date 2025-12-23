import 'package:flutter/material.dart';

class WorkerRoutePanel extends StatelessWidget {
  const WorkerRoutePanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập từ PathFinder
    final List<String> routeNodes = [
      "Kho xe (Xuất phát)",
      "123 Nguyễn Huệ (Điểm A)",
      "45 Lê Lợi (Điểm B)",
      "Chợ Bến Thành (Điểm C)",
      "Trạm xử lý rác (Kết thúc)"
    ];

    return Scaffold(
      body: Column(
        children: [
          // 1. Phần Bản Đồ (Giả lập)
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.blue[50],
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.blue[300]),
                        const Text("Google Maps / OpenStreetMap View", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // Nút định vị
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {},
                      child: const Icon(Icons.my_location),
                    ),
                  )
                ],
              ),
            ),
          ),

          // 2. Chi tiết các chặng (Nodes)
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lộ trình tối ưu (PathFinder)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: routeNodes.length,
                      itemBuilder: (context, index) {
                        bool isFirst = index == 0;
                        bool isLast = index == routeNodes.length - 1;
                        
                        return Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 2, height: 20,
                                  color: isFirst ? Colors.transparent : Colors.grey,
                                ),
                                Icon(
                                  isFirst ? Icons.radio_button_checked : (isLast ? Icons.flag : Icons.circle),
                                  size: isFirst || isLast ? 20 : 12,
                                  color: isFirst ? Colors.blue : (isLast ? Colors.red : Colors.grey),
                                ),
                                Container(
                                  width: 2, height: 20,
                                  color: isLast ? Colors.transparent : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Text(routeNodes[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}