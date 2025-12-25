import 'package:flutter/material.dart';
import 'package:ui/components/home_screen/home_layout.dart';
import '../../screens/auth_screen.dart';

import 'package:ui/components/model/menu_item_model.dart';
import 'package:ui/components/model/customer_model.dart';

import 'package:ui/components/home_screen/manager/customer_panel.dart';
import 'package:ui/components/home_screen/manager/customer_form.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _currentView = 'home';

  // --- A. DỮ LIỆU TĨNH ---
  final String _managerName = "Nguyễn Văn A";
  final String _managerRole = "Quản lý khu vực";

  final List<MenuItemModel> _managerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'customer', title: 'Khách hàng', icon: Icons.people),
    MenuItemModel(id: 'manage', title: 'Quản lí', icon: Icons.manage_accounts),
    MenuItemModel(id: 'request', title: 'Yêu cầu', icon: Icons.assignment),
    MenuItemModel(id: 'task', title: 'Công việc', icon: Icons.task_alt),
  ];

  // --- B. DỮ LIỆU KHÁCH HÀNG ---
  final List<CustomerModel> _customers = [
    CustomerModel(id: '1', fullName: 'Nguyễn Văn A', username: 'nguyenvana', phone: '0901234567', area: 'Quận 1', createdDate: '20/12/2025', isActive: true),
    CustomerModel(id: '2', fullName: 'Trần Thị B', username: 'tranthib', phone: '0912345678', area: 'Quận 3', createdDate: '19/12/2025', isActive: false),
    CustomerModel(id: '3', fullName: 'Lê Văn C', username: 'levanc', phone: '0987654321', area: 'Bình Thạnh', createdDate: '18/12/2025', isActive: true),
  ];

  // --- C. CÁC HÀM XỬ LÝ ---

  void _handleDrawerItem(String id) {
    Navigator.pop(context); // Đóng Drawer
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

  // --- D. BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        // Sử dụng DefaultDashboardBody từ Layout chung
        return const DefaultDashboardBody();
      
      case 'customer':
        return CustomerPanel(
          customers: _customers,
          onDelete: _handleDeleteCustomer,
          onCreate: _handleCreateCustomer,
        );
        
      case 'manage':
        return const Center(child: Text("Màn hình Quản lý (Đang phát triển)"));
      case 'request':
        return const Center(child: Text("Màn hình Yêu cầu (Đang phát triển)"));
      case 'task':
        return const Center(child: Text("Màn hình Nhiệm vụ (Đang phát triển)"));
      case 'setting':
        return const Center(child: Text("Màn hình Cài đặt (Đang phát triển)"));
      
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    // QUAN TRỌNG: Không dùng Scaffold nữa, dùng DashboardLayout
    return DashboardLayout(
      title: _currentView == 'home' ? 'Dashboard' : 
             _currentView == 'customer' ? 'Quản lý Khách Hàng' : 'Quản Lý',
      
      // Dữ liệu truyền vào Layout
      userName: _managerName,
      userRole: _managerRole,
      menuItems: _managerMenu,
      
      // Hàm callback
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _performLogout();
      },
      
      // Nội dung chính
      body: _buildBody(),
    );
  }
}