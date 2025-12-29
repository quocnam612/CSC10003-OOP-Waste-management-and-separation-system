import 'package:flutter/material.dart';
import 'package:ui/components/home_screen/shared/home_layout.dart';
import 'package:ui/screens/auth_screen.dart';

import 'package:ui/components/model/menu_item_model.dart';
import 'package:ui/components/home_screen/user/feedback_panel.dart';
import 'package:ui/components/home_screen/shared/settings_panel.dart';
import 'package:ui/utils/user_data_utils.dart';

class ResidentDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String authToken;

  const ResidentDashboard(
      {super.key, required this.userData, required this.authToken});

  @override
  State<ResidentDashboard> createState() => _ResidentDashboardState();
}

class _ResidentDashboardState extends State<ResidentDashboard> {
  String _currentView = 'home';

  // --- THÔNG TIN NGƯỜI DÙNG ---
  late final String _username;
  String _userName = "Người dân";
  final String _userRole = "Cư dân";
  String _userPhone = "---";
  int _userRegion = 0;

  @override
  void initState() {
    super.initState();
    _username =
        UserDataUtils.stringField(widget.userData, 'username', fallback: '');
    _userName = UserDataUtils.stringField(
        widget.userData, 'name',
        fallback: _userName);
    _userPhone = UserDataUtils.stringField(
        widget.userData, 'phone',
        fallback: _userPhone);
    _userRegion =
        UserDataUtils.intField(widget.userData, 'region', fallback: 0);
  }

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
        return AccountSettingsPanel(
          username: _username,
          initialName: _userName,
          initialPhone: _userPhone,
          initialRegion: _userRegion,
          authToken: widget.authToken,
          onProfileUpdated: (name, phone, region) {
            setState(() {
              _userName = name;
              _userPhone = phone;
              _userRegion = region;
            });
          },
        );
        
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
