import 'package:flutter/material.dart';
import '../../../models/customer_model.dart';

class CustomerPanel extends StatelessWidget {
  final List<CustomerModel> customers;
  final Function(String) onDelete;
  final VoidCallback onCreate;

  const CustomerPanel({
    super.key,
    required this.customers,
    required this.onDelete,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        // 1. Phần nội dung (Bảng)
        Positioned.fill(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            // Thêm padding đáy lớn (100) để nội dung cuối không bị nút Tạo che khuất
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100), 
            child: Center( // Căn giữa toàn bộ bảng
              child: Card( // Wrap bảng vào Card để tạo khung và bóng
                elevation: 4, // Độ nổi của bóng
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Bo góc card
                ),
                color: Colors.white, // Màu nền của bảng
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Khoảng cách giữa viền Card và Table
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Cuộn ngang nếu màn hình nhỏ
                    child: DataTable(
                      headingRowHeight: 60, // Tăng chiều cao tiêu đề cho thoáng
                      dataRowMinHeight: 50,
                      dataRowMaxHeight: 60,
                      columnSpacing: 50, // Tăng khoảng cách giữa các cột
                      headingRowColor: MaterialStateProperty.all(primaryColor.withOpacity(0.1)), // Màu nền tiêu đề nhạt
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey[200]!, width: 1), // Kẻ ngang mờ giữa các dòng
                      ),
                      columns: const [
                        DataColumn(label: Text('Họ tên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('Tên TK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('SĐT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('Khu vực', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('Ngày tạo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        DataColumn(label: Text('Hành động', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      ],
                      rows: customers.map((customer) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey[200],
                                    child: Text(customer.fullName[0], style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              )
                            ),
                            DataCell(Text(customer.username)),
                            DataCell(Text(customer.phone)),
                            DataCell(Text(customer.area)),
                            DataCell(Text(customer.createdDate)),
                            // Cột trạng thái đẹp hơn
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: customer.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: customer.isActive ? Colors.green : Colors.red, width: 0.5),
                                ),
                                child: Text(
                                  customer.isActive ? 'Hoạt động' : 'Tạm dừng',
                                  style: TextStyle(
                                    color: customer.isActive ? Colors.green[700] : Colors.red[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                            // Cột nút Xoá
                            DataCell(
                              InkWell(
                                onTap: () => onDelete(customer.id),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 2. Nút Tạo (Floating Action Button Style nhưng nằm giữa)
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              child: ElevatedButton.icon(
                onPressed: onCreate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text('Thêm Khách Hàng'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}