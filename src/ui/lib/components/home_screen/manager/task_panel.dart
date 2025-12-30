import 'package:flutter/material.dart';
import 'package:ui/components/model/service_request_model.dart';

class ManagerTaskPanel extends StatelessWidget {
  final List<ServiceRequestModel> services;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;

  const ManagerTaskPanel({
    super.key,
    required this.services,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

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
      child: Card(
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
                  const Text(
                    'Công việc khu vực',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    tooltip: 'Tải lại',
                    onPressed: isLoading ? null : onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              content,
            ],
          ),
        ),
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
}
