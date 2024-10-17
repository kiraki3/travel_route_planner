import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_route_planner/screens/place_detail_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 좋아요 장소 목록 불러오기
    final likedPlaces = ref.watch(likedPlacesProvider);
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
            ? const Center(
                child: Text('No liked Place yet.'),
              )
            : ListView.builder(
                itemCount: likedPlaces.length,
                itemBuilder: (context, index) {
                  final placeId = likedPlaces[index];
                  return ListTile(
                    title: Text('Liked Place: $placeId'),
                    // 실제 장소 정보를 가져오려면 장소 정보를 불러와서 표시하는 로직 필요
                  );
                }));
  }
}
