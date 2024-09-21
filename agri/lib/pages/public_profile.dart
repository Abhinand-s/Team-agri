import 'package:flutter/material.dart';

class PublicProfilePage extends StatefulWidget {
  const PublicProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PublicProfilePageState createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  List<Map<String, dynamic>> feed = [
    {
      'imageUrl': 'assets/image1.jpeg',
      'username': 'FarmerJohn',
      'caption': 'Just planted some tomatoes!',
      'likes': 0,
      'isLiked': false,
      'comments': <String>[]
    },
    {
      'imageUrl': 'assets/image2.jpeg',
      'username': 'AgriQueen',
      'caption': 'Harvesting time for my cucumbers!',
      'likes': 0,
      'isLiked': false,
      'comments': <String>[]
    },
    {
      'imageUrl': 'assets/image3.avif',
      'username': 'Ammu',
      'caption': 'Time to plant!',
      'likes': 0,
      'isLiked': false,
      'comments': <String>[]
    },
    {
      'imageUrl': 'assets/image4.jpg',
      'username': 'Farmer001',
      'caption': 'Farming is a hobby!',
      'likes': 0,
      'isLiked': false,
      'comments': <String>[]
    },
    {
      'imageUrl': 'assets/image5.jpg',
      'username': 'Farmer007',
      'caption': 'Plant some good time!',
      'likes': 0,
      'isLiked': false,
      'comments': <String>[]
    },
  ];

  void _likePost(int index) {
    setState(() {
      feed[index]['isLiked'] = !feed[index]['isLiked'];
      if (feed[index]['isLiked']) {
        feed[index]['likes']++;
      } else {
        feed[index]['likes']--;
      }
    });
  }

  void _addComment(int index, String comment) {
    setState(() {
      feed[index]['comments'].add(comment);
    });
  }

 void _navigateToProfile() {
  // Assuming the account owner details are as follows:
  String username = 'FarmerJohn'; // Replace with dynamic username
  String bio = 'Loves to grow organic vegetables.';
  int credits = 100; // Replace with actual credits

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfilePage(
        username: username,
        bio: bio,
        credits: credits,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agrigram'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: feed.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    feed[index]['username']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    feed[index]['imageUrl']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Image not found'));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    feed[index]['caption']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              feed[index]['isLiked'] ? Icons.favorite : Icons.favorite_border,
                              color: feed[index]['isLiked'] ? Colors.pink : Colors.grey,
                            ),
                            onPressed: () => _likePost(index),
                          ),
                          Text('${feed[index]['likes']}'),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          _showCommentDialog(index);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: (feed[index]['comments'] as List<String>).map<Widget>((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('- $comment', style: const TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCommentDialog(int index) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Type your comment here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  _addComment(index, commentController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

// Placeholder for UserProfilePage; implement this according to your needs
class UserProfilePage extends StatelessWidget {
  final String username;
  final String bio;
  final int credits;

  UserProfilePage({required this.username, required this.bio, required this.credits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$username\'s Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $username', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Bio: $bio', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Credits: $credits', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
