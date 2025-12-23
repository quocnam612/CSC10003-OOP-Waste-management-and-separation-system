import 'package:flutter/material.dart';

// 1. Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// 2. Import Models
import '../../../models/menu_item_model.dart';
import '../../../models/customer_model.dart'; // Để định nghĩa kiểu dữ liệu cho danh sách

import '../../auth/screens/auth_screen.dart';

// 3. Import Widgets con
import '../widgets/customer_panel.dart';
import '../widgets/customer_form.dart'; // Để hiển thị Dialog thêm mới
import '../widgets/manage_panel.dart';  // Quản lý nhân viên
import '../widgets/manager_home_widget.dart'; // Trang chủ Quản lý
import '../widgets/request_panel.dart'; // Yêu cầu
import '../widgets/task_panel.dart';    // Công việc

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _currentView = 'home';

  // --- DỮ LIỆU TĨNH ---
  final String _managerName = "Nguyễn Văn A";
  final String _managerRole = "Quản lý khu vực";

  final List<MenuItemModel> _managerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.dashboard),
    MenuItemModel(id: 'customer', title: 'Quản lý Cư dân', icon: Icons.people),
    MenuItemModel(id: 'manage', title: 'QL Nhân viên', icon: Icons.badge),
    MenuItemModel(id: 'request', title: 'Yêu cầu & Phản hồi', icon: Icons.assignment_late),
    MenuItemModel(id: 'task', title: 'Phân công việc', icon: Icons.map),
  ];

  // --- DỮ LIỆU KHÁCH HÀNG (Sử dụng CustomerModel) ---
  // Đây là nơi customer_model.dart được sử dụng
  final List<CustomerModel> _customers = [
    CustomerModel(id: '1', fullName: 'Lê Thị C', username: 'lethic', phone: '0901234567', area: 'Quận 1', createdDate: '20/12/2025', isActive: true),
    CustomerModel(id: '2', fullName: 'Trần Văn D', username: 'tranvand', phone: '0912345678', area: 'Quận 3', createdDate: '19/12/2025', isActive: false),
    CustomerModel(id: '3', fullName: 'Phạm K', username: 'phamk', phone: '0987654321', area: 'Bình Thạnh', createdDate: '18/12/2025', isActive: true),
  ];

  // --- HÀM XỬ LÝ DRAWER ---
  void _handleDrawerItem(String id) {
    Navigator.pop(context);
    if (id == 'logout') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (r) => false);
    } else {
      setState(() => _currentView = id);
    }
  }

  // --- HÀM XỬ LÝ KHÁCH HÀNG ---
  
  // 1. Xóa khách hàng
  void _handleDeleteCustomer(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text('Bạn có chắc chắn muốn xoá khách hàng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              setState(() => _customers.removeWhere((c) => c.id == id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá thành công')));
            },
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 2. Thêm khách hàng (Sử dụng CustomerFormDialog từ customer_form.dart)
  // Đây là nơi customer_form.dart được sử dụng
  void _handleCreateCustomer() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return CustomerFormDialog(
          onSubmit: (newCustomer) {
            setState(() => _customers.insert(0, newCustomer));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đã thêm mới: ${newCustomer.fullName}'), backgroundColor: Colors.green),
            );
          },
        );
      },
    );
  }

  // --- BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return const ManagerHomeWidget(); // Trang chủ Quản lý
      
      case 'customer':
        // Truyền dữ liệu và hàm xử lý vào Panel
        return CustomerPanel(
          customers: _customers,
          onDelete: _handleDeleteCustomer,
          onCreate: _handleCreateCustomer,
        );
        
      case 'manage':
        return const ManagePanel(); // Quản lý nhân viên
        
      case 'request':
        return const RequestPanel();
        
      case 'task':
        return const TaskPanel();
        
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "Tổng Quan";
    if (_currentView == 'customer') title = "Quản Lý Cư Dân";
    if (_currentView == 'manage') title = "Quản Lý Nhân Viên";
    if (_currentView == 'request') title = "Yêu Cầu & Khiếu Nại";
    if (_currentView == 'task') title = "Điều Phối Công Việc";

    return DashboardLayout(
      title: title,
      userName: _managerName,
      userRole: _managerRole,
      menuItems: _managerMenu,
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _handleDrawerItem('logout');
      },
      body: _buildBody(),
    );
  }
}