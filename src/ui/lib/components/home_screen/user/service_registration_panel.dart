import 'package:flutter/material.dart';
import 'package:ui/services/service_request_api.dart';
import 'package:ui/services/settings_api.dart';

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
  String? _selectedDistrict;
  bool _isSubmitting = false;
  bool _isDistrictsLoading = false;
  String? _districtsError;
  List<String> _districts = const [];

  final List<String> _services = const [
    'Thu gom rác tại nhà',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = _services.first;
    if (widget.userRegion > 0) {
      _loadDistricts();
    } else {
      _districtsError = 'Vui lòng cập nhật phường trong phần Cài đặt.';
    }
  }

  @override
  void didUpdateWidget(covariant ServiceRegistrationPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userRegion == widget.userRegion) return;
    if (widget.userRegion > 0) {
      _loadDistricts();
    } else {
      setState(() {
        _districts = const [];
        _selectedDistrict = null;
        _districtsError = 'Vui lòng cập nhật phường trong phần Cài đặt.';
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (widget.userRegion <= 0) {
      _showSnack('Vui lòng cập nhật phường trong phần Cài đặt để sử dụng tính năng này.', isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      _showSnack('Vui lòng chọn dịch vụ', isError: true);
      return;
    }
    if (_selectedDistrict == null) {
      _showSnack('Vui lòng chọn khu phố', isError: true);
      return;
    }
    final token = widget.authToken;
    if (token == null || token.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.', isError: true);
      return;
    }

    final address = _addressController.text.trim();
    final note = _noteController.text.trim();

    setState(() => _isSubmitting = true);
    try {
      await ServiceRequestApi.createRequest(
        district: _selectedDistrict!,
        address: address,
        note: note.isEmpty ? null : note,
        token: token,
      );

      if (!mounted) return;
      _showSnack('Dịch vụ đã được đăng ký thành công.');
      _formKey.currentState!.reset();
      setState(() {
        _selectedService = _services.first;
        _selectedDistrict = null;
      });
      _addressController.clear();
      _noteController.clear();
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể đăng ký dịch vụ: $error', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _loadDistricts() async {
    if (widget.userRegion <= 0) {
      setState(() {
        _districts = const [];
        _selectedDistrict = null;
        _districtsError = 'Vui lòng cập nhật phường trong phần Cài đặt.';
        _isDistrictsLoading = false;
      });
      return;
    }

    setState(() {
      _isDistrictsLoading = true;
      _districtsError = null;
    });

    try {
      final rawRegions = await SettingsApi.fetchRegions(token: widget.authToken);
      Map<String, dynamic>? matchedRegion;

      for (final region in rawRegions) {
        final dynamic regionId = region['id'] ?? region['ID'];
        final int? normalizedId = regionId is int
            ? regionId
            : regionId is String
                ? int.tryParse(regionId)
                : null;
        if (normalizedId == widget.userRegion) {
          matchedRegion = region;
          break;
        }
      }

      List<String> districtsList = const [];
      String? loadError;

      if (matchedRegion == null) {
        loadError = 'Không tìm thấy khu phố cho khu vực đã chọn.';
      } else {
        final dynamic districts = matchedRegion['districts'] ?? matchedRegion['district'];
        if (districts is List) {
          final districtSet = <String>{};
          for (final district in districts) {
            if (district is String && district.trim().isNotEmpty) {
              districtSet.add(district.trim());
            }
          }
          districtsList = districtSet.toList()..sort();
        } else {
          loadError = 'Dữ liệu khu phố không hợp lệ.';
        }
      }

      if (!mounted) return;
      setState(() {
        _districts = districtsList;
        _districtsError = loadError;
        if (!_districts.contains(_selectedDistrict)) _selectedDistrict = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _districtsError = error.toString();
      });
      _showSnack('Không thể tải danh sách khu phố', isError: true);
    } finally {
      if (!mounted) return;
      setState(() => _isDistrictsLoading = false);
    }
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
    final bool requiresRegionUpdate = widget.userRegion <= 0;
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
                    DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      decoration: InputDecoration(
                        labelText: 'Khu phố',
                        prefixIcon: const Icon(Icons.location_city),
                        suffixIcon: _isDistrictsLoading
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                        helperText: requiresRegionUpdate
                            ? 'Vui lòng cập nhật phường trong phần Cài đặt.'
                            : (_districtsError != null
                                ? 'Không thể tải khu phố cho khu vực này.'
                                : (_districts.isEmpty ? 'Chưa có dữ liệu khu phố.' : null)),
                      ),
                      items: _districts
                          .map((district) => DropdownMenuItem<String>(
                                value: district,
                                child: Text(district),
                              ))
                          .toList(),
                      onChanged: (_isDistrictsLoading || _districts.isEmpty || requiresRegionUpdate)
                          ? null
                          : (value) => setState(() => _selectedDistrict = value),
                      validator: (value) {
                        if (requiresRegionUpdate) return 'Vui lòng cập nhật phường';
                        if (_isDistrictsLoading) return 'Đang tải khu phố';
                        if (_districtsError != null) return 'Không thể tải khu phố cho khu vực này';
                        if (_districts.isEmpty) return 'Chưa có dữ liệu khu phố';
                        return value == null ? 'Vui lòng chọn khu phố' : null;
                      },
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
                      onPressed: (_isSubmitting || requiresRegionUpdate) ? null : _handleSubmit,
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
          ),
        ],
      ),
    );
  }
}
