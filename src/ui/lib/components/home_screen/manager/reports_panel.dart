import 'package:flutter/material.dart';
import 'package:ui/components/model/report_model.dart';

class ReportsPanel extends StatelessWidget {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;
  final Future<void> Function(String id)? onResolve;
  final String? resolvingReportId;

  const ReportsPanel({
    super.key,
    required this.reports,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.onResolve,
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
      content = Column(
        children: [
          for (int i = 0; i < reports.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == reports.length - 1 ? 0 : 12),
              child: _ReportCard(
                report: reports[i],
                primaryColor: primaryColor,
                onResolve: onResolve,
                isResolving: resolvingReportId == reports[i].id,
              ),
            ),
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
}

class _ReportCard extends StatelessWidget {
  final ReportModel report;
  final Color primaryColor;
  final Future<void> Function(String id)? onResolve;
  final bool isResolving;

  const _ReportCard({
    required this.report,
    required this.primaryColor,
    this.onResolve,
    this.isResolving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: report.resolved ? Colors.green : Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.typeLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      report.title,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              if (!report.resolved && onResolve != null)
                TextButton(
                  onPressed: isResolving ? null : () => onResolve!(report.id),
                  child: Text(
                    isResolving ? 'Đang cập nhật...' : 'Đánh dấu đã xử lý',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.content,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                report.createdDate,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
