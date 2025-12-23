import 'package:flutter/material.dart';
import 'package:ui/features/worker/screens/worker_dashboard.dart';

// 1. Import các Widget con (LoginPanel, SigninPanel...)
import '../widgets/login_panel.dart';
import '../widgets/signin_panel.dart';
import '../widgets/title_field.dart';

// 2. Import Constant UserRole
import '../../../core/constants/app_constants.dart';

// 3. Import các màn hình Dashboard (theo cấu trúc mới)
// import '../../worker/screens/collector_dashboard.dart'; // Màn hình Nhân viên
import '../../manager/screens/manager_dashboard.dart';
import '../../user/screens/user_dashboard.dart'; 

// --- PHẦN 1: KHAI BÁO CÁC CONSTANTS VAI TRÒ ---
import '../../../core/constants/app_constants.dart';
// Việc dùng class static const giúp bạn tránh gõ sai chính tả (typo) khi so sánh string

// ----------------------------------------------

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _registerFullNameController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();
  
  bool _isRegister = false;
  String? _loginSelectedRole;
  String? _registerSelectedRole;

  // Sử dụng Constants đã khai báo ở trên vào danh sách
  final List<String> _roles = const [
    UserRole.user,
    UserRole.worker,
    UserRole.manager,
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _registerFullNameController.dispose();
    _registerUsernameController.dispose();
    _registerPhoneController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  // --- PHẦN 2: HÀM ĐIỀU HƯỚNG (BẠN TỰ THÊM SCREEN VÀO ĐÂY) ---
  Widget _getScreenForRole(String role) {
    switch (role) {
      
      case UserRole.worker:
        // Đã hoàn thiện
        return const WorkerDashboard();

      case UserRole.user:

        // Ví dụ: return const userHomeScreen();
        return const ResidentDashboard();

      case UserRole.manager:
        return const ManagerDashboard();

      default:
        // Mặc định trả về Login hoặc Dashboard chính
        return const ManagerDashboard();
    }
  }
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_pattern.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.green[50]),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth < 640 ? constraints.maxWidth : 460;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TitleField(),
                      const SizedBox(height: 56),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                             // ... (Giữ nguyên hiệu ứng animation của bạn)
                             final bool isRegisterChild = child.key == const ValueKey('register');
                             final bool isEntering = animation.status != AnimationStatus.reverse;
                             final double direction = isRegisterChild ? 1.0 : -1.0;
                             final double offScreenDistance = MediaQuery.of(context).size.width;
                             final Animation<double> offsetAnimation = animation.drive(
                                Tween<double>(
                                  begin: isEntering ? direction * offScreenDistance : 0.0,
                                  end: isEntering ? 0.0 : direction * offScreenDistance,
                                ).chain(CurveTween(curve: Curves.easeInOutCubic)),
                              );
                              return AnimatedBuilder(
                                animation: offsetAnimation,
                                child: child,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(offsetAnimation.value, 0),
                                    child: child,
                                  );
                                },
                              );
                          },
                          // Logic chuyển đổi Panel
                          child: _isRegister
                              ? SigninPanel(
                                  key: const ValueKey('register'),
                                  maxWidth: maxWidth,
                                  formKey: _signinFormKey,
                                  // ... Truyền các controller đăng ký ...
                                  fullNameController: _registerFullNameController,
                                  usernameController: _registerUsernameController,
                                  phoneController: _registerPhoneController,
                                  passwordController: _registerPasswordController,
                                  confirmPasswordController: _registerConfirmPasswordController,
                                  roles: _roles,
                                  selectedRole: _registerSelectedRole,
                                  onRoleChanged: (val) => setState(() => _registerSelectedRole = val),
                                  primaryColor: primary,
                                  onLogin: () => setState(() => _isRegister = false),
                                  onSubmit: () {
                                     // Logic đăng ký...
                                  },
                                )
                              : LoginPanel(
                                  key: const ValueKey('login'),
                                  maxWidth: maxWidth,
                                  formKey: _loginFormKey,
                                  usernameController: _usernameController,
                                  passwordController: _passwordController,
                                  roles: _roles,
                                  selectedRole: _loginSelectedRole,
                                  onRoleChanged: (val) => setState(() => _loginSelectedRole = val),
                                  primaryColor: primary,
                                  onRegister: () => setState(() => _isRegister = true),
                                  
                                  // --- GỌI HÀM ĐIỀU HƯỚNG TẠI ĐÂY ---
                                  onSubmit: () {
                                    if (_loginFormKey.currentState?.validate() == true) {
                                      if (_loginSelectedRole == null) return;
                                      
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          // Gọi hàm helper ở Phần 2
                                          builder: (context) => _getScreenForRole(_loginSelectedRole!),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}