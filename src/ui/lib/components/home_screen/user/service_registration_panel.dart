import 'package:flutter/material.dart';

class ServiceRegistrationPanel extends StatefulWidget {
  const ServiceRegistrationPanel({
    super.key,
    this.userRegion = 0,
    this.authToken,
  });

  final int userRegion;
  final String? authToken;

  @override
  State<ServiceRegistrationPanel> createState() => _ServiceRegistrationPanelState();
}

class _ServiceRegistrationPanelState extends State<ServiceRegistrationPanel> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedService;
  bool _isSubmitting = false;

  final List<String> _services = const [
    'Thu gom rác tại nhà',
    'Thu gom rác cồng kềnh',
    'Thu gom thiết bị điện tử',
    'Vệ sinh thùng chứa rác',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      _showSnack('Vui lòng chọn dịch vụ', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    _showSnack('Yêu cầu đã được ghi nhận. Nhân viên sẽ liên hệ trong thời gian sớm nhất.');
    _formKey.currentState!.reset();
    setState(() => _selectedService = null);
    _addressController.clear();
    _noteController.clear();
    setState(() => _isSubmitting = false);
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment_add, size: 40, color: primary),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đăng ký dịch vụ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Chọn dịch vụ và để lại thông tin để chúng tôi liên hệ.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
                    DropdownButtonFormField<String>(
                      value: _selectedService,
                      decoration: const InputDecoration(
                        labelText: 'Chọn dịch vụ',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _services
                          .map((service) => DropdownMenuItem<String>(
                                value: service,
                                child: Text(service),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedService = value),
                      validator: (value) => value == null ? 'Vui lòng chọn dịch vụ' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Địa chỉ chi tiết',
                        prefixIcon: Icon(Icons.home),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Vui lòng nhập địa chỉ chi tiết' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú thêm (Tùy chọn)',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      icon: const Icon(Icons.send),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _isSubmitting ? 'Đang gửi...' : 'ĐĂNG KÝ DỊCH VỤ',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
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
