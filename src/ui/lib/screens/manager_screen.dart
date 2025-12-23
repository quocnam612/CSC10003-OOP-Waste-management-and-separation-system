import 'package:flutter/material.dart';

// Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// Import Models
import '../../../models/menu_item_model.dart';
import '../../../models/customer_model.dart';

// Import Widgets con
import '../features/manager/widgets/customer_panel.dart';
import '../features/manager/widgets/customer_form.dart';
import '../features/auth/screens/auth_screen.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _currentView = 'home';

  // Dữ liệu tĩnh
  final String _managerName = "Nguyễn Văn A";
  final String _managerRole = "Quản lý khu vực";

  final List<MenuItemModel> _managerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'customer', title: 'Khách hàng', icon: Icons.people),
    MenuItemModel(id: 'manage', title: 'Quản lí', icon: Icons.manage_accounts),
    MenuItemModel(id: 'request', title: 'Yêu cầu', icon: Icons.assignment),
    MenuItemModel(id: 'task', title: 'Công việc', icon: Icons.task_alt),
  ];

  // Dữ liệu khách hàng
  final List<CustomerModel> _customers = [
    CustomerModel(id: '1', fullName: 'Nguyễn Văn A', username: 'nguyenvana', phone: '0901234567', area: 'Quận 1', createdDate: '20/12/2025', isActive: true),
    CustomerModel(id: '2', fullName: 'Trần Thị B', username: 'tranthib', phone: '0912345678', area: 'Quận 3', createdDate: '19/12/2025', isActive: false),
  ];

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

  void _handleDeleteCustomer(String id) {
     setState(() {
       _customers.removeWhere((c) => c.id == id);
     });
  }

  void _handleCreateCustomer() {
  }

  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return const DefaultDashboardBody();
      case 'customer':
        return CustomerPanel(
          customers: _customers,
          onDelete: _handleDeleteCustomer,
          onCreate: _handleCreateCustomer,
        );
      case 'manage':
        return const Center(child: Text("Màn hình Quản lý"));
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    // SỬ DỤNG DASHBOARD LAYOUT
    return DashboardLayout(
      title: 'Quản Lý Khu Vực',
      userName: _managerName,       
      userRole: _managerRole,      
      menuItems: _managerMenu,      
      
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _performLogout();
      },
      
      body: _buildBody(),
    );
  }
}