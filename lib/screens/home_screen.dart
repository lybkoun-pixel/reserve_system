import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/data.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '전체';
  String searchQuery = '';
  bool voiceModeOn = false;
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('ko-KR');
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    _searchController.dispose();
    super.dispose();
  }

  List<Restaurant> get _filteredRestaurants {
    return mockRestaurants.where((r) {
      final matchCategory = selectedCategory == '전체' || r.category == selectedCategory;
      final q = searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.menus.any((m) => m.name.toLowerCase().contains(q));
      return matchCategory && matchSearch;
    }).toList();
  }

  void _handleRestaurantTap(Restaurant r) {
    if (voiceModeOn) {
      final text =
          '${r.name}. 위치는 ${r.location}. 카테고리는 ${r.category}. '
          '${r.hasWheelchairRamp ? "휠체어 접근이 가능합니다." : ""}'
          '${r.allowsGuideDogs ? " 안내견 동반이 가능합니다." : ""}'
          '${r.hasAudioMenu ? " 오디오 메뉴를 제공합니다." : ""}';
      _tts.speak(text);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen(restaurant: r)),
      );
    }
  }

  Widget _buildAccessibilityTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRestaurants;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Voice Mode Toggle FAB
          FloatingActionButton.extended(
            heroTag: 'voiceFab',
            onPressed: () {
              setState(() {
                voiceModeOn = !voiceModeOn;
              });
              if (voiceModeOn) {
                _tts.speak('음성 안내 모드가 켜졌습니다. 식당 카드를 탭하면 정보를 읽어드립니다.');
              } else {
                _tts.stop();
              }
            },
            backgroundColor: voiceModeOn ? Colors.blue[700] : Colors.white,
            foregroundColor: voiceModeOn ? Colors.white : Colors.blue[700],
            elevation: voiceModeOn ? 8 : 2,
            icon: Icon(voiceModeOn ? LucideIcons.volume2 : LucideIcons.volumeX),
            label: Text(
              voiceModeOn ? '음성모드 ON' : '음성모드 OFF',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '고양시 일산',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[600],
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '배리어프리 맛집 탐색',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: Icon(LucideIcons.user, color: Colors.blue[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 실시간 검색창 ───────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => searchQuery = val),
                            decoration: const InputDecoration(
                              hintText: '식당명, 메뉴, 지역으로 검색...',
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => searchQuery = '');
                            },
                            child: const Icon(LucideIcons.x, size: 18, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── 카테고리 필터 ──────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: mockCategories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[600] : const Color(0xFFF4F6FB),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade200,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))]
                                : [],
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── 검색 결과 수 ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
              child: Row(
                children: [
                  Text(
                    '총 ${filtered.length}개 식당',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  if (voiceModeOn) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🔊 음성모드 ON – 카드를 탭하면 정보를 읽어드립니다',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),

            // ── 식당 리스트 ───────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.searchX, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final r = filtered[index];
                        return GestureDetector(
                          onTap: () => _handleRestaurantTap(r),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 식당 이미지
                                Stack(
                                  children: [
                                    Hero(
                                      tag: r.id,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                        child: Image.network(
                                          r.imageUrl,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            height: 180,
                                            color: Colors.grey[200],
                                            child: const Center(child: Icon(LucideIcons.image, color: Colors.grey)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 카테고리 뱃지
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(r.category,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700])),
                                      ),
                                    ),
                                    // 음성모드 안내 오버레이
                                    if (voiceModeOn)
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                          child: Container(
                                            color: Colors.blue.withOpacity(0.15),
                                            child: const Center(
                                              child: Icon(LucideIcons.volume2, color: Colors.white, size: 36),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                // 식당 정보
                                Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(r.name,
                                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(LucideIcons.mapPin, size: 13, color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(r.location,
                                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),

                                      // 접근성 태그 행
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          if (r.hasWheelchairRamp)
                                            _buildAccessibilityTag(
                                                LucideIcons.accessibility, '휠체어 접근', Colors.green),
                                          if (r.allowsGuideDogs)
                                            _buildAccessibilityTag(
                                                LucideIcons.dog, '안내견 동반', Colors.teal),
                                          if (r.hasAudioMenu)
                                            _buildAccessibilityTag(
                                                LucideIcons.headphones, '오디오 메뉴', Colors.purple),
                                        ],
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
          ],
        ),
      ),
    );
  }
}
