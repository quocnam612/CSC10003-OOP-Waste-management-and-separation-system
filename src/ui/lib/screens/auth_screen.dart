import 'package:flutter/material.dart';

import '../components/auth_screen/login_panel.dart';
import '../components/auth_screen/signin_panel.dart';
import '../components/global/background_pattern.dart';
import '../services/auth_api.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();
  
  // Login controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign up controllers
  final TextEditingController _registerFullNameController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerPhoneController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();
  
  bool _isRegister = false;
  String? _registerSelectedRole;
  bool _isLoginLoading = false;
  bool _isRegisterLoading = false;
  final List<String> _roles = const [
    'Người dân',
    'Nhân viên thu gom',
    'Quản lý khu vực',
  ];

  int? _roleToId(String? role) {
    switch (role) {
      case 'Người dân':
        return 1;
      case 'Nhân viên thu gom':
        return 2;
      case 'Quản lý khu vực':
        return 3;
      default:
        return null;
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
  }

  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState?.validate() != true) return;
    setState(() => _isLoginLoading = true);
    try {
      final userData = await AuthApi.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(userData: userData),
        ),
      );
    } catch (e) {
      _showSnack('Đăng nhập thất bại: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoginLoading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_signinFormKey.currentState?.validate() != true) return;
    final roleId = _roleToId(_registerSelectedRole);
    if (roleId == null) {
      _showSnack('Vui lòng chọn vai trò hợp lệ', isError: true);
      return;
    }
    setState(() => _isRegisterLoading = true);
    try {
      await AuthApi.register(
        role: roleId,
        username: _registerUsernameController.text.trim(),
        password: _registerPasswordController.text,
        phone: _registerPhoneController.text.trim(),
        name: _registerFullNameController.text.trim(),
        region: 0,
      );
      _showSnack('Đăng ký thành công! Vui lòng đăng nhập.');
      if (mounted) {
        setState(() => _isRegister = false);
      }
    } catch (e) {
      _showSnack('Đăng ký thất bại: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isRegisterLoading = false);
      }
    }
  }


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

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundPattern(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 72),
            child: Column(
              children: [
                Text(
                  'GreenRoute',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 76,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Ứng dụng quản lí rác',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final double contentPadding = constraints.maxWidth < 768 ? 16 : 32;
              final double availableWidth = constraints.maxWidth - (contentPadding * 2);
              final double targetWidth = constraints.maxWidth < 640 ? availableWidth : 460.0;
              final double panelWidth = targetWidth.clamp(0.0, 460.0).toDouble();

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: contentPadding,
                    vertical: 32,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 72),
                        const SizedBox(height: 32),
                        ClipRect(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: panelWidth,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 28,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: _isRegister
                              ? SigninPanel(
                                  formKey: _signinFormKey,
                                  fullNameController: _registerFullNameController,
                                  usernameController: _registerUsernameController,
                                  phoneController: _registerPhoneController,
                                  passwordController: _registerPasswordController,
                                  confirmPasswordController: _registerConfirmPasswordController,
                                  roles: _roles,
                                  selectedRole: _registerSelectedRole,
                                  onRoleChanged: (value) { setState(() => _registerSelectedRole = value); },
                                  primaryColor: primary,
                                  onLogin: () { setState(() => _isRegister = false); },
                                  onSubmit: () { _handleRegister(); },
                                  isSubmitting: _isRegisterLoading,
                                )
                              : LoginPanel(
                                  formKey: _loginFormKey,
                                  usernameController: _usernameController,
                                  passwordController: _passwordController,
                                  primaryColor: primary,
                                  onRegister: () { setState(() => _isRegister = true); },
                                  onSubmit: () { _handleLogin(); },
                                  isSubmitting: _isLoginLoading,
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
