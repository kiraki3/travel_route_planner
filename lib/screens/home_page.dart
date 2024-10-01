import 'package:flutter/material.dart';
import 'package:travel_route_planner/widgets/widgets.dart';
import 'package:travel_route_planner/screens/search_page.dart'; // 추가

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var selectedIndex = 0;

    void onItemTapped(int index) {
      switch (index) {
        case 0:
          setState(() {
            selectedIndex = index;
          });
          break;
        case 1:
          setState(() {
            selectedIndex = index;
          });
          break;
        case 2:
          // 검색 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
          break;
        case 3:
          setState(() {
            selectedIndex = index;
          });
          break;
        case 4:
          setState(() {
            selectedIndex = index;
          });
          break;
        default:
          break;
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: const Padding(
      //     padding: EdgeInsets.all(12.0),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min, // 최소 공간만 차지
      //       children: [
      //         CircleAvatar(
      //           radius: 30,
      //           backgroundImage: AssetImage('assets/images/profile.png'),
      //         ),
      //         SizedBox(width: 8.0),
      //         Text(
      //           'Chu Kyeongmin',
      //           style: TextStyle(
      //             color: Colors.black,
      //             fontSize: 14.0,
      //             fontWeight: FontWeight.w400,
      //             letterSpacing: 0.3,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Explore the \n',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Beautiful ',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'world!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Best Destination',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  DestinationCard(
                    imagePath: 'assets/images/destination1.png', // 목적지 이미지 경로
                    title: 'Niladri Reservoir',
                    location: 'Tekergat, Sunamgnj',
                    rating: 4.7,
                  ),
                  DestinationCard(
                    imagePath: 'assets/images/destination1.png',
                    title: 'Darma Valley',
                    location: 'Darma, India',
                    rating: 4.8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Calendar'),
            BottomNavigationBarItem(
              icon: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
