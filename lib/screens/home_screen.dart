import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List characters = [];
  List locations = [];
  List episodes = [];

  dynamic color(String species) {
    switch (species) {
      case 'Human':
        return Colors.blue;
      case 'Alien':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchRickAndMortyData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:  SizedBox(
          width: 195,
          child: Image.asset('assets/logo.png'), // Cambia 'assets/logo.png' por tu ruta de imagen
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black, // Cambia el color del texto de las pestañas
          unselectedLabelColor: Colors.grey, // Color para las pestañas no seleccionadas
          tabs: const [
            Tab(text: 'Characters'),
            Tab(text: 'Locations'),
            Tab(text: 'Episodes'),
          ],
        ),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 43, 153, 58),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            buildCharacterTab(width, height),
            buildLocationTab(),
            buildEpisodeTab(),
          ],
        ),
      ),
    );
  }

  Widget buildCharacterTab(double width, double height) {
    return characters.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 5,
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: InkWell(
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(top: 80),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius:  BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 140,
                                right: 15,
                                child: Text(
                                  characters[index]['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 170,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    characters[index]['species'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color(characters[index]['species']),
                                      shadows: [
                                        BoxShadow(
                                          color: color(characters[index]['species']),
                                          offset: const Offset(0, 0),
                                          spreadRadius: 1.0,
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 210,
                                left: 15,
                                child: Text(
                                  'Status: ${characters[index]['status']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 230,
                                left: 15,
                                child: Text(
                                  'Location: ${characters[index]['location']['name']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: characters[index]['image'],
                                  height: 200,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Text(
                                  '#: ${characters[index]['id']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildLocationTab() {
    return locations.isNotEmpty
        ? ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(locations[index]['name']),
                  subtitle: Text(locations[index]['type']),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildEpisodeTab() {
    return episodes.isNotEmpty
        ? ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(episodes[index]['name']),
                  subtitle: Text('Episode: ${episodes[index]['episode']}'),
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator());
  }

  void fetchRickAndMortyData() async {
    var baseUrl = Uri.https('rickandmortyapi.com', '/api');
    var response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await fetchCharacters(data['characters']);
      await fetchLocations(data['locations']);
      await fetchEpisodes(data['episodes']);
      setState(() {});
    }
  }

  Future<void> fetchCharacters(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      characters = data['results'];
    }
  }

  Future<void> fetchLocations(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      locations = data['results'];
    }
  }

  Future<void> fetchEpisodes(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      episodes = data['results'];
    }
  }
}
