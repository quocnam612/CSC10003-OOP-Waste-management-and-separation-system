import 'package:flutter/material.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({
    super.key,
    required this.maxWidth,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.roles,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.primaryColor,
    required this.onRegister,
    required this.onSubmit,
  });

  final double maxWidth;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final List<String> roles;
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final Color primaryColor;
  final VoidCallback onRegister;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: maxWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 28),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                borderRadius: BorderRadius.circular(16),
                hint: const Text('Chọn vai trò'),
                decoration: const InputDecoration(
                  labelText: 'Vai trò',
                ),
                items: roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ),
                    )
                    .toList(),
                onChanged: onRoleChanged,
                validator: (value) =>
                    value == null ? 'Vui lòng chọn vai trò' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  hintText: 'Nhập tên đăng nhập',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập tên đăng nhập'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập mật khẩu'
                    : null,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        side: BorderSide(color: primaryColor),
                      ),
                      onPressed: onRegister,
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: onSubmit,
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
