import 'package:flutter/material.dart';
import 'package:ui/components/model/report_model.dart';

class ReportsPanel extends StatelessWidget {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;
  final Future<void> Function(String id, bool resolved)? onStatusChange;
  final String? resolvingReportId;

  const ReportsPanel({
    super.key,
    required this.reports,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.onStatusChange,
    this.resolvingReportId,
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
    } else if (reports.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Chưa có phản ánh nào trong khu vực này.')),
      );
    } else {
      final fallback = DateTime.fromMillisecondsSinceEpoch(0);
      final sortedReports = [...reports]
        ..sort((a, b) => (b.createdAt ?? fallback).compareTo(a.createdAt ?? fallback));
      content = Column(
        children: [
          _buildHeaderRow(primaryColor),
          const Divider(height: 1),
          for (int i = 0; i < sortedReports.length; i++) ...[
            _buildDataRow(
              sortedReports[i],
              resolvingReportId == sortedReports[i].id,
            ),
            if (i != sortedReports.length - 1) const Divider(height: 1),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách phản ánh',
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
          _buildHeaderCell('Tiêu đề', flex: 2),
          _buildHeaderCell('Nội dung', flex: 3),
          _buildHeaderCell('Ngày tạo', flex: 2),
          _buildHeaderCell('Trạng thái', flex: 2),
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

  Widget _buildDataCell(Widget child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }

  Widget _buildDataRow(
    ReportModel report,
    bool isResolving,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _buildDataCell(
            Text(
              report.typeLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            flex: 2,
          ),
          _buildDataCell(Text(report.title), flex: 2),
          _buildDataCell(
            Text(
              report.content,
              overflow: TextOverflow.ellipsis,
            ),
            flex: 3,
          ),
          _buildDataCell(Text(report.createdDate), flex: 2),
          _buildDataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(report, isResolving),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ReportModel report, bool isResolving) {
    final resolved = report.resolved;
    final color = resolved ? Colors.green : Colors.amber;
    final label = isResolving
        ? 'Đang cập nhật...'
        : (resolved ? 'Đã xử lý' : 'Chờ xử lý');
    final canToggle = onStatusChange != null && !isResolving;

    return MouseRegion(
      cursor: canToggle ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: canToggle ? () => onStatusChange!(report.id, !report.resolved) : null,
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
