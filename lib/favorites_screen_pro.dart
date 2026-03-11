import 'package:flutter/material.dart';

import 'favorite_service.dart';
import 'food_detail_screen.dart';

enum FavSort { newest, az, ratingDesc, priceLow, priceHigh }

class FavoritesScreenPro extends StatefulWidget {
  final List<dynamic> allItems;

  const FavoritesScreenPro({
    super.key,
    required this.allItems,
  });

  @override
  State<FavoritesScreenPro> createState() => _FavoritesScreenProState();
}

class _FavoritesScreenProState extends State<FavoritesScreenPro> {
  final FavoriteService favService = FavoriteService();
  final TextEditingController _searchCtrl = TextEditingController();

  FavSort _sort = FavSort.newest;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá tất cả yêu thích?'),
        content: const Text('Bạn có chắc muốn xoá toàn bộ danh sách yêu thích không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (ok == true) favService.clear();
  }

  // Đọc field an toàn từ item (vì model của bạn có thể là FoodItem)
  String _idOf(dynamic item) {
    try {
      return item.id.toString();
    } catch (_) {
      return '';
    }
  }

  String _nameOf(dynamic item) {
    try {
      return item.name.toString();
    } catch (_) {
      return 'Món ăn';
    }
  }

  String _imgOf(dynamic item) {
    try {
      return item.imageAsset.toString();
    } catch (_) {
      return '';
    }
  }

  String _locationOf(dynamic item) {
    try {
      return item.location.toString();
    } catch (_) {
      return '';
    }
  }

  double _ratingOf(dynamic item) {
    try {
      final r = item.rating;
      if (r is num) return r.toDouble();
      return double.tryParse(r.toString()) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  String _priceRangeOf(dynamic item) {
    try {
      return item.priceRange.toString();
    } catch (_) {
      return '';
    }
  }

  // Nếu bạn muốn sort theo giá, mình parse đại số từ chuỗi (vd "30k-50k" -> lấy 30)
  int _priceMinOf(dynamic item) {
    final s = _priceRangeOf(item);
    final digits = RegExp(r'\d+').allMatches(s).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) return 0;
    return int.tryParse(digits.first) ?? 0;
  }

  List<dynamic> _applySearchSort(List<dynamic> items) {
    final q = _searchCtrl.text.trim().toLowerCase();

    var list = items.where((item) {
      if (q.isEmpty) return true;
      final name = _nameOf(item).toLowerCase();
      final loc = _locationOf(item).toLowerCase();
      return name.contains(q) || loc.contains(q);
    }).toList();

    switch (_sort) {
      case FavSort.newest:
        // Giữ nguyên thứ tự theo allItems (món nào bạn add sau mà list không lưu timestamp thì coi như "newest" = nguyên)
        break;

      case FavSort.az:
        list.sort((a, b) => _nameOf(a).compareTo(_nameOf(b)));
        break;

      case FavSort.ratingDesc:
        list.sort((a, b) => _ratingOf(b).compareTo(_ratingOf(a)));
        break;

      case FavSort.priceLow:
        list.sort((a, b) => _priceMinOf(a).compareTo(_priceMinOf(b)));
        break;

      case FavSort.priceHigh:
        list.sort((a, b) => _priceMinOf(b).compareTo(_priceMinOf(a)));
        break;
    }

    return list;
  }

  String _sortLabel(FavSort s) {
    switch (s) {
      case FavSort.newest:
        return 'Mới nhất';
      case FavSort.az:
        return 'A–Z';
      case FavSort.ratingDesc:
        return 'Rating cao';
      case FavSort.priceLow:
        return 'Giá thấp';
      case FavSort.priceHigh:
        return 'Giá cao';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favService.favorites,
      builder: (context, favIds, _) {
        final rawFavs = widget.allItems.where((item) {
          final id = _idOf(item);
          return id.isNotEmpty && favIds.contains(id);
        }).toList();

        final favs = _applySearchSort(rawFavs);

        return Scaffold(
          appBar: AppBar(
            title: Text('Món yêu thích (${rawFavs.length})'),
            centerTitle: true,
            actions: [
              if (rawFavs.isNotEmpty)
                IconButton(
                  tooltip: 'Xoá tất cả',
                  onPressed: _confirmClearAll,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),

          body: Column(
            children: [
              // Search + Sort bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Tìm theo tên / địa điểm...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchCtrl.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<FavSort>(
                      tooltip: 'Sắp xếp',
                      onSelected: (v) => setState(() => _sort = v),
                      itemBuilder: (_) => FavSort.values
                          .map(
                            (s) => PopupMenuItem(
                              value: s,
                              child: Text(_sortLabel(s)),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sort),
                            const SizedBox(width: 6),
                            Text(_sortLabel(_sort)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: favs.isEmpty
                    ? _EmptyFavView(onBack: () => Navigator.pop(context))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                        itemCount: favs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = favs[index];
                          final id = _idOf(item);

                          return Dismissible(
                            key: ValueKey('fav_$id'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => favService.toggleFavorite(id),
                            child: _FavCard(
                              item: item,
                              isFav: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
                                );
                              },
                              onToggle: () => favService.toggleFavorite(id),
                              nameOf: _nameOf,
                              imgOf: _imgOf,
                              locationOf: _locationOf,
                              ratingOf: _ratingOf,
                              priceRangeOf: _priceRangeOf,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyFavView extends StatelessWidget {
  final VoidCallback onBack;
  const _EmptyFavView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade700),
            const SizedBox(height: 12),
            const Text(
              'Chưa có món yêu thích',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Hãy bấm ❤️ ở món bạn thích để lưu lại nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final dynamic item;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  final String Function(dynamic) nameOf;
  final String Function(dynamic) imgOf;
  final String Function(dynamic) locationOf;
  final double Function(dynamic) ratingOf;
  final String Function(dynamic) priceRangeOf;

  const _FavCard({
    required this.item,
    required this.isFav,
    required this.onTap,
    required this.onToggle,
    required this.nameOf,
    required this.imgOf,
    required this.locationOf,
    required this.ratingOf,
    required this.priceRangeOf,
  });

  @override
  Widget build(BuildContext context) {
    final name = nameOf(item);
    final img = imgOf(item);
    final loc = locationOf(item);
    final rating = ratingOf(item);
    final price = priceRangeOf(item);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: img.isEmpty
                    ? Container(
                        width: 74,
                        height: 74,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.fastfood),
                      )
                    : Image.asset(img, width: 74, height: 74, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(rating.toStringAsFixed(1)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            loc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                    if (price.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggle,
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}