import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/components/model/worker_model.dart';

class WorkerPanel extends StatelessWidget {
  final List<WorkerModel> workers;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function()? onRefresh;
  final Future<void> Function(String id, bool nextStatus)? onToggleStatus;
  final String? togglingUserId;
  final Future<void> Function(String workerId, int? teamId)? onTeamChanged;

  const WorkerPanel({
    super.key,
    required this.workers,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.onToggleStatus,
    this.togglingUserId,
    this.onTeamChanged,
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
    } else if (workers.isEmpty) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Chưa có nhân viên nào trong khu vực này.')),
      );
    } else {
      content = Column(
        children: [
          _buildHeaderRow(primaryColor),
          const Divider(height: 1),
          for (int i = 0; i < workers.length; i++) ...[
            _buildDataRow(workers[i], primaryColor),
            if (i != workers.length - 1) const Divider(height: 1),
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
                    'Danh sách nhân viên',
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
          _buildHeaderCell('Đội', flex: 1),
          _buildHeaderCell('Họ tên', flex: 3),
          _buildHeaderCell('Tên TK', flex: 2),
          _buildHeaderCell('SĐT', flex: 2),
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

  Widget _buildDataRow(WorkerModel worker, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _buildDataCell(_buildTeamInput(worker), flex: 1),
          _buildDataCell(
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    worker.fullName.isNotEmpty ? worker.fullName[0].toUpperCase() : '?',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    worker.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            flex: 3,
          ),
          _buildDataCell(Text(worker.username), flex: 2),
          _buildDataCell(Text(worker.phone), flex: 2),
          _buildDataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                worker.createdDate,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            flex: 2,
          ),
          _buildDataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(
                worker,
                isUpdating: togglingUserId == worker.id,
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(WorkerModel worker, {required bool isUpdating}) {
    final isActive = worker.isActive;
    final color = isActive ? Colors.green : Colors.red;
    final label = isUpdating
        ? 'Đang cập nhật...'
        : (isActive ? 'Hoạt động' : 'Tạm dừng');
    final canToggle = onToggleStatus != null && !isUpdating;

    return MouseRegion(
      cursor: canToggle ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: canToggle ? () => onToggleStatus!(worker.id, !isActive) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color,
              width: 0.5,
            ),
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

  Widget _buildTeamInput(WorkerModel worker) {
    final initialText = worker.team > 0 ? worker.team.toString() : '';
    final inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'^([1-9][0-9]{0,2})?$')),
    ];

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 60,
        child: TextFormField(
          initialValue: initialText,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            border: InputBorder.none,
          ),
          inputFormatters: inputFormatters,
          onChanged: onTeamChanged == null
              ? null
              : (value) {
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    onTeamChanged!(worker.id, null);
                  } else {
                    onTeamChanged!(worker.id, parsed);
                  }
                },
        ),
      ),
    );
  }
}
