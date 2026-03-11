import 'package:flutter/material.dart';
import 'food_detail_screen.dart';

enum RegionFilter { all, bac, trung, nam }

class AllFoodsScreen extends StatefulWidget {
  final List<FoodItem> items;
  final RegionFilter initialFilter;

  const AllFoodsScreen({
    super.key,
    required this.items,
    this.initialFilter = RegionFilter.all,
  });

  @override
  State<AllFoodsScreen> createState() => _AllFoodsScreenState();
}

class _AllFoodsScreenState extends State<AllFoodsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  late RegionFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchRegion(FoodItem item) {
    if (_filter == RegionFilter.all) return true;

    final loc = item.location.toLowerCase();
    switch (_filter) {
      case RegionFilter.bac:
        return loc.contains('hà nội') || loc.contains('miền bắc') || loc.contains('bắc');
      case RegionFilter.trung:
        return loc.contains('huế') ||
            loc.contains('đà nẵng') ||
            loc.contains('quảng') ||
            loc.contains('miền trung') ||
            loc.contains('trung');
      case RegionFilter.nam:
        return loc.contains('tp.hcm') ||
            loc.contains('sài gòn') ||
            loc.contains('miền nam') ||
            loc.contains('nam');
      case RegionFilter.all:
        return true;
    }
  }

  List<FoodItem> get _filteredItems {
    final q = _query.trim().toLowerCase();
    return widget.items.where((e) {
      if (!_matchRegion(e)) return false;
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q) || e.location.toLowerCase().contains(q);
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
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tất cả món ăn'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn...',
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
          ),

          // ✅ TAB: Tất cả / Bắc / Trung / Nam
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tab(
                  text: 'Tất cả',
                  selected: _filter == RegionFilter.all,
                  onTap: () => setState(() => _filter = RegionFilter.all),
                ),
                _tab(
                  text: 'Miền Bắc',
                  selected: _filter == RegionFilter.bac,
                  onTap: () => setState(() => _filter = RegionFilter.bac),
                ),
                _tab(
                  text: 'Miền Trung',
                  selected: _filter == RegionFilter.trung,
                  onTap: () => setState(() => _filter = RegionFilter.trung),
                ),
                _tab(
                  text: 'Miền Nam',
                  selected: _filter == RegionFilter.nam,
                  onTap: () => setState(() => _filter = RegionFilter.nam),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // COUNT + RESET
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Có ${items.length} món', style: TextStyle(color: Colors.grey.shade700)),
                const Spacer(),
                if (_query.isNotEmpty || _filter != RegionFilter.all)
                  TextButton(
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() {
                        _query = '';
                        _filter = RegionFilter.all;
                      });
                    },
                    child: const Text('Đặt lại', style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // GRID
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('Không có món phù hợp.', style: TextStyle(color: Colors.grey.shade700)),
                  )
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
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openFoodDetail(item),
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
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(item.imageAsset, fit: BoxFit.cover),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.55),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                                Text(item.rating,
                                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                              shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ✅ tab style giống ảnh: selected đỏ + dấu ✓
  static Widget _tab({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.red : Colors.grey.shade400,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}