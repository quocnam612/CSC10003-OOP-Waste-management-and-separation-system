import 'package:flutter/material.dart';

class SigninPanel extends StatelessWidget {
  const SigninPanel({
    super.key,
    required this.maxWidth,
    required this.formKey,
    required this.fullNameController,
    required this.usernameController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.roles,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.primaryColor,
    required this.onLogin,
    required this.onSubmit,
  });

  final double maxWidth;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final List<String> roles;
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final Color primaryColor;
  final VoidCallback onLogin;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Đăng ký',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên',
                hintText: 'Nhập họ và tên',
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Vui lòng nhập họ và tên'
                  : null,
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
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Nhập số điện thoại (+84)',
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
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
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng xác nhận mật khẩu';
                }
                if (value != passwordController.text) {
                  return 'Mật khẩu không khớp';
                }
                return null;
              },
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
                    onPressed: onLogin,
                    child: Text(
                      'Đăng nhập',
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
    );
  }
}
