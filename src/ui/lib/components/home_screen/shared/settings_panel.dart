import 'package:flutter/material.dart';
import 'package:ui/services/settings_api.dart';

class _RegionOption {
  const _RegionOption({required this.id, required this.name});

  final int id;
  final String name;
}

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
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isProfileSubmitting = false;
  bool _isPasswordSubmitting = false;
  int? _selectedRegion;
  List<_RegionOption> _regions = [];
  bool _isRegionsLoading = false;
  String? _regionError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _selectedRegion =
        widget.initialRegion > 0 ? widget.initialRegion : null;
    _loadRegions();
  }

  @override
  void didUpdateWidget(covariant AccountSettingsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName != widget.initialName) _nameController.text = widget.initialName;
    if (oldWidget.initialPhone != widget.initialPhone) _phoneController.text = widget.initialPhone;
    if (oldWidget.initialRegion != widget.initialRegion) {
      setState(() {
        _selectedRegion =
            widget.initialRegion > 0 ? widget.initialRegion : null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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

  Future<void> _loadRegions() async {
    setState(() {
      _isRegionsLoading = true;
      _regionError = null;
    });

    try {
      final rawRegions = await SettingsApi.fetchRegions(token: widget.authToken);
      if (!mounted) return;

      final regions = rawRegions
          .map((region) {
            final idValue = region['id'] ?? region['ID'];
            final nameValue = region['name'] ?? region['Name'];
            if (idValue == null || nameValue == null) return null;

            int? id;
            if (idValue is num) {
              id = idValue.toInt();
            } else if (idValue is String) {
              id = int.tryParse(idValue);
            }
            if (id == null) return null;

            return _RegionOption(id: id, name: nameValue.toString());
          })
          .whereType<_RegionOption>()
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        _regions = regions;
        if (_selectedRegion != null &&
            !_regions.any((region) => region.id == _selectedRegion)) {
          _selectedRegion = null;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _regionError = 'Không thể tải khu vực: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRegionsLoading = false;
        });
      }
    }
  }

  Future<void> _handleProfileSubmit() async {
    if (_profileFormKey.currentState?.validate() != true) return;
    final region = _selectedRegion;
    if (region == null) {
      _showSnack('Vui lòng chọn khu phố', isError: true);
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
      final trimmedName = _nameController.text.trim();
      final trimmedPhone = _phoneController.text.trim();

      await SettingsApi.updateProfile(
        username: widget.username,
        name: trimmedName,
        phone: trimmedPhone,
        region: region,
        token: token,
      );
      widget.onProfileUpdated?.call(trimmedName, trimmedPhone, region);
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

  Widget _buildRegionField() {
    if (_isRegionsLoading) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Phường',
          border: OutlineInputBorder(),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Đang tải danh sách phường...'),
          ],
        ),
      );
    }

    if (_regionError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Phường',
              border: OutlineInputBorder(),
            ),
            child: Text(
              _regionError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _loadRegions,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ),
        ],
      );
    }

    if (_regions.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Phường',
          border: OutlineInputBorder(),
        ),
        child: const Text('Chưa có dữ liệu phường'),
      );
    }

    return DropdownButtonFormField<int>(
      initialValue: _selectedRegion,
      decoration: const InputDecoration(
        labelText: 'Phường',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Vui lòng chọn phường'),
      isExpanded: true,
      items: _regions
          .map(
            (region) => DropdownMenuItem<int>(
              value: region.id,
              child: Text(region.name),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedRegion = value),
      validator: (value) => value == null ? 'Vui lòng chọn phường' : null,
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
              _buildRegionField(),
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
