import 'package:flutter/material.dart';
import 'package:travel_route_planner/models/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_route_planner/services/services.dart';

class PlaceDetailPage extends StatefulWidget {
  final Map<String, dynamic> place;
  final PlaceDetails placeDetails;

  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.placeDetails,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  bool isLiked = false; // 좋아요 상태 관리
  late PlaceDetailService placeDetailService;
  String memo = ''; // 메모 저장할 변수

  // 메모 입력 다이얼로그
  void _showMemoDialog() {
    final TextEditingController memoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Memo'),
          content: TextField(
            controller: memoController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your memo here...',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancle'),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    memo = memoController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('save'))
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    String apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
    placeDetailService = PlaceDetailService(apiKey); // API 키 전달
  }

  Future<PlaceDetails> _fetchPlaceDetails() async {
    return await placeDetailService.getPlaceDetails(widget.place['place_id']);
  }

  @override
  Widget build(BuildContext context) {
    final String placeName = widget.place['description'] ?? 'Unknown Place';

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
                if (isLiked) {
                  _showMemoDialog();
                } else {
                  memo = '';
                }
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
            const Text(
              'Place Name',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // 장소 이름
            Text(
              placeName,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16.0),
            // 추가 정보를 위한 Placeholder
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // API 데이터를 불러오기 위한 FutureBuilder
            FutureBuilder<PlaceDetails>(
              future: _fetchPlaceDetails(), // API 호출
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터가 로드 중일 때 로딩 화면 표시
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // 에러가 발생했을 때 에러 메시지 표시
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // 데이터가 성공적으로 로드되었을 때 화면 구성
                  PlaceDetails placeDetails = snapshot.data!;
                  return Expanded(
                    child: ListView(
                      children: [
                        Text('Address: ${placeDetails.formattedAddress}'),
                        Text(
                            'location: ${placeDetails.latitude}, ${placeDetails.longitude}'),
                        Text('Rating: ${placeDetails.rating}'),
                        const SizedBox(height: 10),
                        // 사진 표시 (if available)
                        if (placeDetails.photos.isNotEmpty)
                          SizedBox(
                            width: 350,
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: placeDetails.photos.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 350,
                                    height: 200,
                                    child: Image.network(
                                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${placeDetails.photos[index]}&key=${dotenv.env['GOOGLE_PLACES_API_KEY']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (memo.isNotEmpty) ...[
                          const SizedBox(height: 10), // 여백 추가
                          const Text(
                            'Memo:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 300,
                            height: 100,
                            padding: const EdgeInsets.all(8.0), // 패딩 추가
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey), // 테두리 색상
                              borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                            ),
                            child: Text(memo), // 저장된 메모 표시
                          ), // 저장된 메모 표시
                        ],
                      ],
                    ),
                  );
                } else {
                  // 데이터가 없는 경우
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
