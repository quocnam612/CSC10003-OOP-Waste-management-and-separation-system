import 'package:flutter/material.dart';
import '../../../models/customer_model.dart';

class CustomerFormDialog extends StatefulWidget {
  final Function(CustomerModel) onSubmit;

  const CustomerFormDialog({super.key, required this.onSubmit});

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers quản lý dữ liệu nhập
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  
  bool _isActive = true; // Mặc định là Hoạt động

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // 1. Tạo ID giả lập (trong thực tế sẽ do Server tạo hoặc dùng UUID)
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final currentDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

      // 2. Đóng gói dữ liệu vào Model
      final newCustomer = CustomerModel(
        id: newId,
        fullName: _fullNameCtrl.text,
        username: _usernameCtrl.text,
        phone: _phoneCtrl.text,
        area: _areaCtrl.text,
        createdDate: currentDate,
        isActive: _isActive,
      );

      // 3. Gửi dữ liệu ra ngoài cho AuthHome xử lý
      widget.onSubmit(newCustomer);
      
      // 4. Đóng Dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Khách Hàng Mới'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameCtrl,
                decoration: const InputDecoration(labelText: 'Họ và tên', prefixIcon: Icon(Icons.person)),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: 'Tên tài khoản', prefixIcon: Icon(Icons.account_circle)),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên tài khoản' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại', prefixIcon: Icon(Icons.phone)),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập SĐT' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaCtrl,
                decoration: const InputDecoration(labelText: 'Khu vực', prefixIcon: Icon(Icons.map)),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập khu vực' : null,
              ),
              const SizedBox(height: 16),
              // Switch trạng thái
              SwitchListTile(
                title: const Text('Trạng thái hoạt động'),
                value: _isActive,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (val) {
                  setState(() => _isActive = val);
                },
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}