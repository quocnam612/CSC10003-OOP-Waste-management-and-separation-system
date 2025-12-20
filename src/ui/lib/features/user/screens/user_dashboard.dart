import 'package:flutter/material.dart';

// 1. Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// 2. Import Models
import '../../../models/menu_item_model.dart';

// 3. Import Auth
import '../../auth/screens/auth_screen.dart';

// 4. Import Widget Feedback
import '../widgets/feedback_panel.dart';

class ResidentDashboard extends StatefulWidget {
  const ResidentDashboard({super.key});

  @override
  State<ResidentDashboard> createState() => _ResidentDashboardState();
}

class _ResidentDashboardState extends State<ResidentDashboard> {
  String _currentView = 'home';

  // --- DỮ LIỆU TĨNH ---
  final String _userName = "Lê Thị C";
  final String _userRole = "Cư dân";

  final List<MenuItemModel> _residentMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'feedback', title: 'Gửi phản hồi', icon: Icons.rate_review),
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

  // --- BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        // Có thể thay bằng widget hiển thị thông tin rác, lịch thu gom...
        return const DefaultDashboardBody();
      
      case 'feedback':
        return const FeedbackPanel();
        
      case 'setting':
        return const Center(child: Text("Cài đặt cá nhân"));
        
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: _currentView == 'feedback' ? 'Gửi Phản Hồi' : 'Trang Chủ Cư Dân',
      
      userName: _userName,
      userRole: _userRole,
      menuItems: _residentMenu,
      
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _performLogout();
      },
      
      body: _buildBody(),
    );
  }
}