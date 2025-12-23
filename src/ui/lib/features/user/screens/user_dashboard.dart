import 'package:flutter/material.dart';

// 1. Import Shared Layout
import '../../../shared/layout/dashboard_layout.dart';

// 2. Import Models
import '../../../models/menu_item_model.dart';

// 3. Import Auth
import '../../auth/screens/auth_screen.dart';

// 4. Import Các Widget Tính Năng
import '../widgets/feedback_panel.dart';            
import '../widgets/user_home_widget.dart';          
import '../widgets/collection_schedule_panel.dart'; 
import '../widgets/user_profile_panel.dart';        

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

  // --- DANH SÁCH MENU ---
  // Đã xóa "Hồ sơ cá nhân" ở đây để không bị trùng lặp
  final List<MenuItemModel> _residentMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'schedule', title: 'Lịch thu gom', icon: Icons.calendar_month),
    MenuItemModel(id: 'feedback', title: 'Gửi phản hồi', icon: Icons.rate_review),
  ];

  // --- XỬ LÝ SỰ KIỆN MENU ---
  void _handleDrawerItem(String id) {
    Navigator.pop(context); // Đóng drawer
    
    if (id == 'logout') {
      _performLogout();
    } else if (id == 'setting') {
      // Khi bấm nút "Cài đặt" ở góc dưới -> Mở trang Profile
      setState(() => _currentView = 'profile');
    } else {
      setState(() => _currentView = id);
    }
  }

  // Xử lý khi bấm Avatar góc trên phải
  void _handleProfileSelect(String value) {
    if (value == 'logout') {
      _performLogout();
    } else if (value == 'edit' || value == 'detail') {
      setState(() => _currentView = 'profile');
    }
  }

  void _performLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // --- ĐIỀU HƯỚNG MÀN HÌNH ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return UserHomeWidget(userName: _userName);
      
      case 'schedule':
        return const CollectionSchedulePanel();

      case 'feedback':
        return const FeedbackPanel();
        
      case 'profile': 
      case 'setting': // Cả setting và profile đều trỏ về đây
        return const UserProfilePanel();
        
      default:
        return UserHomeWidget(userName: _userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đặt tiêu đề tương ứng
    String title = 'Trang Chủ Cư Dân';
    if (_currentView == 'schedule') title = 'Lịch Trình Thu Gom';
    if (_currentView == 'feedback') title = 'Gửi Phản Hồi';
    if (_currentView == 'profile' || _currentView == 'setting') title = 'Hồ Sơ Cá Nhân';

    return DashboardLayout(
      title: title,
      
      userName: _userName,
      userRole: _userRole,
      menuItems: _residentMenu,
      
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: _handleProfileSelect,
      
      body: _buildBody(),
    );
  }
}