import 'package:flutter/material.dart';
import 'package:ui/components/home_screen/shared/home_layout.dart';
import '../../screens/auth_screen.dart';

import 'package:ui/components/model/menu_item_model.dart';
import 'package:ui/components/model/customer_model.dart';
import 'package:ui/components/model/report_model.dart';
import 'package:ui/components/model/worker_model.dart';

import 'package:ui/components/home_screen/manager/customer_panel.dart';
import 'package:ui/components/home_screen/manager/reports_panel.dart';
import 'package:ui/components/home_screen/manager/worker_panel.dart';
import 'package:ui/components/home_screen/shared/settings_panel.dart';
import 'package:ui/utils/user_data_utils.dart';
import 'package:ui/services/customer_api.dart';
import 'package:ui/services/reports_api.dart';
import 'package:ui/services/worker_api.dart';

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
    _loadCustomers();
    _loadWorkers();
    _loadReports();
  }

  @override
  void didUpdateWidget(covariant ManagerDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authToken != widget.authToken) {
      _loadCustomers();
      _loadWorkers();
      _loadReports();
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
  List<ReportModel> _reports = [];
  bool _isReportsLoading = false;
  String? _reportsError;
  String? _resolvingReportId;

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

  Future<void> _handleResolveReport(String reportId) async {
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
      await ReportsApi.resolveReport(reportId: reportId, token: widget.authToken);
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
        );

      case 'report':
        return ReportsPanel(
          reports: _reports,
          isLoading: _isReportsLoading,
          errorMessage: _reportsError,
          onRefresh: _loadReports,
          onResolve: _handleResolveReport,
          resolvingReportId: _resolvingReportId,
        );

      case 'manage':
        return WorkerPanel(
          workers: _workers,
          isLoading: _isWorkersLoading,
          errorMessage: _workersError,
          onRefresh: _loadWorkers,
        );
      case 'request':
        return const Center(child: Text("Màn hình Yêu cầu (Đang phát triển)"));
      case 'task':
        return const Center(child: Text("Màn hình Nhiệm vụ (Đang phát triển)"));
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
        break;
      case 'manage':
        title = 'Quản lý Nhân viên';
        break;
      case 'report':
        title = 'Phản ánh khu vực';
        break;
      case 'home':
        title = 'Dashboard';
        break;
      default:
        title = 'Quản Lý';
        break;
    }

    return DashboardLayout(
      title: title,
      
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
