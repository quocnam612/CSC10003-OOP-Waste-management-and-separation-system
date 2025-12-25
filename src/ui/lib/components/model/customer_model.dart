class CustomerModel {
  final String id;
  final String fullName;
  final String username;
  final String phone;
  final String area;
  final String createdDate;
  final bool isActive; // true: Hoạt động, false: Tạm dừng

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phone,
    required this.area,
    required this.createdDate,
    required this.isActive,
  });
}