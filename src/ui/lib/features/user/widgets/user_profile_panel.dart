import 'package:flutter/material.dart';

class UserProfilePanel extends StatefulWidget {
  const UserProfilePanel({super.key});

  @override
  State<UserProfilePanel> createState() => _UserProfilePanelState();
}

class _UserProfilePanelState extends State<UserProfilePanel> {
  // Giả lập dữ liệu load từ ProfileBUS
  final TextEditingController _nameCtrl = TextEditingController(text: "Lê Thị C");
  final TextEditingController _phoneCtrl = TextEditingController(text: "0987654321");
  final TextEditingController _addressCtrl = TextEditingController(text: "Số 12, Đường Nguyễn Văn Cừ, Q.5");

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://i.pravatar.cc/300"), // Ảnh giả lập
          ),
          const SizedBox(height: 16),
          
          // Nút chỉnh sửa
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() => _isEditing = !_isEditing);
              },
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              label: Text(_isEditing ? "Lưu thay đổi" : "Chỉnh sửa"),
            ),
          ),

          // Form thông tin
          _buildTextField("Họ và tên", _nameCtrl, Icons.person),
          const SizedBox(height: 16),
          _buildTextField("Số điện thoại", _phoneCtrl, Icons.phone),
          const SizedBox(height: 16),
          _buildTextField("Địa chỉ (Điểm thu gom)", _addressCtrl, Icons.location_on),
          
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.lock_reset),
            label: const Text("Đổi mật khẩu"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: !_isEditing,
        fillColor: Colors.grey[100],
      ),
    );
  }
}