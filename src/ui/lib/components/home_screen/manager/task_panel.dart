import 'package:flutter/material.dart';
import 'package:ui/components/model/service_request_model.dart';
import 'package:ui/components/model/route_model.dart';

class ManagerTaskPanel extends StatelessWidget {
  final List<ServiceRequestModel> services;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;
  final List<RouteModel> routes;
  final List<int> availableTeams;
  final bool isRoutesLoading;
  final String? routesErrorMessage;
  final Future<void> Function()? onRoutesRefresh;
  final Future<void> Function(RouteCreationData data)? onCreateRoute;
  final bool isCreatingRoute;

  const ManagerTaskPanel({
    super.key,
    required this.services,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.routes = const [],
    this.availableTeams = const [],
    this.isRoutesLoading = false,
    this.routesErrorMessage,
    this.onRoutesRefresh,
    this.onCreateRoute,
    this.isCreatingRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final availableDistricts = services
        .map((service) => service.district.trim())
        .where((district) => district.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    final Map<String, List<String>> districtAddresses = {};
    for (final service in services) {
      final district = service.district.trim();
      final address = service.address.trim();
      if (district.isEmpty || address.isEmpty) continue;
      final list = districtAddresses.putIfAbsent(district, () => <String>[]);
      if (!list.contains(address)) {
        list.add(address);
      }
    }
    for (final entry in districtAddresses.entries) {
      entry.value.sort((a, b) => a.compareTo(b));
    }

    Widget content;
    if (isLoading) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (errorMessage != null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (services.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text('Chưa có đăng ký dịch vụ nào trong khu vực của bạn.'),
        ),
      );
    } else {
      content = Column(
        children: [
          _buildHeaderRow(primaryColor),
          const Divider(height: 1),
          for (int i = 0; i < services.length; i++) ...[
            _buildDataRow(services[i]),
            if (i != services.length - 1) const Divider(height: 1),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          _buildCard(
            context,
            title: 'Công việc khu vực',
            onRefresh: onRefresh,
            isLoading: isLoading,
            child: content,
          ),
          const SizedBox(height: 20),
          _buildRoutePanel(
            context,
            primaryColor,
            routes: routes,
            availableDistricts: availableDistricts,
            addressesByDistrict: districtAddresses,
            isRoutesLoading: isRoutesLoading,
            routesErrorMessage: routesErrorMessage,
            onRoutesRefresh: onRoutesRefresh,
            onCreateRoute: onCreateRoute,
            isCreatingRoute: isCreatingRoute,
            availableTeams: availableTeams,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Loại', flex: 2),
          _buildHeaderCell('Khu phố', flex: 2),
          _buildHeaderCell('Địa chỉ', flex: 3),
          _buildHeaderCell('Ngày tạo', flex: 2),
          _buildHeaderCell('Ghi chú', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataRow(ServiceRequestModel service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _buildDataCell(
            const Text(
              'Thu gom rác tại nhà',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            flex: 2,
          ),
          _buildDataCell(Text(service.district.isEmpty ? '--' : service.district), flex: 2),
          _buildDataCell(
            Text(
              service.address.isEmpty ? '--' : service.address,
              overflow: TextOverflow.ellipsis,
            ),
            flex: 3,
          ),
          _buildDataCell(Text(service.createdAt), flex: 2),
          _buildDataCell(
            Text(
              service.note.isEmpty ? '--' : service.note,
              overflow: TextOverflow.ellipsis,
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required Widget child,
    Future<void> Function()? onRefresh,
    bool isLoading = false,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Tải lại',
                  onPressed: isLoading ? null : onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildRoutePanel(
    BuildContext context,
    Color primaryColor, {
    required List<RouteModel> routes,
    required List<String> availableDistricts,
    required Map<String, List<String>> addressesByDistrict,
    required List<int> availableTeams,
    required bool isRoutesLoading,
    required String? routesErrorMessage,
    required Future<void> Function()? onRoutesRefresh,
    required Future<void> Function(RouteCreationData data)? onCreateRoute,
    required bool isCreatingRoute,
  }) {
    return _buildCard(
      context,
      title: 'Tuyến đường',
      onRefresh: onRoutesRefresh,
      isLoading: isRoutesLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: FilledButton.icon(
              onPressed: (isCreatingRoute || onCreateRoute == null)
                  ? null
                  : () => _handleAddRoute(
                        context,
                        onCreateRoute,
                        availableDistricts,
                        addressesByDistrict,
                        availableTeams,
                      ),
              icon: isCreatingRoute
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.add),
              label: Text(isCreatingRoute ? 'Đang lưu...' : 'Thêm tuyến'),
            ),
          ),
          const SizedBox(height: 12),
          _buildRoutesContent(
            primaryColor,
            routes,
            isRoutesLoading,
            routesErrorMessage,
            onRoutesRefresh,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesContent(
    Color primaryColor,
    List<RouteModel> routes,
    bool isRoutesLoading,
    String? routesErrorMessage,
    Future<void> Function()? onRoutesRefresh,
  ) {
    if (isRoutesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (routesErrorMessage != null) {
      return Text(
        routesErrorMessage,
        style: const TextStyle(color: Colors.red),
      );
    }

    if (routes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Chưa có tuyến đường nào được tạo cho khu vực của bạn.'),
      );
    }

    return Column(
      children: routes
          .map(
            (route) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildRouteCard(route),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRouteCard(RouteModel route) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          route.district.isEmpty ? 'Tuyến chưa đặt tên' : route.district,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text('Ca làm: ${route.shift.isEmpty ? '--' : route.shift}'),
        const SizedBox(height: 4),
        Text(route.team > 0 ? 'Đội phụ trách: ${route.team}' : 'Chưa phân đội'),
        if (route.stops.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Các điểm thu gom:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          ...List.generate(route.stops.length, (index) {
            final stop = route.stops[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. '),
                  Expanded(child: Text(stop)),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Future<void> _handleAddRoute(
    BuildContext context,
    Future<void> Function(RouteCreationData data) onCreateRoute,
    List<String> availableDistricts,
    Map<String, List<String>> addressesByDistrict,
    List<int> availableTeams,
  ) async {
    final newRoute = await _openCreateRouteDialog(
      context,
      availableDistricts,
      addressesByDistrict,
      availableTeams,
    );
    if (newRoute == null) return;
    await onCreateRoute(newRoute);
  }

  Future<RouteCreationData?> _openCreateRouteDialog(
    BuildContext context,
    List<String> availableDistricts,
    Map<String, List<String>> addressesByDistrict,
    List<int> availableTeams,
  ) async {
    final districtController = TextEditingController();
    final shiftController = TextEditingController();
    final teamController = TextEditingController();
    final stopsControllers = <TextEditingController>[];
    final selectedStops = <String?>[];
    final formKey = GlobalKey<FormState>();
    String? selectedDistrict =
        availableDistricts.isNotEmpty ? availableDistricts.first : null;
    int? selectedTeam;

    final result = await showDialog<RouteCreationData>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Tạo tuyến đường',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (availableDistricts.isNotEmpty)
                          DropdownButtonFormField<String>(
                            value: selectedDistrict,
                            items: availableDistricts
                                .map(
                                  (district) => DropdownMenuItem<String>(
                                    value: district,
                                    child: Text(district),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: 'Khu phố/Đường',
                            ),
                            hint: const Text('Chọn khu phố'),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedDistrict = value;
                                selectedStops
                                  ..clear()
                                  ..add(null);
                                for (final controller in stopsControllers) {
                                  controller.clear();
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng chọn khu phố';
                              }
                              return null;
                            },
                          )
                        else
                          TextFormField(
                            controller: districtController,
                            decoration: const InputDecoration(
                              labelText: 'Khu phố/Đường',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập khu phố hoặc tên tuyến';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: shiftController,
                          decoration: const InputDecoration(
                            labelText: 'Ca thu gom',
                            hintText: 'Ví dụ: 05:30 - 08:30',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập ca thu gom';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (availableTeams.isNotEmpty)
                          DropdownButtonFormField<int>(
                            value: selectedTeam,
                            items: availableTeams
                                .map(
                                  (team) => DropdownMenuItem<int>(
                                    value: team,
                                    child: Text('Đội $team'),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: 'Đội phụ trách',
                            ),
                            hint: const Text('Chọn đội phụ trách'),
                            onChanged: (value) {
                              setDialogState(() => selectedTeam = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Vui lòng chọn đội phụ trách';
                              }
                              return null;
                            },
                          )
                        else
                          TextFormField(
                            controller: teamController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Đội phụ trách',
                              hintText: 'Nhập số đội',
                            ),
                            validator: (value) {
                              final parsed = int.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Vui lòng nhập số đội hợp lệ';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Các điểm thu gom',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (_) {
                            final addresses = (selectedDistrict != null)
                                ? (addressesByDistrict[selectedDistrict!] ?? const <String>[])
                                : const <String>[];
                            final hasAddressOptions = addresses.isNotEmpty;

                            if (availableDistricts.isNotEmpty && selectedDistrict == null) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('Vui lòng chọn khu phố để hiển thị địa chỉ.'),
                              );
                            }

                            if (hasAddressOptions) {
                              return Column(
                                children: List.generate(
                                  selectedStops.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField<String>(
                                            value: selectedStops[index],
                                            decoration: const InputDecoration(
                                              labelText: 'Điểm',
                                            ),
                                            items: addresses
                                                .where(
                                                  (address) =>
                                                      !selectedStops.contains(address) ||
                                                      selectedStops[index] == address,
                                                )
                                                .map(
                                                  (address) => DropdownMenuItem<String>(
                                                    value: address,
                                                    child: Text(address),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setDialogState(() {
                                                selectedStops[index] = value;
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Vui lòng chọn địa chỉ';
                                              }
                                              final duplicates = selectedStops
                                                  .where((stop) => stop == value)
                                                  .length;
                                              if (duplicates > 1) {
                                                return 'Địa chỉ đã được chọn';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        if (selectedStops.length > 1)
                                          IconButton(
                                            tooltip: 'Xóa điểm',
                                            onPressed: () {
                                              setDialogState(() {
                                                selectedStops.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.close),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: List.generate(
                                stopsControllers.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: stopsControllers[index],
                                          decoration: const InputDecoration(
                                            labelText: 'Điểm',
                                          ),
                                          validator: (value) {
                                            if (index == 0 &&
                                                (value == null || value.trim().isEmpty)) {
                                              return 'Nhập tối thiểu 1 địa điểm';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      if (stopsControllers.length > 1)
                                        IconButton(
                                          tooltip: 'Xóa điểm',
                                          onPressed: () {
                                            setDialogState(() {
                                              final removed = stopsControllers.removeAt(index);
                                              removed.dispose();
                                            });
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              final addresses = (selectedDistrict != null)
                                  ? (addressesByDistrict[selectedDistrict!] ?? const <String>[])
                                  : const <String>[];
                              if (addresses.isNotEmpty) {
                                setDialogState(() {
                                  selectedStops.add(null);
                                });
                              } else {
                                setDialogState(() {
                                  stopsControllers.add(TextEditingController());
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm điểm thu gom'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          final addresses = (selectedDistrict != null)
                              ? (addressesByDistrict[selectedDistrict!] ?? const <String>[])
                              : const <String>[];
                          final stops = addresses.isNotEmpty
                              ? selectedStops
                                  .whereType<String>()
                                  .map((text) => text.trim())
                                  .where((text) => text.isNotEmpty)
                                  .toList()
                              : stopsControllers
                                  .map((controller) => controller.text.trim())
                                  .where((text) => text.isNotEmpty)
                                  .toList();
                          final districtValue =
                              selectedDistrict ?? districtController.text.trim();
                          final teamValue = selectedTeam ??
                              int.tryParse(teamController.text.trim()) ??
                              0;
                          Navigator.of(dialogContext).pop(
                            RouteCreationData(
                              district: districtValue,
                              shift: shiftController.text.trim(),
                              team: teamValue,
                              stops: stops,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Tạo tuyến'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      districtController.dispose();
      shiftController.dispose();
      teamController.dispose();
      for (final controller in stopsControllers) {
        controller.dispose();
      }
    });

    return result;
  }
}
