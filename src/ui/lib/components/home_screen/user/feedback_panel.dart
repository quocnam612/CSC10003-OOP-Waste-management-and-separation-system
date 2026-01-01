import 'package:flutter/material.dart';
import 'package:ui/services/reports_api.dart';

class FeedbackPanel extends StatefulWidget {
  final String authToken;
  final int userRegion;

  const FeedbackPanel({
    super.key,
    required this.authToken,
    required this.userRegion,
  });

  @override
  State<FeedbackPanel> createState() => _FeedbackPanelState();
}

class _FeedbackPanelState extends State<FeedbackPanel> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int? _selectedType;
  bool _isSubmitting = false;

  final List<MapEntry<int, String>> _feedbackTypes = [
    const MapEntry(1, 'Rác chưa được thu gom'),
    const MapEntry(2, 'Thái độ nhân viên'),
    const MapEntry(3, 'Yêu cầu dịch vụ thêm'),
    const MapEntry(4, 'Khác'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (widget.userRegion <= 0) {
      _showSnack('Vui lòng cập nhật phường trong phần Cài đặt trước khi gửi phản hồi.',
          isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    final token = widget.authToken;
    if (token.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.',
          isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ReportsApi.createReport(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        type: _selectedType!,
        token: token,
      );

      _showSnack('Đã gửi phản hồi thành công! Cảm ơn ý kiến của bạn.');
      _titleController.clear();
      _contentController.clear();
      setState(() => _selectedType = null);
    } catch (e) {
      _showSnack('Không thể gửi phản hồi: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final bool requiresRegionUpdate = widget.userRegion <= 0;

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

          if (requiresRegionUpdate)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vui lòng cập nhật phường trong phần Cài đặt để sử dụng tính năng này.',
                          style: TextStyle(color: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Form nhập liệu
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IgnorePointer(
                ignoring: requiresRegionUpdate,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    // 1. Chọn loại phản hồi
                    DropdownButtonFormField<int>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Loại phản hồi',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _feedbackTypes
                          .map(
                            (type) => DropdownMenuItem<int>(
                              value: type.key,
                              child: Text(type.value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _selectedType = value),
                      validator: (val) =>
                          val == null ? 'Vui lòng chọn loại phản hồi' : null,
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
                      onPressed: (_isSubmitting || requiresRegionUpdate) ? null : _handleSubmit,
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
          ),
        ],
      ),
    );
  }
}
