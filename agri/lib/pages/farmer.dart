import 'package:agri/pages/farm_home.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FarmerPageState createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {
  final PageController _pageController = PageController();
  int _currentQuoteIndex = 0;
  bool _isButtonPressed = false;
  List<String> latestNews = [];

  final List<String> quotes = [
    "The farmer is the only man in our economy who buys everything at retail, sells everything at wholesale, and pays the freight both ways. - John F. Kennedy",
    "Agriculture is the foundation of civilization and any stable economy. - Allan Savory",
    "To forget how to dig the earth and to tend the soil is to forget ourselves. - Mahatma Gandhi",
    "Farming is a profession of hope. - Brian Brett",
    "The ultimate goal of farming is not the growing of crops, but the cultivation and perfection of human beings. - Masanobu Fukuoka",
  ];

  @override
  void initState() {
    super.initState();
    fetchAgricultureNews();

    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentQuoteIndex < quotes.length - 1) {
        _currentQuoteIndex++;
      } else {
        _currentQuoteIndex = 0;
      }
      _pageController.animateToPage(
        _currentQuoteIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> fetchAgricultureNews() async {
    // ignore: prefer_const_declarations
    final apiKey = 'fd42c595fb354bf2977ce8b5ab489326';
    final url = 'https://newsapi.org/v2/everything?q=agriculture&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          latestNews = (data['articles'] as List)
              .map((article) => article['title'].toString())
              .where((title) => !title.contains("Removed"))
              .toList();
        });
        // ignore: avoid_print
        print(latestNews);
      } else {
        // ignore: avoid_print
        print('Failed to load news');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching news: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Gradient Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
              gradient: LinearGradient(
                colors: [Colors.green[900]!.withOpacity(0.5), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Quotes section with more space
              const SizedBox(height: 100), // Adjust height as needed
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _currentQuoteIndex == index ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Text(
                            quotes[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Latest updates about agriculture
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[800]!.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest News:',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Scrollable news articles
                        SizedBox(
                          height: 250,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...latestNews.map((news) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        '• $news',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Animated Button
              GestureDetector(
                onTapDown: (_) => setState(() => _isButtonPressed = true),
                onTapUp: (_) => setState(() {
                  _isButtonPressed = false;
                  // Navigate to another page
                }),
                child: AnimatedScale(
                  scale: _isButtonPressed ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                    ),
                    onPressed: () {
                      // Navigate to another page
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>HomePage() ),
                    );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
