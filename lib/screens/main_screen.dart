import 'package:airbnb_app/screens/explore_screen.dart';
import 'package:airbnb_app/screens/favorite_screen.dart';
import 'package:airbnb_app/screens/map_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  late final List<Widget> page;

  @override
  void initState() {
    page = [
      const ExploreScreen(),
      const FavoriteScreen(),
      const MapScreen(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: (selectedIndex >= 0 && selectedIndex < page.length)
          ? page[selectedIndex]
          : const Center(child: Text("Page not found")),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          iconSize: 26,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.black45,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              debugPrint("Selected index: $selectedIndex");
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedIndex == 0
                      ? Colors.deepPurple.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Image.network(
                  "https://cdn3.iconfinder.com/data/icons/feather-5/24/search-512.png",
                  height: 28,
                  color:
                      selectedIndex == 0 ? Colors.deepPurple : Colors.black45,
                ),
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedIndex == 1
                      ? Colors.deepPurple.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.favorite_border,
                  color:
                      selectedIndex == 1 ? Colors.deepPurple : Colors.black45,
                  size: 28,
                ),
              ),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedIndex == 2
                      ? Colors.deepPurple.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Image.asset(
                  "assets/images/map.png",
                  height: 28,
                  color:
                      selectedIndex == 2 ? Colors.deepPurple : Colors.black45,
                ),
              ),
              label: "Map",
            ),
          ],
        ),
      ),
    );
  }
}
