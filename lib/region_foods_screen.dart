import 'package:flutter/material.dart';
import 'food_detail_screen.dart';

enum Region { bac, trung, nam }

class RegionFoodsScreen extends StatefulWidget {
  final Region region;
  final List<FoodItem> allItems;

  const RegionFoodsScreen({
    super.key,
    required this.region,
    required this.allItems,
  });

  @override
  State<RegionFoodsScreen> createState() => _RegionFoodsScreenState();
}

class _RegionFoodsScreenState extends State<RegionFoodsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.region) {
      case Region.bac:
        return 'Món ăn miền Bắc';
      case Region.trung:
        return 'Món ăn miền Trung';
      case Region.nam:
        return 'Món ăn miền Nam';
    }
  }

  bool _matchRegion(FoodItem item) {
    final loc = item.location.toLowerCase();

    switch (widget.region) {
      case Region.bac:
        return loc.contains('hà nội') || loc.contains('miền bắc') || loc.contains('bắc');
      case Region.trung:
        return loc.contains('huế') ||
            loc.contains('đà nẵng') ||
            loc.contains('quảng') ||
            loc.contains('miền trung') ||
            loc.contains('trung');
      case Region.nam:
        return loc.contains('tp.hcm') ||
            loc.contains('sài gòn') ||
            loc.contains('miền nam') ||
            loc.contains('nam');
    }
  }

  List<FoodItem> get _filtered {
    final q = _query.trim().toLowerCase();
    return widget.allItems.where((e) {
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
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Tìm món...',
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Có ${items.length} món',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'Chưa có món phù hợp.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
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
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(14),
                                    ),
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
                                              shadows: [
                                                Shadow(color: Colors.black, blurRadius: 8),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(item.rating),
                                      const Spacer(),
                                      Text(
                                        item.priceRange,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
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
}