import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../main.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool voiceModeOn = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('ko-KR');
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _goSearch({String initialQuery = '', String initialCategory = ''}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SearchScreen(
          initialQuery: initialQuery,
          initialCategory: initialCategory,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'voiceFab',
        onPressed: () {
          setState(() => voiceModeOn = !voiceModeOn);
          if (voiceModeOn) {
            _tts.speak('음성 안내 모드가 켜졌습니다. 검색창을 탭하여 식당을 찾아보세요.');
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
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── 헤더 ──────────────────────────────────────────────────────────
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                          Text(
                            '배리어프리 맛집 탐색',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDark ? LucideIcons.sun : LucideIcons.moon,
                              color: isDark ? Colors.amber : Colors.blueGrey,
                            ),
                            onPressed: () {
                              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                            },
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: isDark ? Colors.grey.shade800 : Colors.blue[50],
                            child: Icon(LucideIcons.user, color: isDark ? Colors.white : Colors.blue[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 검색창 버튼 ────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => _goSearch(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: isDark ? Colors.grey.shade700 : Colors.blue.shade200, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(isDark ? 0.0 : 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.search,
                              color: Colors.blue.shade400, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            '식당명, 음식 메뉴로 검색해보세요',
                            style: TextStyle(
                                fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                          ),
                          const Spacer(),
                          Icon(LucideIcons.arrowRight,
                              size: 16, color: isDark ? Colors.grey.shade400 : Colors.blue.shade300),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── 카테고리 빠른 탐색 ─────────────────────────────────────────────
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('카테고리별 탐색',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: subTextColor)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _CategoryCard(
                        icon: LucideIcons.flame,
                        label: '한식',
                        color: isDark ? Colors.red.shade300 : Colors.red.shade400,
                        count: 10,
                        onTap: () => _goSearch(initialCategory: '한식'),
                      ),
                      const SizedBox(width: 10),
                      _CategoryCard(
                        icon: LucideIcons.utensils,
                        label: '중식',
                        color: isDark ? Colors.orange.shade300 : Colors.orange.shade500,
                        count: 10,
                        onTap: () => _goSearch(initialCategory: '중식'),
                      ),
                      const SizedBox(width: 10),
                      _CategoryCard(
                        icon: LucideIcons.wine,
                        label: '양식',
                        color: isDark ? Colors.purple.shade300 : Colors.purple.shade400,
                        count: 10,
                        onTap: () => _goSearch(initialCategory: '양식'),
                      ),
                      const SizedBox(width: 10),
                      _CategoryCard(
                        icon: LucideIcons.coffee,
                        label: '카페',
                        color: isDark ? Colors.brown.shade300 : Colors.brown.shade400,
                        count: 10,
                        onTap: () => _goSearch(initialCategory: '카페'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── 인기 검색어 ────────────────────────────────────────────────────
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.trendingUp,
                          size: 15, color: isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Text('인기 검색어',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: subTextColor)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      '갈비', '파스타', '커피', '비빔밥', '딤섬',
                      '스테이크', '마라탕', '크루아상', '순두부찌개', '라떼',
                    ].map((tag) {
                      return GestureDetector(
                        onTap: () => _goSearch(initialQuery: tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF4F6FB),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                          ),
                          child: Text(
                            '# $tag',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── 배리어프리 정보 배너 ───────────────────────────────────────────
            Container(
              color: surfaceColor,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('배리어프리 서비스 안내',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: subTextColor)),
                  const SizedBox(height: 14),
                  _AccessibilityBanner(
                    icon: LucideIcons.accessibility,
                    color: isDark ? Colors.green.shade300 : Colors.green,
                    title: '휠체어 접근 가능',
                    desc: '경사로·엘리베이터·넓은 통로 완비',
                    onTap: () => _goSearch(initialQuery: '휠체어'),
                  ),
                  const SizedBox(height: 10),
                  _AccessibilityBanner(
                    icon: LucideIcons.dog,
                    color: isDark ? Colors.teal.shade300 : Colors.teal,
                    title: '안내견 동반 가능',
                    desc: '시각장애인 안내견 동반 입장 허용',
                    onTap: () => _goSearch(initialQuery: '안내견'),
                  ),
                  const SizedBox(height: 10),
                  _AccessibilityBanner(
                    icon: LucideIcons.headphones,
                    color: isDark ? Colors.purple.shade300 : Colors.purple,
                    title: '오디오 메뉴판 제공',
                    desc: '시각장애인용 음성 메뉴 안내 지원',
                    onTap: () => _goSearch(initialQuery: '오디오'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ── 카테고리 카드 ─────────────────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(isDark ? 0.3 : 0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(isDark ? 0.25 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade800)),
              const SizedBox(height: 2),
              Text('$count곳',
                  style:
                      TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 배리어프리 배너 카드 ──────────────────────────────────────────────────────
class _AccessibilityBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const _AccessibilityBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(isDark ? 0.3 : 0.18)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey.shade800)),
                  const SizedBox(height: 2),
                  Text(desc,
                      style: TextStyle(
                          fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight,
                size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
