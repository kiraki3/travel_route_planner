import 'package:flutter/material.dart';
import 'package:travel_route_planner/services/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];
  late PlaceService placeService; // PlaceService 인스턴스 추가

  @override
  void initState() {
    super.initState();
    placeService = PlaceService('api'); // API 키 전달
  }

  Future<void> searchPlaces(String input) async {
    try {
      final results = await placeService.searchPlaces(input);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 8.0),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Places',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    searchPlaces(_controller.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // 검색 결과 표시 영역
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          title: Text(place['description']), // 자동완성 결과 표시
                          onTap: () {
                            // 장소를 선택하면 상세 페이지로 이동하는 코드 추가 가능
                            print('Selected place: ${place['description']}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
