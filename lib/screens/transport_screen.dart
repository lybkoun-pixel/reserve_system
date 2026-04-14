import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/data.dart';

class TransportScreen extends StatefulWidget {
  final Restaurant restaurant;
  const TransportScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  bool isGuiding = false;
  String guideMessage = '';
  String guidingMethod = '';

  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('ko-KR');
    _tts.setSpeechRate(0.48);

    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);

    _tts.setCompletionHandler(() {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _animCtrl.reverse().then((_) {
              if (mounted) setState(() => isGuiding = false);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _animCtrl.dispose();
    super.dispose();
  }

  void _startGuidance(TransportInfo t) async {
    setState(() {
      guideMessage = t.guideText;
      guidingMethod = t.method;
      isGuiding = true;
    });
    _animCtrl.forward();
    await _tts.speak(t.guideText);
  }

  void _stopGuidance() {
    _tts.stop();
    _animCtrl.reverse().then((_) {
      if (mounted) setState(() => isGuiding = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black87),
          onPressed: () {
            _tts.stop();
            Navigator.pop(context);
          },
        ),
        title: const Text('이동 경로 안내',
            style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // ── 예약 완료 배너 ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.blue[600], borderRadius: BorderRadius.circular(20)),
                      child: const Text('우선 예약 확정 ✓',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.35),
                        children: [
                          TextSpan(text: widget.restaurant.name),
                          const TextSpan(
                              text: '으로\n안전하게 모시겠습니다.',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 교통수단 리스트 ────────────────────────────────────────
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Text('이동수단 선택 및 음성 안내',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('교통수단을 선택하면 상세 음성 안내가 시작됩니다.',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                      const SizedBox(height: 20),
                      ...mockTransportData.map((t) => _transportCard(t)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── 음성 안내 팝업 ────────────────────────────────────────────
          if (isGuiding) ...[
            GestureDetector(
              onTap: _stopGuidance,
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.blue.shade400, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 15))
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                        child: Icon(LucideIcons.mic, color: Colors.blue[700], size: 34),
                      ),
                      const SizedBox(height: 20),
                      Text(guidingMethod,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 8),
                      const Text('음성 안내 중...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      Text('"$guideMessage"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.6)),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: _stopGuidance,
                        icon: const Icon(LucideIcons.square, size: 16),
                        label: const Text('안내 중단'),
                        style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _transportCard(TransportInfo t) {
    final IconData iconData = t.method.contains('지하철')
        ? LucideIcons.train
        : t.method.contains('택시') || t.method.contains('지원센터') || t.method.contains('생활이동')
            ? LucideIcons.car
            : LucideIcons.bus;

    return GestureDetector(
      onTap: () => _startGuidance(t),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: t.isVisualImpairmentFriendly ? Colors.purple.shade200 : Colors.grey.shade200,
              width: t.isVisualImpairmentFriendly ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: t.isVisualImpairmentFriendly ? Colors.purple[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(iconData,
                      color: t.isVisualImpairmentFriendly ? Colors.purple[700] : Colors.blue[700]),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(t.method,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                overflow: TextOverflow.ellipsis),
                          ),
                          if (t.isVisualImpairmentFriendly)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.purple[50], borderRadius: BorderRadius.circular(8)),
                              child: Text('시각장애 맞춤',
                                  style: TextStyle(
                                      fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple[700])),
                            ),
                        ],
                      ),
                      Text('약 ${t.time} 소요',
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.volume2, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('안내', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.isVisualImpairmentFriendly ? Colors.purple[50] : Colors.yellow[50],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.accessibility,
                      size: 16,
                      color: t.isVisualImpairmentFriendly ? Colors.purple[700] : Colors.yellow[900]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(t.mobilityOption,
                        style: TextStyle(
                            fontSize: 13,
                            color: t.isVisualImpairmentFriendly ? Colors.purple[900] : Colors.yellow[900],
                            fontWeight: FontWeight.w600,
                            height: 1.4)),
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
