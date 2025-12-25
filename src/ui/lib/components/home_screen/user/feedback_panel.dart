import 'package:flutter/material.dart';

class FeedbackPanel extends StatefulWidget {
  const FeedbackPanel({super.key});

  @override
  State<FeedbackPanel> createState() => _FeedbackPanelState();
}

class _FeedbackPanelState extends State<FeedbackPanel> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedType;

  final List<String> _feedbackTypes = [
    'Rác chưa được thu gom',
    'Thái độ nhân viên',
    'Yêu cầu dịch vụ thêm',
    'Khác',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Giả lập gửi dữ liệu đi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Đã gửi phản hồi thành công! Cảm ơn ý kiến của bạn.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Reset form sau khi gửi
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedType = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header trang trí
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.feedback_outlined, size: 40, color: primaryColor),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gửi ý kiến đóng góp", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Chúng tôi luôn lắng nghe để cải thiện dịch vụ.", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form nhập liệu
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Chọn loại phản hồi
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Loại phản hồi',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _feedbackTypes.map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedType = value),
                      validator: (val) => val == null ? 'Vui lòng chọn loại phản hồi' : null,
                    ),
                    const SizedBox(height: 16),

                    // 2. Nhập tiêu đề
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        prefixIcon: Icon(Icons.title),
                        hintText: 'Ví dụ: Rác ùn ứ tại ngõ 123',
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập tiêu đề' : null,
                    ),
                    const SizedBox(height: 16),

                    // 3. Nhập nội dung
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung chi tiết',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 80), // Đẩy icon lên trên
                          child: Icon(Icons.description_outlined),
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Vui lòng nhập nội dung' : null,
                    ),
                    const SizedBox(height: 24),

                    // 4. Nút gửi
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.send),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("GỬI PHẢN HỒI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}