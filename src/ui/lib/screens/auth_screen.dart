import 'package:flutter/material.dart';

import '../components/auth_screen/login_panel.dart';
import '../components/auth_screen/signin_panel.dart';
import '../services/auth_api.dart';
import '../widgets/background_pattern.dart';
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
  String? _loginSelectedRole;
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
      await AuthApi.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
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
        const BackgroundPattern(showTitle: true),
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
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (Widget? currentChild, List<Widget> previous) {
                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          ...previous,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (child, animation) {
                      final Animation<Offset> slideAnimation = animation.drive(
                        Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).chain(
                          CurveTween(curve: Curves.easeInOutCubic),
                        ),
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: panelWidth,
                        child: _isRegister
                            ? SigninPanel(
                                key: const ValueKey('register'),
                                maxWidth: panelWidth,
                                formKey: _signinFormKey,
                                fullNameController: _registerFullNameController,
                                usernameController: _registerUsernameController,
                                phoneController: _registerPhoneController,
                                passwordController: _registerPasswordController,
                                confirmPasswordController: _registerConfirmPasswordController,
                                roles: _roles,
                                selectedRole: _registerSelectedRole,
                                onRoleChanged: (value) {
                                  setState(() => _registerSelectedRole = value);
                                },
                                primaryColor: primary,
                                onLogin: () {
                                  setState(() => _isRegister = false);
                                },
                                onSubmit: () {
                                  _handleRegister();
                                },
                                isSubmitting: _isRegisterLoading,
                              )
                            : LoginPanel(
                                key: const ValueKey('login'),
                                maxWidth: panelWidth,
                                formKey: _loginFormKey,
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                                roles: _roles,
                                selectedRole: _loginSelectedRole,
                                onRoleChanged: (value) {
                                  setState(() => _loginSelectedRole = value);
                                },
                                primaryColor: primary,
                                onRegister: () {
                                  setState(() => _isRegister = true);
                                },
                                onSubmit: () {
                                  _handleLogin();
                                },
                                isSubmitting: _isLoginLoading,
                              ),
                      ),
                    ),
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
