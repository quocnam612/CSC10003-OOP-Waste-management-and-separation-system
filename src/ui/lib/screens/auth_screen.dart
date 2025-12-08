import 'package:flutter/material.dart';

import '../components/auth_screen/login_panel.dart';
import '../components/auth_screen/signin_panel.dart';
import '../components/auth_screen/title_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _registerUsernameController =
      TextEditingController();
  final TextEditingController _registerPhoneController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  final List<String> _roles = const [
    'Người dân',
    'Nhân viên thu gom',
    'Quản lý khu vực',
  ];

  String? _loginSelectedRole;
  String? _registerSelectedRole;
  bool _isRegister = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
          Image.asset(
            'assets/images/bg_pattern.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth =
                    constraints.maxWidth < 640 ? constraints.maxWidth : 460;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          layoutBuilder:
                              (Widget? currentChild, List<Widget> previous) {
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
                            final bool isRegisterChild =
                                child.key == const ValueKey('register');
                            final bool isEntering =
                                animation.status != AnimationStatus.reverse;

                            final double direction =
                                isRegisterChild ? 1.0 : -1.0;
                            final double offScreenDistance =
                                MediaQuery.of(context).size.width;

                            final Animation<double> offsetAnimation =
                                animation.drive(
                              Tween<double>(
                                begin: isEntering
                                    ? direction * offScreenDistance
                                    : 0.0,
                                end: isEntering
                                    ? 0.0
                                    : direction * offScreenDistance,
                              ).chain(
                                CurveTween(curve: Curves.easeInOutCubic),
                              ),
                            );

                            return AnimatedBuilder(
                              animation: offsetAnimation,
                              child: child,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset:
                                      Offset(offsetAnimation.value, 0),
                                  child: child,
                                );
                              },
                            );
                          },
                          child: _isRegister
                              ? SigninPanel(
                                  key: const ValueKey('register'),
                                  maxWidth: maxWidth,
                                  formKey: _signinFormKey,
                                  usernameController:
                                      _registerUsernameController,
                                  phoneController: _registerPhoneController,
                                  passwordController:
                                      _registerPasswordController,
                                  confirmPasswordController:
                                      _registerConfirmPasswordController,
                                  roles: _roles,
                                  selectedRole: _registerSelectedRole,
                                  onRoleChanged: (value) {
                                    setState(() =>
                                        _registerSelectedRole = value);
                                  },
                                  primaryColor: primary,
                                  onLogin: () {
                                    setState(() => _isRegister = false);
                                  },
                                  onSubmit: () {
                                    if (_signinFormKey.currentState
                                            ?.validate() ==
                                        true) {
                                      // TODO: Implement sign up flow.
                                    }
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
                                  onRoleChanged: (value) {
                                    setState(
                                        () => _loginSelectedRole = value);
                                  },
                                  primaryColor: primary,
                                  onRegister: () {
                                    setState(() => _isRegister = true);
                                  },
                                  onSubmit: () {
                                    if (_loginFormKey.currentState
                                            ?.validate() ==
                                        true) {
                                      // TODO: Implement authentication.
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
