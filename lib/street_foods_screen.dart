import 'package:flutter/material.dart';
import 'food_detail_screen.dart';

class StreetFoodsScreen extends StatefulWidget {
  final List<FoodItem> items;

  const StreetFoodsScreen({super.key, required this.items});

  @override
  State<StreetFoodsScreen> createState() => _StreetFoodsScreenState();
}

class _StreetFoodsScreenState extends State<StreetFoodsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';
  String _region = 'Tất cả'; // Tất cả | Miền Bắc | Miền Trung | Miền Nam

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchRegion(FoodItem item) {
    if (_region == 'Tất cả') return true;
    // dựa theo chuỗi location bạn đang có: "(Hà Nội, VN)", "(Miền Trung, VN)"...
    final loc = item.location.toLowerCase();
    if (_region == 'Miền Bắc') return loc.contains('hà nội') || loc.contains('bắc');
    if (_region == 'Miền Trung') return loc.contains('huế') || loc.contains('quảng') || loc.contains('trung');
    if (_region == 'Miền Nam') return loc.contains('tp.hcm') || loc.contains('sài gòn') || loc.contains('nam');
    return true;
  }

  List<FoodItem> get _filtered {
    final q = _query.trim().toLowerCase();
    return widget.items.where((e) {
      final okRegion = _matchRegion(e);
      final okQuery = q.isEmpty ||
          e.name.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q);
      return okRegion && okQuery;
    }).toList();
  }

  void _openFoodDetail(FoodItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tinh Hoa Phố Phường'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search + filter bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm món phố phường...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        text: 'Tất cả',
                        selected: _region == 'Tất cả',
                        onTap: () => setState(() => _region = 'Tất cả'),
                      ),
                      _FilterChip(
                        text: 'Miền Bắc',
                        selected: _region == 'Miền Bắc',
                        onTap: () => setState(() => _region = 'Miền Bắc'),
                      ),
                      _FilterChip(
                        text: 'Miền Trung',
                        selected: _region == 'Miền Trung',
                        onTap: () => setState(() => _region = 'Miền Trung'),
                      ),
                      _FilterChip(
                        text: 'Miền Nam',
                        selected: _region == 'Miền Nam',
                        onTap: () => setState(() => _region = 'Miền Nam'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Có ${items.length} món',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const Spacer(),
                if (_query.isNotEmpty || _region != 'Tất cả')
                  TextButton(
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() {
                        _query = '';
                        _region = 'Tất cả';
                      });
                    },
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Grid
          Expanded(
            child: items.isEmpty
                ? _EmptyState(onClear: () {
                    _searchCtrl.clear();
                    setState(() {
                      _query = '';
                      _region = 'Tất cả';
                    });
                  })
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _StreetFoodCard(
                          item: item,
                          onTap: () => _openFoodDetail(item),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StreetFoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;

  const _StreetFoodCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item.imageAsset,
                      fit: BoxFit.cover,
                    ),
                    // gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                    // rating badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              item.rating,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // price badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.priceRange,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    // bottom title
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                children: [
                  Icon(Icons.place, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.red : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Không tìm thấy món phù hợp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Thử đổi từ khóa hoặc chọn miền khác nhé.',
              style: TextStyle(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onClear,
              child: const Text(
                'Đặt lại bộ lọc',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}