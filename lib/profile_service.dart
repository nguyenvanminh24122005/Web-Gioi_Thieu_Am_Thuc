import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  final String fullName;
  final String phone;
  final String address;
  final String bio;
  final String? avatarPath; // ✅ thêm

  const ProfileData({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.bio,
    this.avatarPath,
  });

  ProfileData copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? bio,
    String? avatarPath, // ✅ thêm
  }) {
    return ProfileData(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal() {
    _load(); // ✅ tự load từ local storage khi app chạy
  }

  static const _kFullName = 'profile_fullName';
  static const _kPhone = 'profile_phone';
  static const _kAddress = 'profile_address';
  static const _kBio = 'profile_bio';
  static const _kAvatarPath = 'profile_avatarPath';

  final ValueNotifier<ProfileData> profile = ValueNotifier<ProfileData>(
    const ProfileData(
      fullName: 'Người dùng',
      phone: '',
      address: 'Việt Nam',
      bio: 'Yêu ẩm thực Việt và thích khám phá món ngon ba miền.',
      avatarPath: null,
    ),
  );

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    profile.value = ProfileData(
      fullName: prefs.getString(_kFullName) ?? 'Người dùng',
      phone: prefs.getString(_kPhone) ?? '',
      address: prefs.getString(_kAddress) ?? 'Việt Nam',
      bio: prefs.getString(_kBio) ?? 'Yêu ẩm thực Việt và thích khám phá món ngon ba miền.',
      avatarPath: prefs.getString(_kAvatarPath),
    );
  }

  Future<void> update(ProfileData data) async {
    profile.value = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFullName, data.fullName);
    await prefs.setString(_kPhone, data.phone);
    await prefs.setString(_kAddress, data.address);
    await prefs.setString(_kBio, data.bio);
    if (data.avatarPath == null) {
      await prefs.remove(_kAvatarPath);
    } else {
      await prefs.setString(_kAvatarPath, data.avatarPath!);
    }
  }

  // ✅ tiện: chỉ update avatar
  Future<void> updateAvatarPath(String path) async {
    await update(profile.value.copyWith(avatarPath: path));
  }
}