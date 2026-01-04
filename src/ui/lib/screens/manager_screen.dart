import 'package:flutter/material.dart';
import 'package:ui/components/home_screen/shared/home_layout.dart';
import '../../screens/auth_screen.dart';

import 'package:ui/components/model/menu_item_model.dart';
import 'package:ui/components/model/customer_model.dart';
import 'package:ui/components/model/report_model.dart';
import 'package:ui/components/model/worker_model.dart';
import 'package:ui/components/model/service_request_model.dart';
import 'package:ui/components/model/route_model.dart';

import 'package:ui/components/home_screen/manager/customer_panel.dart';
import 'package:ui/components/home_screen/manager/reports_panel.dart';
import 'package:ui/components/home_screen/manager/worker_panel.dart';
import 'package:ui/components/home_screen/manager/task_panel.dart';
import 'package:ui/components/home_screen/shared/settings_panel.dart';
import 'package:ui/utils/user_data_utils.dart';
import 'package:ui/services/customer_api.dart';
import 'package:ui/services/reports_api.dart';
import 'package:ui/services/worker_api.dart';
import 'package:ui/services/service_request_api.dart';
import 'package:ui/services/user_management_api.dart';
import 'package:ui/services/routes_api.dart';

class ManagerDashboard extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String authToken;

  const ManagerDashboard(
      {super.key, required this.userData, required this.authToken});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _currentView = 'home';

  // --- A. THÔNG TIN NGƯỜI DÙNG ---
  late final String _managerUsername;
  late String _managerName;
  final String _managerRole = "Quản lý khu vực";
  late String _managerPhone;
  late int _managerRegion;

  @override
  void initState() {
    super.initState();
    _managerUsername =
        UserDataUtils.stringField(widget.userData, 'username', fallback: '');
    _managerName = UserDataUtils.stringField(
        widget.userData, 'name',
        fallback: 'Quản lý');
    _managerPhone = UserDataUtils.stringField(
        widget.userData, 'phone',
        fallback: '---');
    _managerRegion =
        UserDataUtils.intField(widget.userData, 'region', fallback: 0);
    _reloadRegionData();
  }

  @override
  void didUpdateWidget(covariant ManagerDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authToken != widget.authToken) {
      _reloadRegionData();
    }
  }

  final List<MenuItemModel> _managerMenu = const [
    MenuItemModel(id: 'home', title: 'Trang chủ', icon: Icons.home),
    MenuItemModel(id: 'customer', title: 'Khách hàng', icon: Icons.people),
    MenuItemModel(id: 'manage', title: 'Quản lí', icon: Icons.manage_accounts),
    MenuItemModel(id: 'report', title: 'Phản ánh', icon: Icons.assignment),
    MenuItemModel(id: 'task', title: 'Công việc', icon: Icons.task_alt),
  ];

  // --- B. DỮ LIỆU KHÁCH HÀNG ---
  List<CustomerModel> _customers = [];
  bool _isCustomersLoading = false;
  String? _customersError;
  List<WorkerModel> _workers = [];
  bool _isWorkersLoading = false;
  String? _workersError;
  List<ServiceRequestModel> _regionServices = [];
  bool _isRegionServicesLoading = false;
  String? _regionServicesError;
  List<RouteModel> _routes = [];
  bool _isRoutesLoading = false;
  bool _isCreatingRoute = false;
  String? _routesError;
  List<ReportModel> _reports = [];
  bool _isReportsLoading = false;
  String? _reportsError;
  String? _resolvingReportId;
  String? _togglingCustomerId;
  String? _togglingWorkerId;

  // --- C. CÁC HÀM XỬ LÝ ---

  void _handleDrawerItem(String id) {
    Navigator.pop(context); // Đóng Drawer
    if (id == 'logout') {
      _performLogout();
    } else {
      setState(() => _currentView = id);
    }
  }

  Future<void> _loadCustomers() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _customers = [];
        _customersError = 'Phiên đăng nhập không hợp lệ.';
      });
      return;
    }

    setState(() {
      _isCustomersLoading = true;
      _customersError = null;
    });

    try {
      final raw = await CustomerApi.fetchCustomers(token: widget.authToken);
      final parsed = raw
          .map(CustomerModel.fromJson)
          .where((customer) => _managerRegion <= 0 || customer.region == _managerRegion)
          .toList();
      if (!mounted) return;
      setState(() => _customers = parsed);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _customersError = error.toString();
        _customers = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isCustomersLoading = false);
    }
  }

  Future<void> _loadWorkers() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _workers = [];
        _workersError = 'Phiên đăng nhập không hợp lệ.';
      });
      return;
    }

    setState(() {
      _isWorkersLoading = true;
      _workersError = null;
    });

    try {
      final raw = await WorkerApi.fetchWorkers(token: widget.authToken);
      final parsed = raw
          .map(WorkerModel.fromJson)
          .where((worker) => _managerRegion <= 0 || worker.region == _managerRegion)
          .toList();
      if (!mounted) return;
      setState(() => _workers = parsed);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _workersError = error.toString();
        _workers = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isWorkersLoading = false);
    }
  }

  Future<void> _loadRegionServices() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _regionServices = [];
        _regionServicesError = 'Phiên đăng nhập không hợp lệ.';
      });
      return;
    }

    setState(() {
      _isRegionServicesLoading = true;
      _regionServicesError = null;
    });

    try {
      final raw = await ServiceRequestApi.fetchRegionRequests(token: widget.authToken);
      final parsed = raw
          .map(ServiceRequestModel.fromJson)
          .where((service) => _managerRegion <= 0 || service.region == _managerRegion)
          .toList();
      if (!mounted) return;
      setState(() => _regionServices = parsed);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _regionServicesError = error.toString();
        _regionServices = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isRegionServicesLoading = false);
    }
  }

  Future<void> _loadRoutes() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _routes = [];
        _routesError = 'Phiên đăng nhập không hợp lệ.';
      });
      return;
    }

    setState(() {
      _isRoutesLoading = true;
      _routesError = null;
    });

    try {
      final raw = await RoutesApi.fetchRoutes(token: widget.authToken);
      final parsed = raw
          .map(RouteModel.fromJson)
          .where((route) => _managerRegion <= 0 || route.region == _managerRegion)
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

  void _reloadRegionData() {
    _loadCustomers();
    _loadWorkers();
    _loadRegionServices();
    _loadReports();
    _loadRoutes();
  }

  Future<void> _loadReports() async {
    if (widget.authToken.isEmpty) {
      setState(() {
        _reports = [];
        _reportsError = 'Phiên đăng nhập không hợp lệ.';
      });
      return;
    }

    setState(() {
      _isReportsLoading = true;
      _reportsError = null;
    });

    try {
      final raw = await ReportsApi.fetchReports(token: widget.authToken);
      final parsed = raw.map(ReportModel.fromJson).toList();
      if (!mounted) return;
      setState(() => _reports = parsed);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _reportsError = error.toString();
        _reports = [];
      });
    } finally {
      if (!mounted) return;
      setState(() => _isReportsLoading = false);
    }
  }

  Future<void> _handleUpdateReportStatus(String reportId, bool resolved) async {
    if (reportId.isEmpty) {
      _showSnack('Không xác định được phản ánh để cập nhật.', isError: true);
      return;
    }
    if (widget.authToken.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ.', isError: true);
      return;
    }

    setState(() => _resolvingReportId = reportId);
    try {
      await ReportsApi.resolveReport(
        reportId: reportId,
        resolved: resolved,
        token: widget.authToken,
      );
      if (!mounted) return;
      _showSnack('Đã cập nhật trạng thái phản ánh.');
      await _loadReports();
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể cập nhật phản ánh: $error', isError: true);
    } finally {
      if (!mounted) return;
      setState(() => _resolvingReportId = null);
    }
  }

  Future<void> _handleToggleCustomerStatus(String userId, bool nextStatus) async {
    if (userId.isEmpty) {
      _showSnack('Không xác định được khách hàng để cập nhật.', isError: true);
      return;
    }
    if (widget.authToken.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ.', isError: true);
      return;
    }

    setState(() => _togglingCustomerId = userId);
    try {
      await UserManagementApi.updateStatus(
        userId: userId,
        isActive: nextStatus,
        token: widget.authToken,
      );
      if (!mounted) return;
      _showSnack('Đã cập nhật trạng thái khách hàng.');
      await _loadCustomers();
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể cập nhật khách hàng: $error', isError: true);
    } finally {
      if (!mounted) return;
      setState(() => _togglingCustomerId = null);
    }
  }

  Future<void> _handleToggleWorkerStatus(String userId, bool nextStatus) async {
    if (userId.isEmpty) {
      _showSnack('Không xác định được nhân viên để cập nhật.', isError: true);
      return;
    }
    if (widget.authToken.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ.', isError: true);
      return;
    }

    setState(() => _togglingWorkerId = userId);
    try {
      await UserManagementApi.updateStatus(
        userId: userId,
        isActive: nextStatus,
        token: widget.authToken,
      );
      if (!mounted) return;
      _showSnack('Đã cập nhật trạng thái nhân viên.');
      await _loadWorkers();
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể cập nhật nhân viên: $error', isError: true);
    } finally {
      if (!mounted) return;
      setState(() => _togglingWorkerId = null);
    }
  }

  Future<void> _handleUpdateWorkerTeam(String workerId, int? newTeamId) async {
    if (workerId.isEmpty) return;
    if (widget.authToken.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ.', isError: true);
      return;
    }

    final index = _workers.indexWhere((worker) => worker.id == workerId);
    if (index == -1) return;

    try {
      await UserManagementApi.updateTeam(
        userId: workerId,
        team: newTeamId,
        token: widget.authToken,
      );

      final updatedWorker =
          _workers[index].copyWith(team: newTeamId ?? -1);
      setState(() {
        final updatedList = List<WorkerModel>.from(_workers);
        updatedList[index] = updatedWorker;
        _workers = updatedList;
      });

      final teamLabel =
          (newTeamId == null || newTeamId <= 0) ? 'Chưa phân đội' : 'Đội #$newTeamId';
      _showSnack('Đã chuyển ${updatedWorker.fullName} sang $teamLabel');
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể cập nhật đội: $error', isError: true);
    }
  }

  Future<void> _handleCreateRoute(RouteCreationData data) async {
    if (widget.authToken.isEmpty) {
      _showSnack('Phiên đăng nhập không hợp lệ.', isError: true);
      return;
    }
    if (_managerRegion <= 0) {
      _showSnack('Không xác định được khu vực để tạo tuyến.', isError: true);
      return;
    }

    setState(() => _isCreatingRoute = true);
    try {
      await RoutesApi.createRoute(
        district: data.district,
        shift: data.shift,
        team: data.team,
        stops: data.stops,
        region: _managerRegion,
        token: widget.authToken,
      );
      if (!mounted) return;
      _showSnack('Đã tạo tuyến đường mới.');
      await _loadRoutes();
    } catch (error) {
      if (!mounted) return;
      _showSnack('Không thể tạo tuyến đường: $error', isError: true);
    } finally {
      if (!mounted) return;
      setState(() => _isCreatingRoute = false);
    }
  }

  void _performLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ));
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
          isLoading: _isCustomersLoading,
          errorMessage: _customersError,
          onRefresh: _loadCustomers,
          onToggleStatus: _handleToggleCustomerStatus,
          togglingUserId: _togglingCustomerId,
        );

      case 'report':
        return ReportsPanel(
          reports: _reports,
          isLoading: _isReportsLoading,
          errorMessage: _reportsError,
          onRefresh: _loadReports,
          onStatusChange: _handleUpdateReportStatus,
          resolvingReportId: _resolvingReportId,
        );

      case 'manage':
        return WorkerPanel(
          workers: _workers,
          isLoading: _isWorkersLoading,
          errorMessage: _workersError,
          onRefresh: _loadWorkers,
          onToggleStatus: _handleToggleWorkerStatus,
          togglingUserId: _togglingWorkerId,
          onTeamChanged: _handleUpdateWorkerTeam,
        );
      case 'request':
        return const Center(child: Text("Màn hình Yêu cầu (Đang phát triển)"));
      case 'task':
        final availableTeams = _workers
            .map((worker) => worker.team)
            .where((team) => team > 0)
            .toSet()
            .toList()
          ..sort();
        return ManagerTaskPanel(
          services: _regionServices,
          isLoading: _isRegionServicesLoading,
          errorMessage: _regionServicesError,
          onRefresh: _loadRegionServices,
          routes: _routes,
          availableTeams: availableTeams,
          isRoutesLoading: _isRoutesLoading,
          routesErrorMessage: _routesError,
          onRoutesRefresh: _loadRoutes,
          onCreateRoute: _handleCreateRoute,
          isCreatingRoute: _isCreatingRoute,
        );
      case 'setting':
        return AccountSettingsPanel(
          username: _managerUsername,
          initialName: _managerName,
          initialPhone: _managerPhone,
          initialRegion: _managerRegion,
          authToken: widget.authToken,
          onProfileUpdated: (name, phone, region) {
            setState(() {
              _managerName = name;
              _managerPhone = phone;
              _managerRegion = region;
            });
            _reloadRegionData();
          },
        );
      
      default:
        return const DefaultDashboardBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    // QUAN TRỌNG: Không dùng Scaffold nữa, dùng DashboardLayout
    String title;
    switch (_currentView) {
      case 'customer':
        title = 'Quản lý Khách Hàng';
      case 'manage':
        title = 'Quản lý Nhân viên';
      case 'report':
        title = 'Phản ánh khu vực';
      case 'task':
        title = 'Công việc khu vực';
      case 'home':
        title = 'Dashboard';
      default:
        title = 'Quản Lý';
    }

    return DashboardLayout(
      title: title,
      
      // Dữ liệu truyền vào Layout
      userName: _managerName,
      userRole: _managerRole,
      authToken: widget.authToken,
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
