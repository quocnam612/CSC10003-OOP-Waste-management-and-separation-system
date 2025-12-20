import 'package:flutter/material.dart';

// 1. Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// 2. Import Models
import '../../../models/menu_item_model.dart';

// 3. Import Auth
import '../../auth/screens/auth_screen.dart';

// 4. Import Widgets con
import '../widgets/chekin_panel.dart';
import '../widgets/task_panel.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  String _currentView = 'home';

  // --- DỮ LIỆU TĨNH ---
  final String _workerName = "Trần Văn B";
  final String _workerRole = "Nhân viên thu gom";

  final List<MenuItemModel> _workerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'attendance', title: 'Điểm danh', icon: Icons.access_time_filled),
    MenuItemModel(id: 'task', title: 'Công việc', icon: Icons.task),
  ];

  // --- DỮ LIỆU CÔNG VIỆC (ID giữ nguyên nhập thủ công/cố định từ data) ---
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 101, // ID thủ công
      'area': '123 Nguyễn Huệ, P. Bến Nghé, Quận 1', 
      'status': 'Chưa làm', 
      'assignedTime': '07:30', 
      'completedTime': null
    },
    {
      'id': 102, 
      'area': '45 Lê Lợi, P. Bến Thành, Quận 1', 
      'status': 'Đang làm', 
      'assignedTime': '08:00', 
      'completedTime': null
    },
    {
      'id': 103, 
      'area': '10 Pasteur, P.6, Quận 3', 
      'status': 'Hoàn thành', 
      'assignedTime': '08:45', 
      'completedTime': '09:20'
    },
    {
      'id': 105, 
      'area': 'Chợ Bến Thành (Cửa Bắc)', 
      'status': 'Chưa làm', 
      'assignedTime': '10:00', 
      'completedTime': null
    },
  ];

  // --- ACTION HANDLERS ---
  
  void _handleDrawerItem(String id) {
    Navigator.pop(context);
    if (id == 'logout') {
      _performLogout();
    } else {
      setState(() => _currentView = id);
    }
  }

  void _performLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _handleCheckInAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Điểm danh thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Logic cập nhật trạng thái
  void _handleTaskStatusChange(int id, String newStatus) {
    setState(() {
      final index = _tasks.indexWhere((t) => t['id'] == id);
      if (index != -1) {
        _tasks[index]['status'] = newStatus;
        if (newStatus == 'Hoàn thành') {
          final now = DateTime.now();
          _tasks[index]['completedTime'] = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
        } else {
          _tasks[index]['completedTime'] = null;
        }
      }
    });
  }

  // --- WIDGET PROGRESS BAR (THANH TIẾN ĐỘ) ---
  Widget _buildProgressBar() {
    int total = _tasks.length;
    int completed = _tasks.where((t) => t['status'] == 'Hoàn thành').length;
    double percent = total == 0 ? 0 : completed / total;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tiến độ hôm nay",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Thanh Linear Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
          ),
          
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Đã xong: $completed", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w500)),
              Text("Tổng giao: $total", style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  // --- BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return const DefaultDashboardBody();
      
      case 'attendance':
        return CheckinPanel(onCheckIn: _handleCheckInAction);
        
      case 'task':
        // Cấu trúc mới: Cột chứa Progress Bar + List Công việc
        return Column(
          children: [
            // 1. Thanh tiến độ (Cố định ở trên)
            _buildProgressBar(),
            
            // 2. Danh sách công việc (Cuộn ở dưới)
            Expanded(
              child: TaskPanel(
                tasks: _tasks,
                onStatusChanged: _handleTaskStatusChange,
              ),
            ),
          ],
        );
        
      case 'setting':
        return const Center(child: Text("Màn hình Cài đặt"));
        
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: _currentView == 'attendance' ? 'Điểm Danh' : 
             _currentView == 'task' ? 'Danh Sách Việc' : 'Nhân Viên',
      
      userName: _workerName,
      userRole: _workerRole,
      menuItems: _workerMenu,
      
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _performLogout();
      },
      
      body: _buildBody(),
    );
  }
}