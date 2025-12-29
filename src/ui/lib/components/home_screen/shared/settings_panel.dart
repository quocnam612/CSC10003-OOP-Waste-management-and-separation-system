import 'package:flutter/material.dart';
import 'package:ui/services/settings_api.dart';

class AccountSettingsPanel extends StatefulWidget {
  final String username;
  final String initialName;
  final String initialPhone;
  final int initialRegion;
  final String? authToken;
  final void Function(String name, String phone, int region)? onProfileUpdated;

  const AccountSettingsPanel({
    super.key,
    required this.username,
    required this.initialName,
    required this.initialPhone,
    required this.initialRegion,
    this.authToken,
    this.onProfileUpdated,
  });

  @override
  State<AccountSettingsPanel> createState() => _AccountSettingsPanelState();
}

class _AccountSettingsPanelState extends State<AccountSettingsPanel> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _regionController;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isProfileSubmitting = false;
  bool _isPasswordSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _regionController = TextEditingController(text: widget.initialRegion.toString());
  }

  @override
  void didUpdateWidget(covariant AccountSettingsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName != widget.initialName) _nameController.text = widget.initialName;
    if (oldWidget.initialPhone != widget.initialPhone) _phoneController.text = widget.initialPhone;
    if (oldWidget.initialRegion != widget.initialRegion) _regionController.text = widget.initialRegion.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
  }

  Future<void> _handleProfileSubmit() async {
    if (_profileFormKey.currentState?.validate() != true) return;
    final int? region = int.tryParse(_regionController.text.trim());
    if (region == null) {
      _showSnack('Khu vực không hợp lệ', isError: true);
      return;
    }

    final token = widget.authToken;
    if (token == null || token.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.',
          isError: true);
      return;
    }

    setState(() => _isProfileSubmitting = true);
    try {
      await SettingsApi.updateProfile(
        username: widget.username,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        region: region,
        token: token,
      );
      widget.onProfileUpdated?.call(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        region,
      );
      _showSnack('Đã cập nhật thông tin cá nhân');
    } catch (e) {
      _showSnack('Cập nhật thất bại: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isProfileSubmitting = false);
      }
    }
  }

  Future<void> _handlePasswordSubmit() async {
    if (_passwordFormKey.currentState?.validate() != true) return;

    final token = widget.authToken;
    if (token == null || token.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.',
          isError: true);
      return;
    }

    setState(() => _isPasswordSubmitting = true);
    try {
      await SettingsApi.changePassword(
        username: widget.username,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        token: token,
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _showSnack('Đổi mật khẩu thành công');
    } catch (e) {
      _showSnack('Đổi mật khẩu thất bại: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isPasswordSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfileCard(primary),
            const SizedBox(height: 24),
            _buildPasswordCard(primary),
          ],
        );

        if (constraints.maxWidth < 640) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: content,
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: content,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(Color primary) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _profileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Không được để trống họ tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Không được để trống số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _regionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mã khu vực',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập khu vực';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Khu vực phải là số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed:
                      _isProfileSubmitting ? null : () => _handleProfileSubmit(),
                  icon: _isProfileSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Lưu thay đổi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard(Color primary) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _passwordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thay đổi mật khẩu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Mật khẩu không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _isPasswordSubmitting
                      ? null
                      : () => _handlePasswordSubmit(),
                  icon: _isPasswordSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_reset),
                  label: const Text('Đổi mật khẩu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
