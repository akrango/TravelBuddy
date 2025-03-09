import 'package:airbnb_app/components/place_card.dart';
import 'package:airbnb_app/components/search_bar.dart';
import 'package:airbnb_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SearchBarAndFilter(),
                listOfCategoryItems(size, categoryProvider),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ValueListenableBuilder<int>(
                          valueListenable: selectedIndexNotifier,
                           builder: (context, selectedIndex, child) {
                            String selectedCategoryId = categoryProvider.categories[selectedIndex].id;
                            return DisplayPlace(selectedCategoryId: selectedCategoryId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget listOfCategoryItems(Size size, CategoryProvider categoryProvider) {
    final categories = categoryProvider.categories;

    return Stack(
      children: [
        const Positioned(
          left: 0,
          right: 0,
          top: 80,
          child: Divider(
            color: Colors.black12,
          ),
        ),
        SizedBox(
          height: size.height * 0.14,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ValueListenableBuilder<int>(
                valueListenable: selectedIndexNotifier,
                builder: (context, selectedIndex, child) {
                  return GestureDetector(
                    onTap: () {
                      selectedIndexNotifier.value = index;
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selectedIndex == index
                            ? Colors.purple.shade100
                            : Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 42,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedIndex == index
                                  ? Colors.deepPurple
                                  : Colors.black45,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.network(
                                categories[index].image,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            categories[index].title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == index
                                  ? Colors.deepPurple
                                  : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 3,
                            width: 50,
                            color: selectedIndex == index
                                ? Colors.deepPurple
                                : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
