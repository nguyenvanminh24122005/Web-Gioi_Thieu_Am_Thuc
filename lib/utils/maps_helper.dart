import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsHelper {
  static Future<Position> _getCurrentPosition() async {
    // 1) Kiểm tra GPS bật chưa
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Bạn đang tắt định vị (GPS). Hãy bật GPS để dùng tính năng này.';
    }

    // 2) Kiểm tra quyền
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Bạn chưa cấp quyền vị trí.';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Bạn đã chặn quyền vị trí vĩnh viễn. Hãy vào Settings để bật lại.';
    }

    // 3) Lấy vị trí hiện tại
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<void> openMapsNearMe() async {
    final pos = await _getCurrentPosition();

    // Mở Maps tại vị trí hiện tại (zoom 16)
    final uri = Uri.parse(
      'https://www.google.com/maps/@${pos.latitude},${pos.longitude},16z',
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw 'Không mở được Google Maps.';
    }
  }
}