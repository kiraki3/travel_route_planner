import 'package:flutter/material.dart';
import 'package:travel_route_planner/screens/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeApp() async {
  // .env 파일 로드
  await dotenv.load(fileName: 'assets/config/.env');
}

void main() {
  // 프레임워크를 초기화 한 후 앱 시작
  WidgetsFlutterBinding.ensureInitialized();
  // 앱 초기화 후 실행
  initializeApp().then((_) {
    runApp(const TravelApp());
  });
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
