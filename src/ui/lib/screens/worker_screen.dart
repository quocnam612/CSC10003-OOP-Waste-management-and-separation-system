import 'package:flutter/material.dart';
import 'package:ui/components/home_screen/shared/home_layout.dart';
import 'package:ui/screens/auth_screen.dart';

import 'package:ui/components/model/menu_item_model.dart';

import 'package:ui/components/home_screen/worker/team_panel.dart';
import 'package:ui/components/home_screen/worker/task_panel.dart';
import 'package:ui/components/home_screen/shared/settings_panel.dart';
import 'package:ui/components/model/route_model.dart';
import 'package:ui/utils/user_data_utils.dart';
import 'package:ui/services/worker_api.dart';
import 'package:ui/services/routes_api.dart';

class WorkerDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String authToken;

  const WorkerDashboard(
      {super.key, required this.userData, required this.authToken});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  String _currentView = 'home';

  // --- THÔNG TIN NGƯỜI DÙNG ---
  late final String _workerUsername;
  String _workerName = "Nhân viên";
  final String _workerRole = "Thành viên đội dọn dẹp";
  String _workerPhone = "---";
  int _workerRegion = 0;
  int _workerTeam = -1;
  int _panelReloadKey = 0;

  bool _isTeamLoading = false;
  String? _teamError;
  List<Map<String, dynamic>> _teamMembers = [];
  List<RouteModel> _routes = [];
  bool _isRoutesLoading = false;
  String? _routesError;

  @override
  void initState() {
    super.initState();
    _workerUsername =
        UserDataUtils.stringField(widget.userData, 'username', fallback: '');
    _workerName = UserDataUtils.stringField(
        widget.userData, 'name',
        fallback: _workerName);
    _workerPhone = UserDataUtils.stringField(
        widget.userData, 'phone',
        fallback: _workerPhone);
    _workerRegion =
        UserDataUtils.intField(widget.userData, 'region', fallback: 0);
    _workerTeam = UserDataUtils.intField(widget.userData, 'team', fallback: -1);

    _reloadWorkerData();
  }

  @override
  void didUpdateWidget(covariant WorkerDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authToken != widget.authToken) {
      _reloadWorkerData();
    }
  }

  final List<MenuItemModel> _workerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'team', title: 'Đội dọn dẹp', icon: Icons.groups_3),
    MenuItemModel(id: 'task', title: 'Công việc', icon: Icons.task),
  ];

  // --- DỮ LIỆU CÔNG VIỆC (ID giữ nguyên nhập thủ công/cố định từ data) ---
  // --- ACTION HANDLERS ---
  void _handleDrawerItem(String id) {
    Navigator.pop(context);
    if (id == 'logout') {
      _performLogout();
    } else {
      setState(() => _currentView = id);
      if (id == 'team' &&
          _workerTeam > 0 &&
          _teamMembers.isEmpty &&
          !_isTeamLoading) {
        _loadTeamMembers();
      }
    }
  }

  void _performLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  String get _currentTitle {
    switch (_currentView) {
      case 'task':
        return 'Danh Sách Việc';
      case 'team':
        return 'Đội dọn dẹp';
      default:
        return 'Đội dọn dẹp';
    }
  }

  String get _teamName =>
      _workerTeam > 0 ? 'Đội dọn dẹp #$_workerTeam' : 'Đội dọn dẹp';

  Future<void> _loadTeamMembers() async {
    if (_workerTeam <= 0 || widget.authToken.isEmpty) {
      setState(() {
        _teamMembers = [];
        _teamError = null;
      });
      return;
    }

    setState(() {
      _isTeamLoading = true;
      _teamError = null;
    });

    try {
      final members =
          await WorkerApi.fetchTeamMembers(token: widget.authToken);
      if (!mounted) return;
      setState(() {
        _teamMembers = members;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _teamError = error.toString();
        _teamMembers = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isTeamLoading = false;
      });
    }
  }

  void _reloadWorkerData() {
    if (_workerTeam > 0) {
      _loadTeamMembers();
    } else {
      setState(() {
        _teamMembers = [];
        _teamError = null;
      });
    }
    _loadWorkerRoutes();
  }

  Future<void> _loadWorkerRoutes() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _routes = [];
        _routesError = 'Phiên đăng nhập không hợp lệ.';
        _isRoutesLoading = false;
      });
      return;
    }

    if (_workerRegion <= 0 || _workerTeam <= 0) {
      setState(() {
        _routes = [];
        _routesError = (_workerTeam <= 0)
            ? 'Bạn chưa được phân đội, vui lòng liên hệ quản lý.'
            : 'Không xác định được khu vực làm việc.';
        _isRoutesLoading = false;
      });
      return;
    }

    setState(() {
      _isRoutesLoading = true;
      _routesError = null;
    });

    try {
      final raw = await RoutesApi.fetchWorkerRoutes(token: widget.authToken);
      final parsed = raw
          .map(RouteModel.fromJson)
          .where((route) => route.team == _workerTeam && route.region == _workerRegion)
          .toList();
      if (!mounted) return;
      setState(() => _routes = parsed);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _routesError = error.toString();
        _routes = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isRoutesLoading = false);
    }
  }

  // --- BUILD BODY ---
  Widget _buildBody() {
    switch (_currentView) {
      case 'home':
        return const DefaultDashboardBody();

      case 'team':
        if (_workerTeam <= 0) {
          return const Center(
            child: Text('Bạn chưa được phân vào đội nào.'),
          );
        }
        if (_isTeamLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_teamError != null) {
          return Center(
            child: Text(
              _teamError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return CleaningTeamPanel(
          key: ValueKey('team_$_panelReloadKey'),
          teamName: _teamName,
          members: _teamMembers,
        );
        
      case 'task':
        return TaskPanel(
          key: ValueKey('task_$_panelReloadKey'),
          routes: _routes,
          isLoading: _isRoutesLoading,
          errorMessage: _routesError,
          onRefresh: _loadWorkerRoutes,
        );
        
      case 'setting':
        return AccountSettingsPanel(
          username: _workerUsername,
          initialName: _workerName,
          initialPhone: _workerPhone,
          initialRegion: _workerRegion,
          authToken: widget.authToken,
          onProfileUpdated: (name, phone, region) {
            final regionChanged = _workerRegion != region;
            setState(() {
              _workerName = name;
              _workerPhone = phone;
              _workerRegion = region;
              if (regionChanged) {
                _panelReloadKey++;
              }
            });
            if (regionChanged) {
              _reloadWorkerData();
            }
          },
        );
        
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: _currentTitle,
      
      userName: _workerName,
      userRole: _workerRole,
      authToken: widget.authToken,
      menuItems: _workerMenu,
      
      onDrawerItemSelected: _handleDrawerItem,
      onProfileSelected: (val) {
        if (val == 'logout') _performLogout();
      },
      
      body: _buildBody(),
    );
  }
}
