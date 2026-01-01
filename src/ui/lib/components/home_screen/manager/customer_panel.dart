import 'package:flutter/material.dart';
import 'package:ui/components/model/customer_model.dart';

class CustomerPanel extends StatelessWidget {
  final List<CustomerModel> customers;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;
  final Future<void> Function(String id, bool nextStatus)? onToggleStatus;
  final String? togglingUserId;

  const CustomerPanel({
    super.key,
    required this.customers,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.onToggleStatus,
    this.togglingUserId,
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
    } else if (customers.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Chưa có khách hàng nào trong khu vực này.')),
      );
    } else {
      content = Column(
        children: [
          _buildHeaderRow(primaryColor),
          const Divider(height: 1),
          for (int i = 0; i < customers.length; i++) ...[
            _buildDataRow(customers[i], primaryColor),
            if (i != customers.length - 1) const Divider(height: 1),
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
                    'Danh sách khách hàng',
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
  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataCell(Widget child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: child,
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
          _buildHeaderCell('Họ tên', flex: 3),
          _buildHeaderCell('Tên TK', flex: 2),
          _buildHeaderCell('SĐT', flex: 2),
          _buildHeaderCell('Ngày tạo', flex: 2),
          _buildHeaderCell('Trạng thái', flex: 2),
        ],
      ),
    );
  }

  Widget _buildDataRow(CustomerModel customer, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _buildDataCell(
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    customer.fullName.isNotEmpty ? customer.fullName[0].toUpperCase() : '?',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    customer.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            flex: 3,
          ),
          _buildDataCell(Text(customer.username), flex: 2),
          _buildDataCell(Text(customer.phone), flex: 2),
          _buildDataCell(Text(customer.createdDate), flex: 2),
          _buildDataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(
                customer,
                isUpdating: togglingUserId == customer.id,
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(CustomerModel customer, {required bool isUpdating}) {
    final isActive = customer.isActive;
    final color = isActive ? Colors.green : Colors.red;
    final label = isUpdating
        ? 'Đang cập nhật...'
        : (isActive ? 'Hoạt động' : 'Tạm dừng');
    final canToggle = onToggleStatus != null && !isUpdating;

    return MouseRegion(
      cursor: canToggle ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: canToggle ? () => onToggleStatus!(customer.id, !isActive) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
