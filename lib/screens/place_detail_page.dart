import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_route_planner/models/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_route_planner/services/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// 좋아요한 장소 리스트를 관리하는 Provider
final likedPlacesProvider =
    StateNotifierProvider<LikedPlacesNotifier, List<String>>((ref) {
  return LikedPlacesNotifier();
});

// 개별 장소에 대한 상태를 저장할 수 있도록 Provider를 설정
final likeProvider =
    StateNotifierProvider.family<LikeNotifier, bool, String>((ref, placeId) {
  return LikeNotifier(ref, placeId);
});

// 좋아요 장소 리스트를 관리하는 Provider
final likePlaceListProvider =
    StateNotifierProvider<LikePlaceListNotifier, List<String>>((ref) {
  return LikePlaceListNotifier();
});

// memoProvider 정의 수정
final memoProvider =
    StateNotifierProvider.family<MemoNotifier, List<Memo>, String>(
        (ref, placeId) {
  return MemoNotifier(placeId); // placeId를 전달
});

// 좋아요 상태 관리 Notifier
class LikeNotifier extends StateNotifier<bool> {
  final Ref ref;
  final String placeId;

  LikeNotifier(this.ref, this.placeId) : super(false);

  void toggleLike() {
    state = !state;
    // 좋아요 상태가 변경될 때 좋아요 리스트도 업데이트
    ref.read(likePlaceListProvider.notifier).togglePlace(placeId, state);
  }
}

// 좋아요 장소 리스트를 관리하는 Notifier
class LikePlaceListNotifier extends StateNotifier<List<String>> {
  LikePlaceListNotifier() : super([]);

  void togglePlace(String placeId, bool isLiked) {
    if (isLiked) {
      state = [...state, placeId]; // 장소 추가
    } else {
      state = state.where((id) => id != placeId).toList(); // 장소 제거
    }
  }
}

// 메모 모델 클래스
class Memo {
  final String text;
  final String category;

  Memo({required this.text, required this.category});
}

// 메모 상태 관리 Notifier
class MemoNotifier extends StateNotifier<List<Memo>> {
  final String placeId; // placeId를 저장할 변수

  MemoNotifier(this.placeId) : super([]); // 생성자에서 placeId를 초기화

  // 메모 업데이트
  void updateMemoWithCategory(String newMemo, String selectedCategory) {
    if (newMemo.isNotEmpty) {
      final memo = Memo(text: newMemo, category: selectedCategory);
      state = [...state, memo]; // 기존 메모와 함께 새로운 메모 추가
    }
  }

  // 메모 초기화 (필요에 따라)
  void clearMemo() {
    state = [];
  }
}

// 좋아요된 장소 리스트를 관리하는 Notifier
class LikedPlacesNotifier extends StateNotifier<List<String>> {
  LikedPlacesNotifier() : super([]);

  void togglePlace(String placeId, bool isLiked) {
    if (isLiked) {
      state = [...state, placeId]; // 장소 추가
    } else {
      state = state.where((id) => id != placeId).toList(); // 장소 제거
    }
  }
}

class PlaceDetailPage extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget으로 변경
  final Map<String, dynamic> place;
  final PlaceDetails placeDetails;

  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.placeDetails,
  });

  @override
  _PlaceDetailPageState createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends ConsumerState<PlaceDetailPage> {
  // ConsumerState로 변경
  late PlaceDetailService placeDetailService;
  String? selectedCategory; // 선택된 카테고리 변수 추가

  void _showMemoDialog() {
    final TextEditingController memoController = TextEditingController();

    // 저장된 장소 리스트를 가져오기
    final List<String> likedPlaces = ref.watch(likedPlacesProvider);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder로 다이얼로그 상태 관리
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                '목록에 저장',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaceCategories((category) {
                      setState(() {
                        // 선택된 카테고리 업데이트 시 다이얼로그 상태 갱신
                        selectedCategory = category;
                      });
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Memo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(memoProvider(widget.place['place_id']).notifier)
                        .updateMemoWithCategory(memoController.text,
                            selectedCategory ?? ''); // 메모 저장
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceCategories(ValueChanged<String> onCategorySelected) {
    final List<String> categories = [
      '즐겨찾기',
      '가고 싶은 장소',
      '여행 계획',
      '새 목록',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 6.0,
          children: categories.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              selectedColor: Colors.blue,
              onSelected: (selected) {
                onCategorySelected(category); // 콜백 호출하여 카테고리 업데이트
              },
            );
          }).toList(),
        ),
      ],
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

  // Google Maps 열기 함수
  void _openGoogleMaps(String formattedAddress) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$formattedAddress');
    if (await canLaunchUrl(url)) {
      // canLaunchUrl로 변경
      await launchUrl(url); // launchUrl로 변경
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String placeName = widget.place['description'] ?? 'Unknown Place';
    final bool isLiked =
        ref.watch(likeProvider(widget.place['place_id'])); // 좋아요 상태 읽기
    final List<Memo> memo =
        ref.watch(memoProvider(widget.place['place_id'])); // 메모 상태 읽기

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
              ref
                  .read(likeProvider(widget.place['place_id']).notifier)
                  .toggleLike(); // 좋아요 상태 업데이트
              if (isLiked) {
                // 좋아요 해제 시 메모도 초기화
                ref
                    .read(memoProvider(widget.place['place_id']).notifier)
                    .clearMemo();
              } else {
                _showMemoDialog(); // 좋아요 누르면 메모 입력 다이얼로그 띄우기
              }
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
                            'Location: ${placeDetails.latitude}, ${placeDetails.longitude}'),
                        // Google Maps 열기 버튼 추가
                        TextButton(
                          onPressed: () {
                            _openGoogleMaps(placeDetails.formattedAddress);
                          },
                          style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                            color: Colors.blue,
                          )),
                          child: const Text('Open in Google Maps'),
                        ),
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
                            child: ListView.builder(
                              itemCount: memo.length, // 메모의 개수에 따라 동적으로 표시
                              itemBuilder: (context, index) {
                                return Text(memo[index]
                                    .text); // Memo 객체의 text 속성을 사용하여 표시
                              },
                            ), // 저장된 메모 표시
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
