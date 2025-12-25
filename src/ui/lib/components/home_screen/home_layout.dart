import 'package:flutter/material.dart';
import 'package:ui/components/model/menu_item_model.dart';

// 1. [QUAN TRỌNG] Widget hiển thị nội dung mặc định (Trang chủ)
// Đây là class mà bạn đang bị thiếu
class DefaultDashboardBody extends StatelessWidget {
  const DefaultDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_customize_outlined, size: 80, color: primaryColor),
          const SizedBox(height: 16),
          const Text('Chào mừng đến với GreenRoute!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 2. Widget Drawer ĐỘNG
class DynamicDrawer extends StatelessWidget {
  final List<MenuItemModel> menuItems; 
  final Function(String) onItemSelected;
  final String drawerHeaderTitle; 

  const DynamicDrawer({
    super.key,
    required this.menuItems,
    required this.onItemSelected,
    required this.drawerHeaderTitle,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Drawer(
      child: Column(
        children: [
          // Header & Menu List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: primaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.eco, size: 48, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        drawerHeaderTitle, 
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                
                // Render danh sách menu
                ...menuItems.map((item) => ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: () => onItemSelected(item.id),
                )),
              ],
            ),
          ),
          
          // Footer cố định
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Cài đặt'), onTap: () => onItemSelected('setting')),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () => onItemSelected('logout'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// 3. Widget Profile Button ĐỘNG
class DynamicProfileButton extends StatelessWidget {
  final Function(String) onSelected;
  final String userName;
  final String userRole;

  const DynamicProfileButton({
    super.key,
    required this.onSelected,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      tooltip: 'Tài khoản',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: primaryColor),
      ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, size: 40, color: primaryColor))),
              const SizedBox(height: 10),
              Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(userRole, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'detail', child: Row(children: [Icon(Icons.info_outline, color: Colors.blue), SizedBox(width: 12), Text('Thông tin chi tiết')])),
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, color: Colors.orange), SizedBox(width: 12), Text('Sửa hồ sơ')])),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 12), Text('Đăng xuất')])),
      ],
    );
  }
}

// 4. MAIN LAYOUT
class DashboardLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<MenuItemModel> menuItems;
  final Function(String) onDrawerItemSelected;
  final Function(String) onProfileSelected;
  
  final String userName;
  final String userRole;

  const DashboardLayout({
    super.key,
    required this.title,
    required this.body,
    required this.menuItems,
    required this.onDrawerItemSelected,
    required this.onProfileSelected,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          
          DynamicProfileButton(
            onSelected: onProfileSelected,
            userName: userName,
            userRole: userRole,
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      drawer: DynamicDrawer(
        menuItems: menuItems,
        onItemSelected: onDrawerItemSelected,
        drawerHeaderTitle: userRole,
      ),
      
      body: body,
    );
  }
}