// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PlaceDetailPage extends StatefulWidget {
  final Map<String, dynamic> place;

  const PlaceDetailPage({
    super.key,
    required this.place,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  bool isLiked = false; // 좋아요 상태 관리

  @override
  Widget build(BuildContext context) {
    // 장소의 이름과 설명을 가져옵니다.
    final String placeName = widget.place['name'] ?? 'Unknown Place';
    final String placeDescription =
        widget.place['description'] ?? 'No description available';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Detail Place',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked; // 클릭 시 상태 반전
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 장소 이름
            Text(
              placeName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // 장소 설명
            Text(
              placeDescription,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16.0),
            // 추가 정보를 위한 Placeholder
            const Text(
              'Additional Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 예시로 다른 세부 정보를 보여주는 Widget 추가
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: [
                  // 예시로 몇 개의 추가 정보 보여주기
                  ListTile(
                    title: const Text('Location:'),
                    subtitle:
                        Text(widget.place['location'] ?? 'Unknown Location'),
                  ),
                  ListTile(
                    title: const Text('Rating:'),
                    subtitle:
                        Text(widget.place['rating']?.toString() ?? 'No rating'),
                  ),
                  ListTile(
                    title: const Text('Opening Hours:'),
                    subtitle: Text(
                        widget.place['opening_hours'] ?? 'No hours available'),
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
