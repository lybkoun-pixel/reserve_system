import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/data.dart';
import 'menu_screen.dart';

// ── 메뉴 검색 결과를 위한 헬퍼 클래스 ───────────────────────────────────────
class _MenuResult {
  final Menu menu;
  final Restaurant restaurant;
  _MenuResult({required this.menu, required this.restaurant});
}

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  final String initialCategory;

  const SearchScreen({
    Key? key,
    this.initialQuery = '',
    this.initialCategory = '',
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  String _activeCategory = '';
  late TabController _tabController;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  // 인기 검색어
  static const List<String> _popularTags = [
    '휠체어', '갈비', '파스타', '커피', '비빔밥', '딤섬', '안내견', '마라탕', '스테이크',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialQuery.isNotEmpty) {
      _query = widget.initialQuery;
      _controller.text = widget.initialQuery;
    }
    if (widget.initialCategory.isNotEmpty) {
      _activeCategory = widget.initialCategory;
      _query = widget.initialCategory;
      _controller.text = widget.initialCategory;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery.isEmpty && widget.initialCategory.isEmpty) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ── 식당 검색 결과 ─────────────────────────────────────────────────────────
  List<Restaurant> get _restaurantResults {
    if (_query.isEmpty && _activeCategory.isEmpty) return [];
    final q = _query.toLowerCase();
    return mockRestaurants.where((r) {
      // 카테고리 직접 진입인 경우 카테고리로만 필터
      if (_activeCategory.isNotEmpty && _query == _activeCategory) {
        return r.category == _activeCategory;
      }
      return r.name.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q);
    }).toList();
  }

  // ── 메뉴(음식) 검색 결과 ───────────────────────────────────────────────────
  List<_MenuResult> get _menuResults {
    if (_query.isEmpty && _activeCategory.isEmpty) return [];
    // 카테고리 직접 진입이면 해당 카테고리 음식만
    if (_activeCategory.isNotEmpty && _query == _activeCategory) {
      final results = <_MenuResult>[];
      for (final r in mockRestaurants.where((r) => r.category == _activeCategory)) {
        for (final m in r.menus) {
          results.add(_MenuResult(menu: m, restaurant: r));
        }
      }
      return results;
    }
    final q = _query.toLowerCase();
    final results = <_MenuResult>[];
    for (final r in mockRestaurants) {
      for (final m in r.menus) {
        if (m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q)) {
          results.add(_MenuResult(menu: m, restaurant: r));
        }
      }
    }
    return results;
  }

  void _onTagTap(String tag) {
    _controller.text = tag;
    setState(() => _query = tag);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
              _query = result.recognizedWords;
            });
          },
          localeId: 'ko_KR',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    );
  }

  // ── 접근성 태그 ───────────────────────────────────────────────────────────
  Widget _accessTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // ── 검색어 하이라이트 텍스트 ──────────────────────────────────────────────
  Widget _highlight(String text, String query, {TextStyle? base}) {
    if (query.isEmpty) {
      return Text(text, style: base);
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final idx = lowerText.indexOf(lowerQuery);
    if (idx < 0) return Text(text, style: base);

    final baseStyle = base ?? TextStyle(fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87);
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: baseStyle.copyWith(
              backgroundColor: Colors.blue.shade100,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = isDark ? Colors.white : Colors.black87;

    final restaurantResults = _restaurantResults;
    final menuResults = _menuResults;
    final totalResults = restaurantResults.length + menuResults.length;
    final hasQuery = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── 검색바 헤더 ─────────────────────────────────────────────────
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
              child: Row(
                children: [
                  // 뒤로가기
                  IconButton(
                    icon: Icon(LucideIcons.arrowLeft, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // 검색창
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.blue.shade200, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.search,
                              size: 18, color: Colors.blue.shade400),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: (v) => setState(() => _query = v),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
                              decoration: InputDecoration(
                                hintText: '식당, 음식, 메뉴를 검색해보세요',
                                hintStyle:
                                    TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade500 : Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _listen,
                            child: Icon(
                              _isListening ? LucideIcons.mic : LucideIcons.micOff,
                              size: 18,
                              color: _isListening ? Colors.red.shade400 : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _controller.clear();
                                setState(() => _query = '');
                                _focusNode.requestFocus();
                              },
                              child: Icon(LucideIcons.x,
                                  size: 16, color: isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 검색어 없을 때: 인기 태그 ────────────────────────────────────
            if (!hasQuery) ...[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.trendingUp,
                            size: 16, color: Colors.blue.shade600),
                        const SizedBox(width: 6),
                        Text('인기 검색어',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _popularTags.map((tag) {
                        return GestureDetector(
                          onTap: () => _onTagTap(tag),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(24),
                              border:
                                  Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.0 : 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Text('#$tag',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.blue.shade300 : Colors.blue.shade700)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    // 카테고리 바로가기
                    Text('카테고리별 탐색',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700)),
                    const SizedBox(height: 14),
                    ...['한식', '중식', '양식', '카페'].map((cat) {
                      final icon = {
                        '한식': LucideIcons.flame,
                        '중식': LucideIcons.utensils,
                        '양식': LucideIcons.wine,
                        '카페': LucideIcons.coffee,
                      }[cat]!;
                      final color = {
                        '한식': Colors.red.shade400,
                        '중식': Colors.orange.shade400,
                        '양식': Colors.purple.shade400,
                        '카페': Colors.brown.shade400,
                      }[cat]!;
                      return GestureDetector(
                        onTap: () => _onTagTap(cat),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.0 : 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(icon, size: 18, color: color),
                              ),
                              const SizedBox(width: 14),
                              Text(cat,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Icon(LucideIcons.chevronRight,
                                  size: 16, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            // ── 검색 결과 ──────────────────────────────────────────────────
            if (hasQuery) ...[
              // 탭 바
              Container(
                color: surfaceColor,
                child: TabBar(
                  controller: _tabController,
                  labelColor: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                  unselectedLabelColor: isDark ? Colors.grey.shade600 : Colors.grey,
                  indicatorColor: isDark ? Colors.blue.shade400 : Colors.blue.shade600,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.store, size: 14),
                          const SizedBox(width: 6),
                          Text('식당 ${restaurantResults.length}'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.utensils, size: 14),
                          const SizedBox(width: 6),
                          Text('음식 ${menuResults.length}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 결과 합계
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(LucideIcons.search,
                        size: 13, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                        children: [
                          TextSpan(
                              text: '"$_query"',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700)),
                          TextSpan(text: ' 검색 결과 총 $totalResults건'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 탭 뷰
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ── 식당 탭 ──────────────────────────────────────────
                    restaurantResults.isEmpty
                        ? _emptyState('식당 검색 결과가 없습니다.')
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                            itemCount: restaurantResults.length,
                            itemBuilder: (ctx, i) {
                              final r = restaurantResults[i];
                              return _RestaurantCard(
                                restaurant: r,
                                query: _query,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          MenuScreen(restaurant: r)),
                                ),
                                highlight: _highlight,
                                accessTag: _accessTag,
                              );
                            },
                          ),

                    // ── 음식 탭 ──────────────────────────────────────────
                    menuResults.isEmpty
                        ? _emptyState('음식 검색 결과가 없습니다.')
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                            itemCount: menuResults.length,
                            itemBuilder: (ctx, i) {
                              final item = menuResults[i];
                              return _MenuCard(
                                result: item,
                                query: _query,
                                formatPrice: _formatPrice,
                                highlight: _highlight,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MenuScreen(
                                          restaurant: item.restaurant)),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.searchX, size: 48, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(fontSize: 15, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
        ],
      ),
    );
  }
}

// ── 식당 카드 위젯 ────────────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final String query;
  final VoidCallback onTap;
  final Widget Function(String, String, {TextStyle? base}) highlight;
  final Widget Function(IconData, String, Color) accessTag;

  const _RestaurantCard({
    required this.restaurant,
    required this.query,
    required this.onTap,
    required this.highlight,
    required this.accessTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = restaurant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.0 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 썸네일 이미지
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.network(
                r.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: const Icon(LucideIcons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카테고리
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(r.category,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700)),
                    ),
                    const SizedBox(height: 6),
                    highlight(r.name, query,
                        base: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.mapPin,
                            size: 11, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(r.location,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        if (r.hasWheelchairRamp)
                          accessTag(LucideIcons.accessibility, '휠체어',
                              Colors.green),
                        if (r.allowsGuideDogs)
                          accessTag(LucideIcons.dog, '안내견', Colors.teal),
                        if (r.hasAudioMenu)
                          accessTag(LucideIcons.headphones, '오디오',
                              Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(LucideIcons.chevronRight,
                  size: 18, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 메뉴(음식) 카드 위젯 ─────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final _MenuResult result;
  final String query;
  final String Function(int) formatPrice;
  final Widget Function(String, String, {TextStyle? base}) highlight;
  final VoidCallback onTap;

  const _MenuCard({
    required this.result,
    required this.query,
    required this.formatPrice,
    required this.highlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final m = result.menu;
    final r = result.restaurant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.0 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 메뉴 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  m.image,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 84,
                    height: 84,
                    color: Colors.grey.shade200,
                    child: const Icon(LucideIcons.utensils, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    highlight(m.name, query,
                        base: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 5),
                    highlight(m.description, query,
                        base: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    // 가격 + 식당명
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatPrice(m.price)} 원',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700),
                        ),
                        Row(
                          children: [
                            Icon(LucideIcons.store,
                                size: 11, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Text(r.name,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
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
