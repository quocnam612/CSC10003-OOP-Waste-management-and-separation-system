import 'package:flutter/material.dart';

class ManagePanel extends StatefulWidget {
  const ManagePanel({super.key});

  @override
  State<ManagePanel> createState() => _ManagePanelState();
}

class _ManagePanelState extends State<ManagePanel> {
  // Dữ liệu giả lập danh sách Worker (Khớp với WorkerBUS)
  final List<Map<String, dynamic>> _workers = [
    {
      "id": "W101",
      "name": "Trần Văn B",
      "phone": "0909 123 456",
      "role": "Nhân viên thu gom",
      "vehicle": "59C-123.45",
      "status": "Đang làm việc" // Trạng thái lấy từ Worker Dashboard
    },
    {
      "id": "W102",
      "name": "Lê Văn T",
      "phone": "0912 999 888",
      "role": "Tài xế",
      "vehicle": "59A-999.99",
      "status": "Rảnh"
    },
    {
      "id": "W103",
      "name": "Nguyễn Thị H",
      "phone": "0988 777 666",
      "role": "Điều phối viên",
      "vehicle": "--",
      "status": "Nghỉ phép"
    },
  ];

  // --- HÀM XỬ LÝ (CRUD) ---

  // 1. Thêm / Sửa nhân viên
  void _showWorkerDialog({Map<String, dynamic>? worker}) {
    final isEditing = worker != null;
    final nameCtrl = TextEditingController(text: worker?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: worker?['phone'] ?? '');
    final vehicleCtrl = TextEditingController(text: worker?['vehicle'] ?? '');
    String selectedRole = worker?['role'] ?? 'Nhân viên thu gom';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Cập nhật nhân viên' : 'Thêm nhân viên mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Họ và tên', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại', prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Vị trí', prefixIcon: Icon(Icons.work)),
                items: ['Nhân viên thu gom', 'Tài xế', 'Điều phối viên']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => selectedRole = val!,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vehicleCtrl,
                decoration: const InputDecoration(labelText: 'Biển số xe (nếu có)', prefixIcon: Icon(Icons.local_shipping)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  worker!['name'] = nameCtrl.text;
                  worker['phone'] = phoneCtrl.text;
                  worker['role'] = selectedRole;
                  worker['vehicle'] = vehicleCtrl.text;
                } else {
                  _workers.add({
                    "id": "W${100 + _workers.length + 1}",
                    "name": nameCtrl.text,
                    "phone": phoneCtrl.text,
                    "role": selectedRole,
                    "vehicle": vehicleCtrl.text,
                    "status": "Rảnh"
                  });
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // 2. Xóa nhân viên
  void _deleteWorker(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: Text("Bạn có chắc chắn muốn xóa nhân viên ${_workers[index]['name']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              setState(() => _workers.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- GIAO DIỆN ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // Nút thêm nhân viên (Góc dưới phải)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWorkerDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Thêm Nhân Viên"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo tên hoặc mã ID...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // Danh sách nhân viên
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // Padding dưới để tránh nút FAB
              itemCount: _workers.length,
              itemBuilder: (context, index) {
                final worker = _workers[index];
                final isWorking = worker['status'] == 'Đang làm việc';
                final isOff = worker['status'] == 'Nghỉ phép';
                
                Color statusColor = isWorking ? Colors.green : (isOff ? Colors.red : Colors.grey);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue[50],
                            child: Text(worker['name'][0], 
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(worker['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${worker['role']} - ID: ${worker['id']}"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(worker['status'], 
                                style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(worker['vehicle'], style: const TextStyle(color: Colors.grey)),
                            ]),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showWorkerDialog(worker: worker),
                                  tooltip: "Sửa thông tin",
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteWorker(index),
                                  tooltip: "Xóa nhân viên",
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}