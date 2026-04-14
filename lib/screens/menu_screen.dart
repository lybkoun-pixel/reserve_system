import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/data.dart';
import 'transport_screen.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;

  const MenuScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int quantity = 1;
  String selectedSeat = '';
  final FlutterTts _tts = FlutterTts();
  bool isReading = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('ko-KR');
    _tts.setSpeechRate(0.48);
    if (widget.restaurant.seatingOptions.isNotEmpty) {
      selectedSeat = widget.restaurant.seatingOptions[0];
    }
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => isReading = false);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _readScreenAloud() {
    final r = widget.restaurant;
    final menu = r.menus.isNotEmpty ? r.menus[0] : mockRestaurants[0].menus[0];
    final text =
        '현재 보고 계신 식당은 ${r.name}입니다. '
        '위치는 ${r.location}. '
        '추천 메뉴는 ${menu.name}이며 가격은 ${menu.price}원입니다. '
        '${menu.description} '
        '현재 선택된 좌석 유형은 $selectedSeat입니다. '
        '인원은 $quantity명입니다.';
    setState(() => isReading = true);
    _tts.speak(text);
  }

  void handleReserve() {
    _tts.stop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(LucideIcons.checkCircle2, color: Colors.greenAccent),
            SizedBox(width: 8),
            Text('우선 예약이 완료되었습니다!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TransportScreen(restaurant: widget.restaurant),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final menu = r.menus.isNotEmpty ? r.menus[0] : mockRestaurants[0].menus[0];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── 헤더 이미지 ─────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.black87),
                      onPressed: () {
                        _tts.stop();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: r.id,
                    child: Image.network(r.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[200])),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 식당 기본 정보 ──────────────────────────────────
                      Text(r.name,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(LucideIcons.mapPin, size: 15, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(r.location,
                                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── 음성 읽기 버튼 (시각장애인용) ─────────────────
                      GestureDetector(
                        onTap: isReading
                            ? () {
                                _tts.stop();
                                setState(() => isReading = false);
                              }
                            : _readScreenAloud,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isReading
                                  ? [Colors.blue.shade800, Colors.blue.shade600]
                                  : [Colors.blue.shade600, Colors.blue.shade400],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isReading ? LucideIcons.square : LucideIcons.volume2,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isReading ? '읽기 중단하기 (탭하여 정지)' : '🔊 이 화면을 소리내어 읽기',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),

                      // ── 추천 메뉴 카드 ──────────────────────────────────
                      const Text('추천 메뉴', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(menu.image,
                                  width: 84, height: 84, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(width: 84, height: 84, color: Colors.grey[200])),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(menu.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(menu.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text('${menu.price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} 원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[600],
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── 접근성 정보 ──────────────────────────────────────
                      if (r.hasWheelchairRamp || r.allowsGuideDogs || r.hasAudioMenu) ...[
                        const Text('접근성 정보', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            if (r.hasWheelchairRamp)
                              _chip(LucideIcons.accessibility, '휠체어 경사로', Colors.green),
                            if (r.allowsGuideDogs)
                              _chip(LucideIcons.dog, '안내견 동반', Colors.teal),
                            if (r.hasAudioMenu)
                              _chip(LucideIcons.headphones, '오디오 메뉴판', Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],

                      // ── 좌석 선택 (배리어프리) ──────────────────────────
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(LucideIcons.armchair, color: Colors.blue[800]),
                              const SizedBox(width: 8),
                              Text('우선 예약 좌석 선택',
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                            ]),
                            const SizedBox(height: 6),
                            Text('편안한 이용을 위해 필요하신 좌석을 미리 선택해주세요.',
                                style: TextStyle(fontSize: 13, color: Colors.blue[700])),
                            const SizedBox(height: 16),
                            ...r.seatingOptions.map((seat) => InkWell(
                                  onTap: () => setState(() => selectedSeat = seat),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(seat,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: selectedSeat == seat
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                                color: selectedSeat == seat
                                                    ? Colors.blue[900]
                                                    : Colors.blue[700])),
                                        Radio<String>(
                                          value: seat,
                                          groupValue: selectedSeat,
                                          onChanged: (v) {
                                            if (v != null) setState(() => selectedSeat = v);
                                          },
                                          activeColor: Colors.blue[800],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── 하단 예약 바 ─────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.minus, size: 18),
                          onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                        ),
                        Text('$quantity 인',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(LucideIcons.plus, size: 18),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleReserve,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('지금 예약하기',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
