import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ilsan Barrier-Free',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PhoneFrame(child: HomeScreen()),
    );
  }
}

/// 웹/데스크톱 환경에서 핸드폰 크기처럼 보여주는 래퍼
class PhoneFrame extends StatelessWidget {
  final Widget child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0D5E8), // 바깥 배경
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 40,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}
