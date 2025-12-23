import 'package:flutter/material.dart';

class RequestPanel extends StatefulWidget {
  const RequestPanel({super.key});

  @override
  State<RequestPanel> createState() => _RequestPanelState();
}

class _RequestPanelState extends State<RequestPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data
  final List<Map<String, dynamic>> _requests = [
    {"title": "Rác chưa được thu gom", "content": "Khu vực ngõ 123 rác ùn ứ 2 ngày nay.", "sender": "Nguyễn Văn A", "time": "10:30 AM", "status": "pending"},
    {"title": "Thái độ nhân viên", "content": "Nhân viên thu gom làm rơi rác ra đường.", "sender": "Trần B", "time": "Yesterday", "status": "resolved"},
    {"title": "Yêu cầu thùng rác mới", "content": "Thùng rác công cộng bị vỡ.", "sender": "Lê C", "time": "20/12/2025", "status": "pending"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: "Chờ xử lý"),
            Tab(text: "Lịch sử"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(statusFilter: "pending"),
              _buildList(statusFilter: "resolved"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList({required String statusFilter}) {
    final filteredList = _requests.where((r) => r['status'] == statusFilter).toList();

    if (filteredList.isEmpty) {
      return const Center(child: Text("Không có dữ liệu", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item['title'], style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold)),
                    ),
                    Text(item['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['content'], style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['sender'], style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    if (statusFilter == "pending")
                      ElevatedButton(
                        onPressed: () {
                          // Logic chuyển trạng thái sang resolved
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                        child: const Text("Xử lý"),
                      )
                    else
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text("Đã xong", style: TextStyle(color: Colors.green)),
                        ],
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}