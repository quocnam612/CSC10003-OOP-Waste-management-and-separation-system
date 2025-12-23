import 'package:flutter/material.dart';

// 1. Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// 2. Import Models
import '../../../models/menu_item_model.dart';

// 3. Import Auth
import '../../auth/screens/auth_screen.dart';

// 4. Import Widgets của Worker
import '../widgets/chekin_panel.dart';
import '../widgets/task_panel.dart';
import '../widgets/worker_route_panel.dart';   // <--- MỚI
import '../widgets/worker_history_panel.dart'; // <--- MỚI
import '../widgets/worker_profile_panel.dart'; // <--- MỚI

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  String _currentView = 'task'; // Mặc định vào xem công việc

  final String _workerName = "Trần Văn B";
  final String _workerRole = "Nhân viên thu gom";

  // Menu chức năng cho Worker
  final List<MenuItemModel> _workerMenu = const [
    MenuItemModel(id: 'attendance', title: 'Điểm danh', icon: Icons.access_time_filled),
    MenuItemModel(id: 'task', title: 'Danh sách việc', icon: Icons.checklist),
    MenuItemModel(id: 'route', title: 'Bản đồ lộ trình', icon: Icons.map),      // Mới
    MenuItemModel(id: 'history', title: 'Lịch sử', icon: Icons.history),        // Mới
    MenuItemModel(id: 'profile', title: 'Hồ sơ', icon: Icons.person),           // Mới
  ];

  // Dữ liệu công việc (Giữ nguyên logic cũ)
  final List<Map<String, dynamic>> _tasks = [
    {'id': 101, 'area': '123 Nguyễn Huệ, Q.1', 'status': 'Chưa làm', 'assignedTime': '07:30', 'completedTime': null},
    {'id': 102, 'area': '45 Lê Lợi, Q.1', 'status': 'Đang làm', 'assignedTime': '08:00', 'completedTime': null},
    {'id': 103, 'area': '10 Pasteur, Q.3', 'status': 'Hoàn thành', 'assignedTime': '08:45', 'completedTime': '09:20'},
  ];

  // --- HANDLERS ---
  void _handleDrawerItem(String id) {
    Navigator.pop(context);
    if (id == 'logout') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (r) => false);
    } else {
      setState(() => _currentView = id);
    }
  }

  void _handleTaskStatusChange(int id, String newStatus) {
    setState(() {
      final index = _tasks.indexWhere((t) => t['id'] == id);
      if (index != -1) {
        _tasks[index]['status'] = newStatus;
        _tasks[index]['completedTime'] = (newStatus == 'Hoàn thành') 
            ? "${DateTime.now().hour}:${DateTime.now().minute}" : null;
      }
    });
  }

  // --- BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'attendance':
        return CheckinPanel(onCheckIn: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã điểm danh!')));
        });

      case 'task':
        return TaskPanel(tasks: _tasks, onStatusChanged: _handleTaskStatusChange);

      case 'route':
        return const WorkerRoutePanel(); // Widget mới

      case 'history':
        return const WorkerHistoryPanel(); // Widget mới

      case 'profile':
      case 'setting': // Nút cài đặt cũng dẫn về hồ sơ
        return const WorkerProfilePanel(); // Widget mới

      default:
        return TaskPanel(tasks: _tasks, onStatusChanged: _handleTaskStatusChange);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đổi tiêu đề Appbar theo trang
    String title = "Danh Sách Công Việc";
    if (_currentView == 'attendance') title = "Điểm Danh Đầu Ca";
    if (_currentView == 'route') title = "Lộ Trình Thu Gom";
    if (_currentView == 'history') title = "Lịch Sử Hoạt Động";
    if (_currentView == 'profile') title = "Hồ Sơ Nhân Viên";

    return DashboardLayout(
      title: title,
      userName: _workerName,
      userRole: _workerRole,
      menuItems: _workerMenu,
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _handleDrawerItem('logout');
        if (val == 'edit') setState(() => _currentView = 'profile');
      },
      body: _buildBody(),
    );
  }
}