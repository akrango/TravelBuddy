import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airbnb_app/providers/place_provider.dart';
import 'package:airbnb_app/models/place.dart';

class SearchBarAndFilter extends StatefulWidget {
  const SearchBarAndFilter({super.key});

  @override
  _SearchBarAndFilterState createState() => _SearchBarAndFilterState();
}

class _SearchBarAndFilterState extends State<SearchBarAndFilter> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isFocused = false;

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(() {});
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Place> getFilteredPlaces(List<Place> places) {
    if (_searchQuery.isEmpty) {
      return [];
    }
    return places
        .where((place) =>
            place.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaceProvider>(context);
    final places = provider.places;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black38,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search destinations...",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 13,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),
            _isFocused || _searchQuery.isNotEmpty
                ? places.isEmpty
                    ? const Center(child: Text("No places available"))
                    : SizedBox(
                        height:
                           170,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: getFilteredPlaces(places).length,
                          itemBuilder: (context, index) {
                            var place = getFilteredPlaces(places)[index];
                            return ListTile(
                              leading: Image.network(place.image),
                              title: Text(place.title),
                              subtitle: Text(place.address),
                              trailing: Icon(Icons.star, color: Colors.yellow),
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceDetailScreen(place: place),
                                  ),
                                ),
                              },
                            );
                          },
                        ),
                      )
                : Container(),
          ],
        ),
      ),
    );
  }
}
