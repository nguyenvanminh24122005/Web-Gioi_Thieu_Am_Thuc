import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'login_screen.dart';
import 'favorite_service.dart';
import 'profile_service.dart';
import 'edit_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
  Future<void> _pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    // copy vào thư mục app để ảnh không mất
    final dir = await getApplicationDocumentsDirectory();
    final ext = p.extension(xfile.path);
    final newPath = p.join(dir.path, 'avatar$ext');
    final saved = await File(xfile.path).copy(newPath);

    await ProfileService().updateAvatarPath(saved.path);
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Đăng xuất')),
        ],
      ),
    );

    if (ok == true) {
      // ignore: use_build_context_synchronously
      await _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService().savedEmail ?? 'Chưa có email';

    return ValueListenableBuilder<ProfileData>(
      valueListenable: ProfileService().profile,
      builder: (context, p, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220,
                backgroundColor: Colors.red,
                title: const Text('Thông tin cá nhân'),
                centerTitle: true,
                actions: [
                  IconButton(
                    tooltip: 'Chỉnh sửa',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.red, Color(0xFFB71C1C)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => _pickAvatar(context),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 42,
                                    backgroundColor: Colors.white,
                                    backgroundImage: (p.avatarPath != null && File(p.avatarPath!).existsSync())
                                        ? FileImage(File(p.avatarPath!))
                                        : null,
                                    child: (p.avatarPath == null || !File(p.avatarPath!).existsSync())
                                        ? const Icon(Icons.person, color: Colors.red, size: 46)
                                        : null,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.red),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.fullName.isEmpty ? 'Người dùng' : p.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    p.bio,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  child: Column(
                    children: [
                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.favorite,
                              title: 'Yêu thích',
                              child: ValueListenableBuilder<Set<String>>(
                                valueListenable: FavoriteService().favorites,
                                builder: (context, favs, _) {
                                  return Text(
                                    '${favs.length}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.local_dining,
                              title: 'Sưu tầm',
                              child: ValueListenableBuilder<Set<String>>(
                                valueListenable: FavoriteService().favorites,
                                builder: (context, favs, _) {
                                  return Text(
                                    '${favs.length}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.star,
                              title: 'Điểm',
                              child: ValueListenableBuilder<Set<String>>(
                                valueListenable: FavoriteService().favorites,
                                builder: (context, favs, _) {
                                  final points = favs.length * 10;
                                  return Text(
                                    '$points',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Info section
                      _SectionCard(
                        title: 'Thông tin',
                        children: [
                          _InfoTile(
                            icon: Icons.badge_outlined,
                            label: 'Họ và tên',
                            value: p.fullName.isEmpty ? 'Chưa cập nhật' : p.fullName,
                          ),
                          _InfoTile(
                            icon: Icons.phone_outlined,
                            label: 'Số điện thoại',
                            value: p.phone.isEmpty ? 'Chưa cập nhật' : p.phone,
                          ),
                          _InfoTile(
                            icon: Icons.location_on_outlined,
                            label: 'Địa chỉ',
                            value: p.address.isEmpty ? 'Chưa cập nhật' : p.address,
                          ),
                          _InfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: email,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Settings section
                      _SectionCard(
                        title: 'Cài đặt',
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit_outlined),
                            title: const Text('Chỉnh sửa hồ sơ'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                            },
                          ),

                          const Divider(height: 1),

                          // Dark Mode demo
                          ListTile(
                            leading: const Icon(Icons.dark_mode_outlined),
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Theo chế độ hệ thống'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Dark Mode'),
                                  content: const Text(
                                    'Ứng dụng sẽ tự chuyển sang giao diện tối nếu điện thoại đang bật Dark Mode.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Đóng'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(height: 1),

                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('Giới thiệu ứng dụng'),
                            subtitle: const Text('Vị Việt • 1.0.0'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Vị Việt',
                                applicationVersion: '1.0.0',
                                applicationLegalese: '© 2026',
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Logout
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => _confirmLogout(context),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Đăng xuất',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.red),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const Divider(height: 1),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(const Divider(height: 1));
    }
    return out;
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}