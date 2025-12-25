import 'package:flutter/material.dart';

class MenuItemModel {
  // ID dùng để định danh khi xử lý sự kiện click (VD: 'home', 'customer', 'task')
  final String id;
  
  // Tên hiển thị trên Menu (VD: 'Trang chủ', 'Khách hàng')
  final String title;
  
  // Icon hiển thị bên trái
  final IconData icon;

  const MenuItemModel({
    required this.id,
    required this.title,
    required this.icon,
  });
}