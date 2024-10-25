import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_route_planner/screens/place_detail_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 좋아요 장소 목록 불러오기
    final likedPlaces = ref.watch(likedPlacesProvider);
    // 디버깅을 위한 출력
    print('Liked Places: $likedPlaces');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Calendar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: likedPlaces.isEmpty
          ? const Center(child: Text('No liked places yet!'))
          : ListView.builder(
              itemCount: likedPlaces.length,
              itemBuilder: (context, index) {
                return const ListTile(
                    // title: Text(likedPlaces[index]['long_name'] ??
                    //     'Unknown Place'), // 장소 이름을 표시합니다.
                    );
              },
            ),
    );
  }
}
