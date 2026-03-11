import 'package:flutter/material.dart';
import 'favorite_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
class FoodItem {
  final String id;
  final String name;
  final String priceRange;
  final String rating;
  final String location;
  final String story;
  final List<String> ingredients;
  final String imageAsset;

  const FoodItem({
    required this.id,
    required this.name,
    required this.priceRange,
    required this.rating,
    required this.location,
    required this.story,
    required this.ingredients,
    required this.imageAsset,
  });
}
class FoodDetailScreen extends StatefulWidget {
  final FoodItem item;
  const FoodDetailScreen({super.key, required this.item});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool get _isFav => FavoriteService().isFavorite(widget.item.id);

  void _toggleFav() {
    setState(() {
      FavoriteService().toggleFavorite(widget.item.id);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFav ? 'Đã thêm vào yêu thích' : 'Đã bỏ khỏi yêu thích'),
      ),
    );
  }
  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Bạn đang tắt định vị (GPS). Hãy bật GPS để dùng tính năng này.';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Bạn chưa cấp quyền vị trí.';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Bạn đã chặn quyền vị trí vĩnh viễn. Hãy vào Cài đặt để bật lại.';
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _openNearbyOnMaps() async {
    final pos = await _getCurrentPosition();

    // Mở Google Maps search quanh vị trí của bạn
    final query = Uri.encodeComponent('quán ăn');
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query&query_place_id=&center=${pos.latitude},${pos.longitude}',
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw 'Không mở được Google Maps.';
    }
  }
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh + nút back + tim
              Stack(
                children: [
                  Image.asset(
                    item.imageAsset,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          _isFav ? Icons.favorite : Icons.favorite_border,
                          color: _isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleFav,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên + tag
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'HUYỀN THOẠI',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating + địa điểm
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          item.rating,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.location,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Mô tả giá
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined,
                            size: 18, color: Colors.black54),
                        const SizedBox(width: 6),
                        Text(
                          'Khoảng giá: ${item.priceRange}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Câu chuyện & Hương vị',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // ✅ Nội dung dài hơn nhưng bố cục y nguyên (vẫn 1 khối text)
                    Text(
                      item.story,
                      style: const TextStyle(color: Colors.black87, height: 1.45),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Nguyên liệu nổi bật',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: item.ingredients
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '💡 Gợi ý: Hãy ăn ngay khi còn nóng để cảm nhận trọn vẹn mùi thơm và độ giòn/mềm của món. Bấm tim để lưu lại trong “Yêu thích” nhé!',
                        style: TextStyle(color: Colors.red, height: 1.35),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await _openNearbyOnMaps();
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },                        
                        child: const Text(
                          'Tìm quán gần đây',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}